clear variables
close all
filenames = {'btceth_btc.mat','btceth_eth.mat'};
figcntr = 1;
hinge = 3;
names = {'RBF Kernel: BTC/ETH->BTC','RBF Kernel: BTC/ETH->ETH'};
for i = 1:length(filenames)
    load(filenames{i});
    for j = 1:size(test_errors,hinge)
        figure
        contourf(costs,gamma,sqrt(squeeze(test_errors(:,:,j))))
        set(gca, 'YScale', 'log');
        set(gca, 'XScale', 'log');
        xlabel('Cost');
        ylabel('\gamma');
        title([names{i} ', n = ' num2str(ns(j))]);
        figcntr = figcntr+1;
        colorbar
    end
end