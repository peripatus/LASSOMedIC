         
if  ~isfield(LL,'fOpt') 
    p_spec = LL.p_spec;
    p_sens = LL.p_sens;
else
    fOpt = LL.fOpt;
    % probability for Control
    p_spec = LL.p_spec(:,LL.fOpt);
    p_sens =  LL.p_spec(:,LL.fOpt); % ???
end


figure
        % probability for Control
        plot(LL.p_spec,1:Ncross,'*g','linewidth',2,'markersize',8)
        hold on 
        % probabilities for depression
        plot(LL.p_sens,(1:Ncross)+Ncross,'*','linewidth',2,'markersize',8)
      
        
        legend('probability N','probability D')
        grid
        xlabel('predicted probability')
        ylabel('subjects')
        
        set(gca,'ytick',1:2*Ncross)
        set(gca,'yticklabel',[subjects(1:Ncross);subjects(N1+1:N1+Ncross)])