function [nmvalues,scale,base] = normalize0class(mvalues,label)

%% usage [nmvalues,scale,base] = normalize0class(mvalues,label);
%% normalize using mean and std of observations which are labeled 0
%% Usage: nmvalues = normalize0class(mvalues,label);

label(label==-1) = 0;
[~, scale, base] = normalize_feature(mvalues(label==0,:),'stdeach','each');

% if the std = 0
scale(scale==0) = 1;
nmvalues = (mvalues - repmat(base,[length(label),1]))./repmat(scale, [length(label),1]);
