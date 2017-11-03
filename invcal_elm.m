function [model, predict_response] = invcal_elm(trX, teX, Bag_idx, Bag_prop, para)

% X N*d
% Bag_idx  N*1 
% Bag_prop  S*1
% K is a N*N matrix of the training instances

% 12-18 initial implementation

n = length(Bag_prop);
% to avoid numerical issues
Bag_prop(Bag_prop<1/size(trX,1)) = 1/size(trX,1);
Bag_prop(Bag_prop>1-1/size(trX,1)) = 1-1/size(trX,1);

%% reverse calibration, and compute mean for each group
Y = zeros(n,1);
S = zeros(n,size(trX,2));
for i = 1:n
    p = Bag_prop(i);
    Y(i) = -log(1/p-1);
    S(i,:) = sum(trX(find(Bag_idx == i),:))/length(find(Bag_idx == i));
end

model = train(Y, sparse(S), '-s 14 ?e %f', para.ep);
[learn_time, test_time, train_accuracy, test_accuracy, y]=elm([Y sparse(S)],[zeros(size(trX,1),1) trX],0,para.n,'sig');%%0 for regression

%% get predicted y on the training data
predict_response = y;
y(y>0) = 1; y(y<0) = -1;

model.y = y';
model.y_real = predict_response';
%% get predicted y on the testing data
[learn_time, test_time, train_accuracy, test_accuracy, y]=elm([Y sparse(S)],[zeros(size(teX,1),1) teX],0,para.n,'sig');%%0 for regression
predict_response = y';
end