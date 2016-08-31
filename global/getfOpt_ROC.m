function [fOpt,r] = getfOpt_ROC(spec,sens,p_spec,p_sens)

% usage: fOpt = getfOpt(spec,sens,p_spec,p_sens,lambda)
    % distance to ROC line 
    Q1 = [0,0];  
    Q2 = [1,1];

   nlambda = length(spec(:));
   
   for li = 1:nlambda
       P=[1-spec(li),sens(li)]; 
       d(li) = det([Q2-Q1;P-Q1])/norm(Q2-Q1); 
   end

    % exclude lambda where there are no weights
    if max(d(:))==0
        fOpt =1;    
    else
      fd = find(d==max(d(:)));

        if length(fd) == 1
           fOpt = fd;
       else
       
%      figure
%         subplot(2,1,1)
%         imagesc(p_spec)
%         hold on
%         subplot(2,1,2)
%         imagesc(p_sens)
%         
%         figure
%         subplot(2,1,1)
%         imagesc(log(p_spec))
%         hold on
%         subplot(2,1,2)
%         imagesc(log(p_sens))
%      
         p_spec= log(1-p_spec);
         p_sens= log(p_sens);
       
    %    fd = 1:size(p_sens,2);
         r = mean([p_spec(:,fd);p_sens(:,fd)]);
         fOpt = fd(r==max(r));
       
         
      %  r = abs(mean(p_spec,1)-mean(p_sens,1));
      %  fOpt = find(r==max(r));
            
          %  min(r)
%             p_spec= log(p_spec./(1+p_spec));
%             p_sens= log(p_sens./(1+p_sens));
%             
         %    r = - (abs(median(p_spec(:,fd),1)-median(p_sens(:,fd),1)))+std(p_spec(:,fd),0,1)+std(p_sens(:,fd),0,1);
         %    fOpt = fd(r==min(r));
     end
     end
end
