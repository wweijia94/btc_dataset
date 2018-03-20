function [ y, ylabel] = usd2norm( train, train_label )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%   Each feature of x is a row vector: x(i,:) is the i-th training vector
max_x = max(abs(x),[],2);
mean_x = mean(x);

y = (x./max_x) - mean_x;

end

