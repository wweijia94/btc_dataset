function [ instances, labels, maxes, means ] = series2features_mvar(x, n, d,trainInd, testInd)
%UNTITLED7 Summary of this function goes here
%   n = number of features per instance
%   d = prediction distance. default is 1
switch nargin
    case 3
    case 2
        d = 1;
end

all_set = cell(1,size(x,2));
all_labels = cell(1,size(x,2));
all_maxes = cell(1,size(x,2));
all_means = cell(1,size(x,2));
for j = 1:size(x,2)
    [all_set{j}, all_labels{j}, all_maxes{j}, all_means{j} ] = series2features( x(:,j), n, d);
end
instances = all_set{trainInd};
labels = all_labels{testInd};
maxes = all_maxes{testInd};
means = all_means{testInd};

end