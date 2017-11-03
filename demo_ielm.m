clear all;
% init();
datasets1 = {'sonar', 'heart', 'vote(#435#16)', 'credit-a(#690#15)', 'diabetes', 'pima-indian(#768#8)', 'splice_scale(#1000#60)'};
datasets2 = {'Musk(#6598#166)', 'magic', 'cod-rna(#59535#8)'};
fileID = fopen('result1.txt','w');

for i=1:7
fprintf(fileID,'%s\n', datasets1{i});
load(['./data/', datasets1{i}, '.mat']);
data = ScaledMatrixByColumn(data,-1,1);
kernel_type = 'linear';
bagsizeset = [2,4,8,16,32,64];
split_original = split;

tic
kernel_type = 'linear';
K = kernel_f(data, kernel_type);
toc

%5-29-2017 find the best node number
nnn = zeros(3, 40);
for b=1:6
bagsize = bagsizeset(b);
pre_avg= 0 ; nn = 5;
for N=5:5:200
para.n=N;
%%fprintf(fileID,'%d\n', para.n);

indices=crossvalind('Kfold',size(data,1),5);

invcal_elm_accuracy=zeros(5,1);

invcal_elm_time=zeros(5,1);

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

%% kernel InvCal-elm
tic
para.ep = 0;
%[learn_time, test_time, train_accuracy, test_accuracy]=elm([split.train_label trX],[split.test_label teX],0,para.n,'sig');
[model, predict_response] = invcal_elm(trX, teX, split.train_bag_idx, split.train_bag_prop, para);
toc

invcal_elm_time(k) = toc;

predict_response(predict_response>0) = 1;
predict_response(predict_response<=0) = -1;
invcal_elm_accuracy(k) = length(find(predict_response - split.test_label==0))/length(predict_response);;

end
invcal_elm_avg = mean(invcal_elm_accuracy)*100;
invcal_elm_std = std(invcal_elm_accuracy);
nnn(b,N/5) = invcal_elm_avg;
if invcal_elm_avg<pre_avg,
    invcal_elm_avg=pre_avg;
else
    pre_avg=invcal_elm_avg;
    nn=para.n;
end
end
fprintf(fileID,'%.2f$\\pm$%.2f\n', invcal_elm_avg, invcal_elm_std);
fprintf(fileID,'%d\n', nn);
fprintf(fileID,[num2str(mean(invcal_elm_time)),'s\n']);
end
end
fclose(fileID);