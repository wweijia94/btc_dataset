% data = csvread('btc_btc_clean.csv',8,0);
%
% data_n_10 = data(data(:,3)==10, :); %only n = 10;
%
% max_error = max(log(data_n_10(:,2)));
% min_error = min(log(data_n_10(:,2)));
% cmap = colormap(parula);
%
% figure; hold on;
% for i = 1:size(data_n_10,1)
%     color_idx = round(63*(log(data_n_10(i,2))-min_error)/(max_error-min_error))+1;
%     loglog(data_n_10(i,4), data_n_10(i,5), '.','Color', cmap(color_idx,:),'MarkerSize', 20);
%     hold all;
%
% end
% set(gca,'XScale','log','YScale','log')
%
for n_idx = 1:length(ns)
    n = ns(n_idx);
    figure();
    subplot(2,1,1);
    contourf(costs, gamma, squeeze(test_errors(:,:,n_idx))')
    set(gca,'XScale','log')
    
%     figure();
%     surf(costs, gamma, sqrt(squeeze(test_errors(:,:,n_idx)))')
%     set(gca,'XScale','log','YScale','log')
    xlabel('C'); ylabel('gamma \times n');
    title(sprintf('Test set RMSE, N=%d',n));
    colorbar;
    
    subplot(2,1,2);
    
    contourf(costs, gamma, squeeze(avg_val_errors(:,:,n_idx))')
    set(gca,'XScale','log')
    
%     figure();
%     surf(costs, gamma, sqrt(squeeze(test_errors(:,:,n_idx)))')
%     set(gca,'XScale','log','YScale','log')
    xlabel('C'); ylabel('gamma \times n');
    title(sprintf('Average Validation Set RMSE, N=%d',n));
    colorbar;
end