function [ instances, labels, maxes, means ] = series2features( x, n, d )
%UNTITLED7 Summary of this function goes here
%   n = number of features per instance
%   d = prediction distance. default is 1
switch nargin
    case 3
    case 2
        d = 1;
end

len = length(x)-n+1-d;
instances = zeros(len,n);
labels = zeros(len,1);
for i = 1:len
    instances(i,:) = x(i:i+n-1)';
    labels(i) = x(i+n-1+d);
end
% maxes = max(max(abs(instances),[],2));
means = mean(instances, 2); %len x 1

% maxes = max(abs(x));
% means = mean(instances./maxes,2);  %len x 1



% instances = (instances./maxes) - means(:,ones(1,n));
instances = instances - means(:,ones(1,n));
labels = labels - means;
maxes = max(max(abs(instances)));
if maxes ~= 0
    instances = instances ./ maxes;
    labels = labels ./maxes;
    norm_means = means ./maxes;
else
    norm_means = means;
end
% instances = (instances./maxes) - means(:,ones(1,n));
% labels = labels./maxes - means;
instances = [ norm_means instances ];

end