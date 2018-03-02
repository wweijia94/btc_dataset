function [ instances, labels, maxes, means ] = series2features( x, n )
%UNTITLED7 Summary of this function goes here
%   n = number of features per instance
len = length(x)-n;
instances = zeros(len,n);
labels = zeros(len,1);
for i = 1:len
    instances(i,:) = x(i:i+n-1)';
    labels(i) = x(i+n);
end
% maxes = max(max(abs(instances),[],2));
means = mean(instances, 2); %len x 1

% maxes = max(abs(x));
% means = mean(instances./maxes,2);  %len x 1



% instances = (instances./maxes) - means(:,ones(1,n));
instances = instances - means(:,ones(1,n));
maxes = max(max(abs(instances)));
instances = instances ./ maxes;

% instances = (instances./maxes) - means(:,ones(1,n));
% labels = labels./maxes - means;
labels = (labels - means) ./maxes;
instances = [means./maxes instances ];

end