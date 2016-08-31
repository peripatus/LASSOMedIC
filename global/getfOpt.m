function [fOpt,r] = getfOpt(p_spec,p_sens)

% usage: [fOpt,ML] = getfOpt(p_spec,p_sens,lambda)

         
         FP = sum(p_spec>0.5);
         TP = sum(p_sens>0.5);
         
         %TN = sum(p_spec<0.5);
         FN = sum(p_sens<0.5);
         
         prec = TP./(TP+FP);  %
         recall = TP./(TP+FN); % = spec
         Fscore = 2.*recall.*prec./(recall+prec);  
         
         
         Fscore(mean(p_spec>0.5)>0.75)=0;
         Fscore(mean(p_sens<0.5)>0.75)=0;
         Fscore(Fscore<0.5) = 0;
         discard = (max(Fscore)-Fscore)>0.05;%March 28 0.05 (5%) margin
                                                % june2nd 0.02?
         % flip p_spec
         p_spec= log(1-p_spec);
         p_sens= log(p_sens);
       
    %    fd = 1:size(p_sens,2);
         r = mean([p_spec;p_sens],1); 
         r(discard) = -1000;
         r(end) = []; % excludes errors at the end of lambda chain calculation
         
         fOpt = find(r==max(r));
         fOpt = fOpt(end);
       
 
