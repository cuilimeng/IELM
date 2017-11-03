function [ predict_response ] = invcal_elm_predict(teX, model_d)

[predict_response, ~, ~] = predict(ones(size(teX,1),1), sparse(teX), model_d);

end