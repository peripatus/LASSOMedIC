
figure
if  ~isfield(LL,'fOpt') 
   
         hist(LL.p_spec,0.005:0.03:1)
        
        hold on 
        h = findobj(gca,'Type','patch');
        set(h,'facecolor','g','facealpha',0.75);
          
        % probabilities for depression
        hist(LL.p_sens,0:0.03:1)
else
    fOpt = LL.fOpt;
    % probability for Control
        hist(LL.p_spec(:,fOpt),0.005:0.03:1)
        
        hold on 
        h = findobj(gca,'Type','patch');
        set(h,'facecolor','g','facealpha',0.75);
          
        % probabilities for depression

        
        hist(LL.p_sens(:,fOpt),0:0.03:1)
       %   plot(LL.p_sens(:,LL.fOpt),'*r')
   
       end
  
       h = findobj(gca,'Type','patch');
        set(h,'facealpha',0.60)
        hold on
        
        legend('probability N','probability D')
        grid
        xlabel('predicted probability')
        ylabel('occurrences')
        ylim([0 ceil(max(get(gca,'ylim')))+1])
        plot([0.5 0.5],[0 max(get(gca,'ylim'))],'k')
        
 
  set(gca,'ytick',0:ceil(max(get(gca,'ylim'))))