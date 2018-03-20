yyaxis left;
plot(btcavg_prices)
ylabel('Bticoin price')

yyaxis right;
plot(ethavg_prices)
ylabel('Ethereum price')

xlabel('time (hours) from July 2017 to March 2018');

figure()
plot(btcprices);

yyaxis right;
plot(ethprices);