         figure
        % probability for Control
        plot(1:sum(labelg==1),LL.z(labelg ==-1,LL.fOpt),'*g')
        
        hold on 
        
        plot(N1+sum(labelg==-1),LL.z(labelg ==1,LL.fOpt),'*')
        
        legend('z N','z D')
        grid
        xlabel('test subjects')
        ylabel('z')
 %
ylim([0 ceil(max(get(gca,'ylim')))+1])
        plot([0, 0],[0 N1+N2],'k')
        
   %     set(gca,'ytick',0:ceil(max(get(gca,'ylim'))))