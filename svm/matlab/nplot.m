figure();
subplot(2,1,1);
hold on;
plot(ns,squeeze(min(min(avg_val_errors(:,:,:)))));
plot(ns,squeeze(min(min(avg_val_errors(:,:,:)))),'k.');
ylabel('Min. Mean CV RMSE');
title('RMSE vs. N');
grid on;

yyaxis right;
hold on;
plot(ns,squeeze(min(min(test_errors(:,:,:)))));
plot(ns,squeeze(min(min(test_errors(:,:,:)))),'k.');
ylabel('Test Set RMSE');


subplot(2,1,2); hold on;

plot(ns,squeeze(min(min(avg_val_errors(:,:,:)))));
plot(ns,squeeze(min(min(avg_val_errors(:,:,:)))),'k.');
ylabel('Min. Mean CV RMSE');
grid on;

yyaxis right;
plot(ns,squeeze(min(min(max(val_errors(:,:,:,:),[],4)))));
plot(ns,squeeze(min(min(max(val_errors(:,:,:,:),[],4)))),'k.');
ylabel('Minimax CV RMSE');
xlabel('N');
grid on;
