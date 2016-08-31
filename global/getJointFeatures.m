function  [joint1,joint2] = jointFeatures(features1, features2, centerT1, centerT2,sizeVol1,sizeVol2);


% get joint features
% joint1... indices for joint features in features vector of dataset 1
% joint2... indices for joint features in features vector of dataset 2

vol1 = double(reshape(features1,sizeVol1));
vol2 = double(reshape(features2,sizeVol2));

if sum(sizeVol1)<sum(sizeVol2)
    tmp = vol2;
  %  tmp(centerT2(1),centerT2(2),centerT2(3)) = 4;
    tmptmp = tmp(centerT2(1)- centerT1(1)+1:centerT2(1)-centerT1(1)+sizeVol1(1),...
        centerT2(2)- centerT1(2)+1:centerT2(2)-centerT1(2)+sizeVol1(2),...
        centerT2(3)- centerT1(3)+1:centerT2(3)-centerT1(3)+sizeVol1(3))+vol1;
    
    tmp(centerT2(1)- centerT1(1)+1:centerT2(1)-centerT1(1)+sizeVol1(1),...
        centerT2(2)- centerT1(2)+1:centerT2(2)-centerT1(2)+sizeVol1(2),...
        centerT2(3)- centerT1(3)+1:centerT2(3)-centerT1(3)+sizeVol1(3)) =  tmptmp ;
    
    joint2 = find((tmp) == 2);
    joint1 = find(tmptmp == 2);
else
    tmp = vol1;
  %  tmp(centerT1(1),centerT1(2),centerT1(3)) = 4;
    tmptmp =  tmp(centerT1(1)- centerT2(1)+1:centerT1(1)-centerT2(1)+sizeVol2(1),...
        centerT1(2)- centerT2(2)+1:centerT1(2)-centerT2(2)+sizeVol2(2),...
        centerT1(3)- centerT2(3)+1:centerT1(3)-centerT2(3)+sizeVol2(3))+vol2;
    tmp(centerT1(1)- centerT2(1)+1:centerT1(1)-centerT2(1)+sizeVol2(1),...
        centerT1(2)- centerT2(2)+1:centerT1(2)-centerT2(2)+sizeVol2(2),...
        centerT1(3)- centerT2(3)+1:centerT1(3)-centerT2(3)+sizeVol2(3)) = tmptmp;
    joint1 = (find(tmp) == 2);
    joint2 = find(tmptmp == 2);
end




