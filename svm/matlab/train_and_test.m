function [ test_labels, pred_labels ] = train_and_test( x, n, s, ratio)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%         -training_label_vector:
%             An m by 1 vector of training labels (type must be double).
%         -training_instance_matrix:
%             An m by n matrix of m training instances with n features.
%             It can be dense or sparse (type must be double).
%         -libsvm_options:
%             A string of training options in the same format as that of LIBSV2M.

max_x = max(abs(x));
mean_x = mean(x);

% n =     %number of features
m = floor((length(x)-n)*(1-ratio));   %number of training instances

test_num = (length(x)-n-1)-m; %test set size

train_set = zeros(m,n);
train_labels = zeros(m,1);

test_set = zeros(test_num,n);
test_labels = zeros(test_num,1);

for i = 1:m
     train_set(i,:) = x(i:i+n-1,1);
     train_labels(i) = x(i+n);
end

for i = 1:test_num
    test_set(i,:) = x(m+i:m+i+n-1);
    test_labels(i) = x(m+i+n);
end

train_set = (train_set - mean_x)./max_x;
train_labels = (train_labels - mean_x)./max_x;
test_set = (test_set - mean_x)./max_x;
test_labels = (test_labels - mean_x)./max_x;

svm_model = libsvmtrain(train_labels, train_set, s);

[pred_labels, accuracy, prob_estimates] = libsvmpredict(test_labels, test_set, svm_model);

figure();
hold off;
plot(test_labels*max_x + mean_x);
hold on;
plot(pred_labels*max_x + mean_x);
legend('actual', 'prediction');
error = sum(((test_labels*max_x + mean_x)-(pred_labels*max_x + mean_x)).^2)/test_num


