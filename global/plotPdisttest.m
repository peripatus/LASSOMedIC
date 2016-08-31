         figure
        % probability for Control
        %hist(LL.p_spec(:,LL.fOpt),0:0.03:1)
        plot(LL.p_spec(:,LL.fOpt),'*')
        
        hold on 
          
        % probabilities for depression

        
        %hist(LL.p_sens(:,LL.fOpt),0:0.03:1)
          plot(LL.p_sens(:,LL.fOpt),'*r')
        hold on
        
        legend('probability N','probability D')
        grid
        xlabel('predicted probability')
        ylabel('occurrences')
       % ylim([0 ceil(max(get(gca,'ylim')))+1])
       % plot([0.5 0.5],[0 max(get(gca,'ylim'))],'k')
     %   axis tight
      %  set(gca,'ytick',0:ceil(max(get(gca,'ylim'))))