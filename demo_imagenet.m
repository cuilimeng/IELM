%% training
load attrann.mat
load attfeat.mat

attrann.labels(attrann.labels==0)=-1;

results = zeros(size(attrann.labels,1)/5,size(attrann.labels,2));
accuracy = zeros(1,size(attrann.labels,2));

%
for k=1:size(attrann.labels,2)
%k=3;
split.train_label = attrann.labels(:,k);%different attributes
data = features;

split.test_label = split.train_label(5:5:end,:);
split.test_data_idx = 5:5:length(split.train_label);
split.train_data_idx = 1:length(split.train_label);

for i = size(split.train_label,1):-5:1
   split.train_label(i,:) = [];
   split.train_data_idx(:,i) = [];
end

split.train_bag_idx = zeros(length(split.train_label), 1); flagtr=1;
for i=1:length(split.train_bag_idx),
    if mod(i,20) == 0
        split.train_bag_idx(i) = flagtr;
        flagtr = flagtr + 1;
    else
        split.train_bag_idx(i) = flagtr;
    end
end

split.test_bag_idx = zeros(length(split.test_label), 1); flagte=1;
for i=1:length(split.test_bag_idx),
    if mod(i,5) == 0
        split.test_bag_idx(i) = flagte;
        flagte = flagte + 1;
    else
        split.test_bag_idx(i) = flagte;
    end
end

split.train_bag_prop = cal_prop(split.train_label, split.train_bag_idx, flagtr-1);
split.test_bag_prop = cal_prop(split.test_label, split.test_bag_idx, flagte-1);

%
trX = data(split.train_data_idx,:);
teX = data(split.test_data_idx,:);
kernel_type = 'linear';
K = kernel_f(data, kernel_type);
trK = K(split.train_data_idx, split.train_data_idx);
teK = K(split.test_data_idx, split.train_data_idx);

% para.method = 'InvCal';
% para.C = 1;
% para.ep = 0;
% result_invcal = test_all_method(trX, teX, split, trK, teK, para);
% results(:,k)=result_invcal.predicted_test_label;
% 
% result_invcal_linear = test_all_method(trX, teX, split, trK, teK, para);
% accuracy(k) = result_invcal_linear.test_acc;

para.method = 'InvCal-elm';
para.C = 1;
para.ep = 0;
para.n = 5;
result_invcal_elm = test_all_method(trX, teX, split, trK, teK, para);
accuracy(k) = result_invcal_elm.test_acc;

% para.C = 1; % empirical loss weight
% para.C_2 = 1; % proportion term weight
% para.ep = 0;
% para.method = 'alter-pSVM';
% N_random = 2;
% result = [];
% obj = zeros(N_random,1);
% for pp = 1:N_random
%     para.init_y = ones(length(trK),1);
%     r = randperm(length(trK));
%     para.init_y(r(1:floor(length(trK)/2))) = -1;
%     result{pp} = test_all_method(trX, teX, split, trK, teK, para);
%     obj(pp) = result{pp}.model.obj;
% end
% [mm,id] = min(obj);
% result_alter = result{id};
% accuracy(k) = result_alter_linear.test_acc;

% npsvmPara = NPSVM_Parameters();
% npsvmPara.KernelType = 'linear';      
% npsvmPara.C = 0.1;
% npsvmPara.KernelParas = 0.1; 
% npsvmPara.Epsilon = 0.05;
% npsvmPara.C_p = 1;
% N_random = 2;
% result = cell(1,N_random);
% Accuracy = zeros(1,N_random);
% obj = zeros(N_random,1);
% for pp = 1:N_random
%     para.init_y = ones(length(trX),1);
%     r = randperm(length(trX));
%     para.init_y(r(1:floor(length(trX)/2))) = -1;
%     [result{pp},Accuracy(pp)] = prop_npsvm_train(split, trX, para, npsvmPara);
%     obj(pp) = result{pp}.obj;
% end
% [~,id] = min(obj);
% train_best_acc = Accuracy(id);
% [predicted_label, decision_values,test_best_acc] = NPSVM_Test(teX,split.test_label, result{id});
% 
% results(:,k)=predicted_label;
end
