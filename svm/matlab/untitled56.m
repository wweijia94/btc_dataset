figure();
subplot(2,1,1); hold on;
title('Hourly Price Changes');
plot(train_range,prices(train_range,1));
plot(test_range,prices(test_range,1));
axis tight;
ylabel('BTC price ($)');

subplot(2,1,2); hold on;
plot(train_range,prices(train_range,2));
plot(test_range,prices(test_range,2));
axis tight;
ylabel('ETH price ($)');
xlabel('hours');