function [fOpt,AUC,r] = getfOptAUC_L(Ytest, p_spec,p_sens)

% usage: [fOpt,ML] = getfOpt(p_spec,p_sens,lambda)

Zpred = [p_spec;p_sens];

parfor li = 1:size(Zpred,2);
    [~,~,~,AUC(li)]=perfcurve(Ytest,Zpred(:,li),+1);
end

fOpt = find(AUC==max(AUC));
r =  mean([log(1-p_spec);log(p_sens)],1);

if length(fOpt)>1
       R = r(fOpt);
       fOpt = fOpt(R==max(R));
end

       
 
