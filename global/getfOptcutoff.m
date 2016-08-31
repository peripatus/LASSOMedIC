function [fOpt,r] = getfOptcitoff(p_spec,p_sens)

% usage: [fOpt,ML] = getfOpt(p_spec,p_sens,lambda)

         p_spec= log(1-p_spec);
         p_sens= log(p_sens);
       
    %    fd = 1:size(p_sens,2);
         r = mean([p_spec;p_sens],1);
         fOpt = find(r==max(r));
         fOpt = fOpt(end);
         
         %% 
         
       
 
