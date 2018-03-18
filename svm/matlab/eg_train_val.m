
%             An m by 1 vector of training labels (type must be double).
%         -training_instance_matrix:
%             An m by n matrix of m training instances with n features.
%             It can be dense or sparse (type must be double).
%         -libsvm_options:
%             A string of training options in the same format as that of LIBSV2M.
clear all
fig_count = 0;

btc_filename = 'Gdax_BTCUSD_1h_new.csv';
eth_filename = 'Gdax_ETHUSD_1h_new.csv';

btcraw_prices = csvread(btc_filename, 2, 2);
btclow_prices = btcraw_prices(:,3);
btchigh_prices = btcraw_prices(:,2);
btcavg_prices = (btclow_prices + btchigh_prices)/2;
btcprices = btcavg_prices(2:end,1) - btcavg_prices(1:end-1,1);

ethraw_prices = csvread(eth_filename, 2, 2);
ethlow_prices = ethraw_prices(:,3);
ethhigh_prices = ethraw_prices(:,2);
ethavg_prices = (ethlow_prices + ethhigh_prices)/2;
ethprices = ethavg_prices(2:end,1) - ethavg_prices(1:end-1,1);
prices = [btcprices,ethprices];

% ns = [2 3 10 30 100];    %number of features
%ns = 2;
% ns = [2 3 5 8 12 16 20 25 30 35 40 45 50 60 70 80 100];
ns = [3 6 10 20 30 50];
%ttr = .2;
%test_num = round(size(prices,1)*ttr); %test set size
test_num = 1000;
% costs = [ 0.001 0.01 0.1 1 10 100 1000];
costs = [ 1 2 5 10 20 50 100 ];

% gamma = [ 0.001 0.01 0.1 1 10 100 1000];
gamma = [ 1e-2 3e-2 1e-1 3e-1 1e0 3e0 1e1 3e1 1e2];

num_val = 5;

test_errors = zeros([length(costs), length(gamma), length(ns)]);
val_errors = zeros([length(costs), length(gamma), length(ns), num_val]);
train_errors = zeros([length(costs), length(gamma), length(ns)]);
d = 1;

predInd = 1;
inputs = [1];

