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
c_range = 2:8;
% c_range = 1:length(costs);
g_range = 7:12;
% g_range = 1:length(gamma);
    figure();
    set(gcf, 'Position', [-100, -100, 560, 1260]);
for n_idx = 1:length(ns)
    n = ns(n_idx);
    subplot(4,5,n_idx + 5*(n_idx>5));
    
    temp = squeeze(test_errors(c_range,g_range,n_idx))';
    temp(temp > 19.7) = 19.7;
    contourf(costs(c_range), gamma(g_range), temp)
    
%     figure();
%     surf(costs, gamma, sqrt(squeeze(test_errors(:,:,n_idx)))')
    set(gca,'XScale','log','YScale','log')
    
%     xlabel('C'); ylabel('gamma \times N');
    title(sprintf('Test Set RMSE, N=%d',n));
%     colorbar;
    
subplot(4,5,n_idx + 5*(n_idx>5) +5);    
    temp = squeeze(avg_val_errors(c_range,g_range,n_idx))';
    temp(temp > 110) = 110;
    contourf(costs(c_range), gamma(g_range), temp)
%     set(gca,'XScale','log')
    
    
%     figure();
%     surf(costs, gamma, sqrt(squeeze(test_errors(:,:,n_idx)))')
    set(gca,'XScale','log','YScale','log')
%     xlabel('C'); ylabel('gamma \times N');
    title(sprintf('CV RMSE, N=%d',n));
%     colorbar;
end
for i = [1,6,11,16]
    subplot(4,5,i);
    ylabel('gamma \times N');
end
for i = [16:20]
    subplot(4,5,i);
        xlabel('C'); 
end
