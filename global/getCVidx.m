  
function  [trainIdx, testIdx] = getCVidx(subN1,subN2,crossi)
 
%% usage:      [trainIdx, testIdx] = getCVidx(subN1,subN2,crossi);
%% produce randamo indices for training data with two groups subN1, subN2 

         idx_testN1 = find(subN1 == crossi);
         idx_testN2 = find(subN2 == crossi)+length(subN1);
         testIdx = [idx_testN1,idx_testN2];
         
         idx_trainN1 = find(subN1 ~= crossi);
         idx_trainN2 = find(subN2 ~= crossi)+length(subN1);
         trainIdx = [idx_trainN1,idx_trainN2];
         