for n_idx = 1:length(ns)
    n = ns(n_idx);
    [all_set, all_labels, all_maxes, all_means] = series2features_mvar(prices, n, 1,inputs, predInd);
    
    for g_idx = 1:length(gamma)
        for c_idx= 1:length(costs)
            g = 1/n * gamma(g_idx);
            c = costs(c_idx);
            m = size(all_set,1) - test_num;  %number of training instances
            
            start_index = 1;    end_index = size(all_set,1);
            train_range = start_index:m;
            test_range = m+1:end_index;
            range_offset = train_range(1);
            val_length = floor(length(train_range)/num_val);
            for v_idx = 1:num_val
                val_ranges{v_idx} = range_offset+(((v_idx-1)*val_length) : (v_idx*val_length-1));
            end
            val_ranges{v_idx} = (range_offset+((v_idx-1)*val_length)):train_range(end);
            
            s = sprintf('-s 3 -t 2 -g %d -c %d', g, c);
            for v_idx = 1:num_val
                val_train_set = all_set([val_ranges{[1:(v_idx-1), (v_idx+1):end]}],:);
                val_train_labels = all_labels([val_ranges{[1:(v_idx-1), (v_idx+1):end]}]);
                
                val_set = all_set(val_ranges{v_idx},:);
                val_labels = all_labels(val_ranges{v_idx});
                
                svm_model = libsvmtrain(val_train_labels, val_train_set, s);
                [pred_labels, ~, ~] = libsvmpredict(val_labels, val_set, svm_model);
                
                usd_val_labels = val_labels.*all_maxes + all_means(val_ranges{v_idx});
                usd_pred_labels = pred_labels.*all_maxes + all_means(val_ranges{v_idx});
                val_error = sum(((usd_val_labels-usd_pred_labels)) .^2)/test_num ;
                
                val_errors(c_idx,g_idx,n_idx,v_idx) = sqrt(val_error);
            end
            train_set = all_set(train_range,:);
            train_labels = all_labels(train_range);
            
            test_set = all_set(test_range,:);
            test_labels = all_labels(test_range);
            
            [test_pred_labels, test_accuracy, test_prob_estimates] = libsvmpredict(test_labels, test_set, svm_model);
            %[train_pred_labels, train_accuracy, train_prob_estimates] = libsvmpredict(train_labels, train_set, svm_model);
            
            usd_test_labels = (test_labels.* all_maxes + all_means(test_range));
            %usd_train_labels = (train_labels.* all_maxes + all_means(train_range));
            usd_test_pred_labels = (test_pred_labels.* all_maxes + all_means(test_range));
            %usd_train_pred_labels = (train_pred_labels.* all_maxes + all_means(train_range));
            
            %    fig_count = fig_count +1;   figure(fig_count);    clf;
            %    subplot(2,1,1);
            %    hold on;
            %    plot(test_range, test_labels);
            %    plot(test_range-1+d, test_pred_labels);
            %    plot(train_range, train_labels);
            %    plot(train_range-1+d, train_pred_labels);
            %    plot(all_set(:,end));
            %    legend('actual test', 'prediction test', 'actual train', 'prediction train', 'offset');
            %    title(sprintf('normalized, %s, n=%d',s,n));
            %
            %    subplot(2,1,2);
            %    hold on;
            %    plot(test_range, usd_test_labels);
            %    plot(test_range-1+d, usd_test_pred_labels);
            %    plot(train_range, usd_train_labels);
            %    plot(train_range-1+d, usd_train_pred_labels);
            %    plot(all_means);
            %   %plot(offset_pred_label);
            %    legend('actual test', 'prediction test', 'actual train', 'prediction train', 'means');
            %    title(sprintf('usd, %s, n=%d',s,n));
            
            test_error = sum(((usd_test_labels-usd_test_pred_labels)) .^2)/test_num ;
            %train_error = sum(((usd_train_labels-usd_train_pred_labels)) .^2)/length(train_range);
            
            test_errors(c_idx, g_idx, n_idx) = sqrt(test_error);
            %train_errors(c_idx, g_idx, n_idx) = train_error;
            %fprintf(sprintf('test_err=%3e\ttrain_err=%3e\tn=%d\ts=%s\n\n\n',test_error,train_error,n,s));
        end
    end
end

avg_val_errors = sum(val_errors,4)./num_val;

% fig_count = fig_count +1;   figure(fig_count);    clf; hold on;
%
% plot(test_range, usd_test_labels);
% plot(test_range, offset_pred_label(test_range));
% plot(train_range, usd_train_labels);
% plot(train_range, offset_pred_label(train_range));
% plot(all_means);
% legend('actual test', 'prediction test', 'actual train', 'prediction train', 'means');


%offset_test_error = sum(((usd_test_labels-offset_pred_label(test_range))) .^2)/test_num;
%offset_train_error = sum(((usd_train_labels-offset_pred_label(train_range))) .^2)/length(train_range);


fprintf('\n\n\nSUMMARY______________________________\n');
fprintf('files:\n')
disp(btc_filename)
disp(eth_filename)
fprintf(sprintf('predInd=%d,\td=%d\n',predInd,d));
fprintf('inputs:')
disp(inputs);

fprintf('valRMSE,\ttestRMSE,\tn,\tg_p,\tC,\tparams\n');
for c_idx= 1:length(costs)
    for g_idx = 1:length(gamma)
        for n_idx = 1:length(ns)
            n = ns(n_idx);
            g = 1/n * gamma(g_idx);
            c = costs(c_idx);
            s = sprintf('-s 3 -t 2 -g %d -c %d', g, c);
            
            test_error = test_errors(c_idx, g_idx, n_idx);
            train_error = train_errors(c_idx, g_idx, n_idx);
            val_error = avg_val_errors(c_idx, g_idx, n_idx);
            fprintf(sprintf('%f,\t%f,\t%d,\t%f,\t%f,\t%s\n', val_error, test_error,n,gamma(g_idx),c,s));
        end
    end
end
