minimax_test_errors = zeros(1,length(ns));
minmean_test_errors= zeros(1,length(ns));
minmin_test_errors= zeros(1,length(ns));

for n_idx = 1:length(ns)

    [~, g_idx] = min(min(max(val_errors(:,:,n_idx,:),[],4)));
    [~, c_idx] = min(max(val_errors(:,g_idx,n_idx,:),[],4));
    minimax_test_errors(n_idx) = test_errors(c_idx, g_idx, n_idx);

    [~, g_idx] = min(min(avg_val_errors(:,:,n_idx)));
    [~, c_idx] = min(avg_val_errors(:,g_idx,n_idx));
    minmean_test_errors(n_idx) = test_errors(c_idx, g_idx, n_idx);

end

figure();
subplot(2,1,1); hold on;
plot(ns, minmean_test_errors, 'k');
plot(ns, minmean_test_errors, 'k.');
ylabel('Test Set RMSE');
title('RMSE vs. N');

yyaxis right;
plot(ns,squeeze(min(min(avg_val_errors(:,:,:)))));
plot(ns,squeeze(min(min(avg_val_errors(:,:,:)))),'.b');
ylabel('Min Mean CV RMSE');


subplot(2,1,2); hold on;
plot(ns, minimax_test_errors, 'k');
plot(ns, minimax_test_errors,'.k'); 
ylabel('Test Set RMSE');

yyaxis right;
plot(ns,squeeze(min(min(max(val_errors(:,:,:,:),[],4)))));
plot(ns,squeeze(min(min(max(val_errors(:,:,:,:),[],4)))),'.b');
ylabel('Minimax CV RMSE');
xlabel('N');
