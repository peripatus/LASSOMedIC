function [fOpt,r] = getfOptz(z)

% usage: [fOpt,ML] = getfOpt(p_spec,p_sens,lambda)

    %    fd = 1:size(p_sens,2);
         r = mean(abs(z),1);
         fOpt = find(r==max(r));
       
 
