% [~, n_idx] = min(min(min(test_errors(:,:,:))))
% [~, g_idx] = min(min(test_errors(:,:,n_idx)))
% [~, c_idx] = min(test_errors(:,g_idx,n_idx))

% 

n_idx = 5;
[~, g_idx] = min(min(avg_val_errors(:,:,n_idx)))
[~, c_idx] = min(avg_val_errors(:,g_idx,n_idx))
ns(n_idx)
gamma(g_idx)
costs(c_idx)

%             An m by 1 vector of training labels (type must be double).
%         -training_instance_matrix:
%             An m by n matrix of m training instances with n features.
%             It can be dense or sparse (type must be double).
%         -libsvm_options:
%             A string of training options in the same format as that of LIBSV2M.
% clear all
fig_count = 0;

% ns = [2 3 10 30 100];    %number of features
%ns = 2;
% ns = [2 3 5 8 12 16 20 25 30 35 40 45 50 60 70 80 100];
% ns = [3 6 10 15 18 20 22 25 30 50];
%ttr = .2;
%test_num = round(size(prices,1)*ttr); %test set size
test_num = 1000;
% costs = [ 0.001 0.01 0.1 1 10 100 1000];
% costs = [ 1e-3 5e-3 1e-2 5e-2 1e-1 2e-1 5e-1 1 2 5 10 20 50 100 500 1e3 ];

% gamma = [ 0.001 0.01 0.1 1 10 100 1000];
% gamma = [ 1e-3 5e-3 1e-2 3e-2 1e-1 3e-1 1e0 3e0 1e1 3e1 1e2 1e3];

d = 1;

predInd = 1;
inputs = [1];

n = ns(n_idx);
[all_set, all_labels, all_maxes, all_means] = series2features_mvar(prices, n, 1,inputs, predInd);

g = 1/n * gamma(g_idx);
c = costs(c_idx);
m = size(all_set,1) - test_num;  %number of training instances

start_index = 1;    end_index = size(all_set,1);
train_range = start_index:m;
test_range = m+1:end_index;

s = sprintf('-s 3 -t 2 -g %d -c %d', g, c);

train_set = all_set(train_range,:);
train_labels = all_labels(train_range);

test_set = all_set(test_range,:);
test_labels = all_labels(test_range);

svm_model = libsvmtrain(train_labels, train_set, s);
[test_pred_labels, test_accuracy, test_prob_estimates] = libsvmpredict(test_labels, test_set, svm_model);

usd_test_labels = (test_labels.* all_maxes + all_means(test_range));
usd_train_labels = (train_labels.* all_maxes + all_means(train_range));
usd_test_pred_labels = (test_pred_labels.* all_maxes + all_means(test_range));
%usd_train_pred_labels = (train_pred_labels.* all_maxes + all_means(train_range));


test_error = sum(((usd_test_labels-usd_test_pred_labels)) .^2)/test_num ;





figure();    clf; hold on;
subplot(2,1,1);
hold on;
plot(test_range, usd_test_labels);
plot(test_range, usd_test_pred_labels);
plot(test_range, all_means(test_range));
grid on;
ylabel('BTC price ($)');
% grid minor;
legend('actual', 'prediction',  'means');
axis tight;
ylim([-100,130])
title('Test Set Prediction Results');

subplot(2,1,2);
hold on;
plot(test_range, usd_test_labels);
plot(test_range, usd_test_pred_labels);
plot(test_range, all_means(test_range));
grid on;
grid minor;
xlabel('hours');
ylabel('BTC price ($)');
axis tight;
xlim([5200 5400])
ylim([-60 60])



figure();
subplot(2,1,1); hold on;
title('Data Set');
temp = btcavg_prices(ns(n_idx)+1:end);

plot(train_range, temp(train_range));
plot(test_range, temp(test_range));

ylabel('BTC price ($)');
axis tight;

subplot(2,1,2); hold on;
plot(train_range, prices(train_range,1));
plot(test_range, prices(test_range,1));
ylabel('price change ($)');
xlabel('hours');
axis tight;


figure();
hist(svm_model.sv_indices)
xlabel('hours');
title('Histogram of SV Indices')



% legend('actual test', 'prediction test',  'means');

%offset_test_error = sum(((usd_test_labels-offset_pred_label(test_range))) .^2)/test_num;
%offset_train_error = sum(((usd_train_labels-offset_pred_label(train_range))) .^2)/length(train_range);

%
% fprintf('\n\n\nSUMMARY______________________________\n');
% fprintf('files:\n')
% disp(btc_filename)
% disp(eth_filename)
% fprintf(sprintf('predInd=%d,\td=%d\n',predInd,d));
% fprintf('inputs:')
% disp(inputs);

% fprintf('valRMSE,\ttestRMSE,\tn,\tg_p,\tC,\tparams\n');
% for c_idx= 1:length(costs)
%     for g_idx = 1:length(gamma)
%         for n_idx = 1:length(ns)
%             n = ns(n_idx);
%             g = 1/n * gamma(g_idx);
%             c = costs(c_idx);
%             s = sprintf('-s 3 -t 2 -g %d -c %d', g, c);
%
%             test_error = test_errors(c_idx, g_idx, n_idx);
%             train_error = train_errors(c_idx, g_idx, n_idx);
%             val_error = avg_val_errors(c_idx, g_idx, n_idx);
%             fprintf(sprintf('%f,\t%f,\t%d,\t%f,\t%f,\t%s\n', val_error, test_error,n,gamma(g_idx),c,s));
%         end
%     end
% end
