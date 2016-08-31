function  [joint1,joint2] = jointFeatures(features1, features2, centerT1, centerT2, size1, size2)


% get joint features
% joint1... indices for joint features in mvalues row of dataset 1
% joint2... indices for joint features in mvalues row of dataset 2

padd = centerT1-centerT2;

f1 = find(features1);
f2 = find(features2);

[x1 y1 z1] = ind2sub(size1,f1);
[x2 y2 z2] = ind2sub(size2,f2);

[cx1 cy1 cz1] = ind2sub(size1,centerT1);
[cx2 cy2 cz2] = ind2sub(size2,centerT2);



% shift 
if padd <0 
    f1 = f1 + padd;
else
    f2 = f2 + padd;
end

% find joint features
joint = intersect(f1,f2);

if padd <0 
    joint1 = joint - padd;
    joint2 = joint;
else
    joint2 = joint - padd;
    joint1 = joint;
end