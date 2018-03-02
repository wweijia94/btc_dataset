close all
if (~exist('dataFlag','var'))
    data = csvread('../svm/matlab/Gdax_BTCUSD_1h.csv', 2,2);
    dataFlag = 1;
end
closing = data(:,4)';
start = 1;
iter = 1000;
last = iter+start-1;
linear_offset = closing(start+1:iter+start);
figure
plot(start:last, closing(start:last), (start+1):(last+1), linear_offset);
mse_offset = immse(closing(start:last),linear_offset);
display(['MSE OFFSET: ' num2str(mse_offset)]);
legend('Actual','Offset');


segmentLen = [2:9,10:10:50];
for i = segmentLen
    result = zeros(1,iter-i);
    cnt = 1;
    for j = start:last-i
        linfit = fit((start+j-1:start+j+i-2)', closing(start+j-1:start+j+i-2)', 'poly1');
        result(cnt) = linfit(start+j+i-1);
        cnt = cnt+1;
    end
    figure
    plot(start:last, closing(start:last));
    hold on
    plot(start+i:last, result, 'r');
    display(['SegLen=' num2str(i) ', MSE=' num2str(immse(closing(start+i:last), result))]);
end