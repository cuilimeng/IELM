clear all;
% init();
datasets1 = {'sonar', 'heart', 'vote(#435#16)', 'credit-a(#690#15)', 'diabetes', 'pima-indian(#768#8)', 'splice_scale(#1000#60)'};
datasets2 = {'Musk(#6598#166)', 'magic', 'cod-rna(#59535#8)'};
fileID = fopen('result1.txt','w');

for i=1:7
fprintf(fileID,'%s\n', datasets1{i});
load(['./data/', datasets1{i}, '.mat']);
data = ScaledMatrixByColumn(double(data),-1,1);
kernel_type = 'linear';
K = kernel_f(data, kernel_type);
bagsizeset = [2,4,8,16,32,64];
split_original = split;

for b=1:6
bagsize = bagsizeset(b);
fprintf(fileID,'%d\n', bagsize);
% kernel_type = 'linear';
% K = kernel_f(data, kernel_type);

indices=crossvalind('Kfold',size(data,1),5);

invcal_elm_accuracy=zeros(5,1);
invcal_accuracy=zeros(5,1);
alter_accuracy=zeros(5,1);
conv_accuracy=zeros(5,1);

invcal_elm_time=zeros(5,1);
invcal_time=zeros(5,1);
alter_time=zeros(5,1);
conv_time=zeros(5,1);

for k=1:5
split = split_original;
split.test_data_idx = (indices == k); 
split.train_data_idx = ~split.test_data_idx;

teX = data(split.test_data_idx,:);
split.test_label = split.train_label(split.test_data_idx,:);
trX = data(split.train_data_idx,:);
split.train_label = split.train_label(split.train_data_idx,:);

[split.train_bag_idx, bagnumtr] = split_dataset(split.train_label, bagsize);
[split.test_bag_idx, bagnumte] = split_dataset(split.test_label, bagsize);

split.train_bag_prop = cal_prop(split.train_label, split.train_bag_idx, bagnumtr);
split.test_bag_prop = cal_prop(split.test_label, split.test_bag_idx, bagnumte);

trK = K(split.train_data_idx, split.train_data_idx);
teK = K(split.test_data_idx, split.train_data_idx);
% trK = [];
% teK = [];

%% kernel InvCal
tic
para.method = 'InvCal';
para.C = 1;
para.ep = 0;
result_invcal = test_all_method(trX, teX, split, trK, teK, para);
toc

invcal_time(k) = toc;

%% kernel alter-pSVM with anealing
tic
para.C = 1; % empirical loss weight
para.C_2 = 1; % proportion term weight
para.ep = 0;
para.method = 'alter-pSVM';
N_random = 5;
result = [];
obj = zeros(N_random,1);
for pp = 1:N_random
    para.init_y = ones(length(trK),1);
    r = randperm(length(trK));
    para.init_y(r(1:floor(length(trK)/2))) = -1;
    result{pp} = test_all_method(trX, teX, split, trK, teK, para);
    obj(pp) = result{pp}.model.obj;
end
[mm,id] = min(obj);
result_alter = result{id};
toc
% alter_time(k) = toc;

%%
npsvmPara = NPSVM_Parameters();
npsvmPara.KernelType = 'linear';      
npsvmPara.C = 0.1;
npsvmPara.KernelParas = 0.1; 
npsvmPara.Epsilon = 0.05;
npsvmPara.C_p = 1;
N_random = 2;
result = cell(1,N_random);
Accuracy = zeros(1,N_random);
obj = zeros(N_random,1);
for pp = 1:N_random
    para.init_y = ones(length(trX),1);
    r = randperm(length(trX));
    para.init_y(r(1:floor(length(trX)/2))) = -1;
    [result{pp},Accuracy(pp)] = prop_npsvm_train(split, trX, para, npsvmPara);
    obj(pp) = result{pp}.obj;
end
[~,id] = min(obj);
train_best_acc = Accuracy(id);
[predicted_label, decision_values,test_best_acc] = NPSVM_Test(teX,split.test_label, result{id});

%%
invcal_accuracy(k) = result_invcal.test_acc;
alter_accuracy(k) = result_alter.test_acc;
pnpsvm_accuracy(k) = test_best_acc;

end
invcal_avg = mean(invcal_accuracy)*100;
alter_avg = mean(alter_accuracy)*100;
pnpsvm_avg = mean(pnpsvm_accuracy)*100;

invcal_std = std(invcal_accuracy);
alter_std = std(alter_accuracy);
pnpsvm_std = std(pnpsvm_accuracy);

fprintf(fileID,'%.2f\\%%\\pm%.2f\n', invcal_avg, invcal_std);
fprintf(fileID,'%.2f\\%%\\pm%.2f\n', alter_avg, alter_std);
fprintf(fileID,'%.2f\\%%\\pm%.2f\n', pnpsvm_avg, pnpsvm_std);

fprintf(fileID,[num2str(mean(invcal_time)),'s\n']);
fprintf(fileID,[num2str(mean(alter_time)),'s\n']);
fprintf(fileID,[num2str(mean(pnpsvm_time)),'s\n']);
end
end
fclose(fileID);