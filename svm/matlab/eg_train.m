%         -training_label_vector:
%             An m by 1 vector of training labels (type must be double).
%         -training_instance_matrix:
%             An m by n matrix of m training instances with n features.
%             It can be dense or sparse (type must be double).
%         -libsvm_options:
%             A string of training options in the same format as that of LIBSV2M.

prices = csvread('Gdax_BTCUSD_1h.csv', 2, 5);
prices = prices(:,1);

max_price = max(abs(prices));
mean_price = mean(prices);

n = 100;    %number of features
m = 3000;   %number of training instances

test_num = 1000; %test set size

train_set = zeros(m,n);
train_labels = zeros(m,1);

test_set = zeros(test_num,n);
test_labels = zeros(test_num,1);

for i = 1:m
     train_set(i,:) = prices(i:i+n-1,1);
     train_labels(i) = prices(i+n);
end

for i = 1:test_num
    test_set(i,:) = prices(m+i:m+i+n-1);
    test_labels(i) = prices(m+i+n);
end

train_set = (train_set - mean_price)./max_price;
train_labels = (train_labels - mean_price)./max_price;
test_set = (test_set - mean_price)./max_price;
test_labels = (test_labels - mean_price)./max_price;

svm_model = libsvmtrain(train_labels, train_set, '-s 3 -t 2 ');
[predicted_label, accuracy, prob_estimates] = libsvmpredict(test_labels, test_set, svm_model);
