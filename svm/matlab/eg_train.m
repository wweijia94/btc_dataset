%         -training_label_vector:
%             An m by 1 vector of training labels (type must be double).
%         -training_instance_matrix:
%             An m by n matrix of m training instances with n features.
%             It can be dense or sparse (type must be double).
%         -libsvm_options:
%             A string of training options in the same format as that of LIBSV2M.

prices = csvread('Gdax_BTCUSD_1h.csv', 2, 5);
prices = prices(:,1);

n = 100;    %number of features
test_num = 2000; %test set size
m = length(prices)-n-test_num;  %number of training instances

[ all_set, all_labels, all_maxes, all_means ] = series2features( prices, n );

train_range = 1:m;
test_range = m+1:length(all_labels);

train_set = all_set(train_range,n);
train_labels = all_labels(train_range);

test_set = all_set(test_range,n);
test_labels = all_labels(test_range);

s = '-s 3 -t 2 -c 100000';
svm_model = libsvmtrain(train_labels, train_set, s);
[test_pred_labels, test_accuracy, test_prob_estimates] = libsvmpredict(test_labels, test_set, svm_model);
[train_pred_labels, train_accuracy, train_prob_estimates] = libsvmpredict(train_labels, train_set, svm_model);

usd_test_labels = (test_labels + all_means(test_range)) .* all_maxes; 
usd_train_labels = (train_labels + all_means(train_range)) .* all_maxes; 
usd_test_pred_labels = (test_pred_labels + all_means(test_range)) .* all_maxes; 
usd_train_pred_labels = (train_pred_labels + all_means(train_range)) .* all_maxes; 

figure(100);    clf;
hold on;
plot(test_range, test_labels);
plot(test_range, test_pred_labels);
plot(train_range, train_labels);
plot(train_range, train_pred_labels);
legend('actual test', 'prediction test', 'actual train', 'prediction train');
title('test and train normalized');

figure(101);    clf;
hold on;
plot(test_range, usd_test_labels);
plot(test_range, usd_test_pred_labels);
plot(train_range, usd_train_labels);
plot(train_range, usd_train_pred_labels);
title('test and train usd');

test_error = sum(((test_labels-test_pred_labels)*all_maxes) .^2)/test_num 
train_error = sum(((train_labels-train_pred_labels)*all_maxes) .^2)/m * all_maxes

n
s
