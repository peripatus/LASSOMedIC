function [fOpt,AUC] = getfOptAUC(Ytest, p_spec,p_sens)

% usage: [fOpt,ML] = getfOpt(p_spec,p_sens,lambda)

Zpred = [p_spec;p_sens];

parfor li = 1:size(Zpred,2);
[~,~,~,AUC(li)]=perfcurve(Ytest,Zpred(:,li),+1);
end

fOpt = find(AUC==max(AUC));
fOpt = fOpt(1);
%auc = AUC(fOpt);
       
 
