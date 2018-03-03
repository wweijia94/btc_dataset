
%             An m by 1 vector of training labels (type must be double).
%         -training_instance_matrix:
%             An m by n matrix of m training instances with n features.
%             It can be dense or sparse (type must be double).
%         -libsvm_options:
%             A string of training options in the same format as that of LIBSV2M.

fig_count = 0;

raw_prices = csvread('Gdax_BTCUSD_1h.csv', 2, 2);
low_prices = raw_prices(:,3);
high_prices = raw_prices(:,2);
avg_prices = (low_prices + high_prices)/2;
prices = avg_prices(2:end,1) - avg_prices(1:end-1,1);
%prices = (1:1500);
% t = (1:4000)';
% prices = randn(4000,1)+sin(0.001.*t)+0.001*t;
% prices = sin(0.1.*t);

% ns = [1 2 3 10 30 100];    %number of features
% ns = 1;
ns = [3 30 100];
% ns = [100];
test_num = 500; %test set size
d = 10;  %prediction distance

costs = [ 0.01 0.1 1 10 100];
% costs = [ 0.1 1];
% costs = [ 1 ];

gamma = [ 0.01 0.1 1 10 100];
% gamma = [ 0.1 1 ];
% gamma = [ 1 ];

test_errors = zeros([length(costs), length(gamma), length(ns)]);
train_errors = zeros([length(costs), length(gamma), length(ns)]);

for n_idx = 1:length(ns)
    n = ns(n_idx);
    [ all_set, all_labels, all_maxes, all_means ] = series2features( prices, n, d);

    m = size(all_set,1) - test_num;  %number of training instances
    start_index = 1;
    end_index = size(all_set,1);

    train_range = start_index:m;
    test_range = m+1:end_index;
    offset_pred_label = all_set(:,end) .* all_maxes + all_means;
for g_idx = 1:length(gamma)
for c_idx= 1:length(costs)
    g = 1/n * gamma(g_idx);
    c = costs(c_idx);

    train_set = all_set(train_range,:);
    train_labels = all_labels(train_range);

    test_set = all_set(test_range,:);
    test_labels = all_labels(test_range);

    s = sprintf('-s 3 -t 2 -g %d -c %d', g, c);
    svm_model = libsvmtrain(train_labels, train_set, s);
    [test_pred_labels, test_accuracy, test_prob_estimates] = libsvmpredict(test_labels, test_set, svm_model);
    [train_pred_labels, train_accuracy, train_prob_estimates] = libsvmpredict(train_labels, train_set, svm_model);

    usd_test_labels = (test_labels.* all_maxes + all_means(test_range)); 
    usd_train_labels = (train_labels.* all_maxes + all_means(train_range)); 
    usd_test_pred_labels = (test_pred_labels.* all_maxes + all_means(test_range)); 
    usd_train_pred_labels = (train_pred_labels.* all_maxes + all_means(train_range)); 

    fig_count = fig_count +1;   figure(fig_count);    clf;
    subplot(2,1,1);
    hold on;
    plot(test_range, test_labels);
    plot(test_range-1+d, test_pred_labels);
    plot(train_range, train_labels);
    plot(train_range-1+d, train_pred_labels);
    plot(all_set(:,end));
    legend('actual test', 'prediction test', 'actual train', 'prediction train', 'offset label');
    title(sprintf('normalized, %s, n=%d',s,n));

    subplot(2,1,2); 
    hold on;
    plot(test_range, usd_test_labels);
    plot(test_range-1+d, usd_test_pred_labels);
    plot(train_range, usd_train_labels);
    plot(train_range-1+d, usd_train_pred_labels);
    plot(all_means);
    plot(offset_pred_label);
    legend('actual test', 'prediction test', 'actual train', 'prediction train', 'means', 'offset label');
    title(sprintf('usd, %s, n=%d',s,n));

    test_error = sum(((usd_test_labels-usd_test_pred_labels)) .^2)/test_num ;
    train_error = sum(((usd_train_labels-usd_train_pred_labels)) .^2)/length(train_range);

    test_errors(c_idx, g_idx, n_idx) = test_error;
    train_errors(c_idx, g_idx, n_idx) = train_error;
    fprintf(sprintf('test_err=%3e\ttrain_err=%3e\tn=%d\ts=%s\n\n\n',test_error,train_error,n,s));
end
end
end

offset_test_error = sum(((usd_test_labels-offset_pred_label(test_range))) .^2)/test_num;
offset_train_error = sum(((usd_train_labels-offset_pred_label(train_range))) .^2)/length(train_range);


fprintf('trainMSE,\ttestMSE,\tn,\tg_p,\tC,\tparams\n');
for c_idx= 1:length(costs)
for g_idx = 1:length(gamma)
for n_idx = 1:length(ns)
    n = ns(n_idx);
    g = gamma(g_idx);
    c = costs(c_idx);
    test_error = test_errors(c_idx, g_idx, n_idx);
    train_error = train_errors(c_idx, g_idx, n_idx);
    fprintf(sprintf('%f,\t%f,\t%d,\t%f,\t%f,\t%s\n', train_error, test_error,n,g,c,s));
end
end
end
