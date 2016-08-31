function plotLASSOresults(LL)
         
        %% Nbeta = LL.Nbeta;
            
        if isfield(LL,'model_full')
          [jlambda,ll,lf] = intersect(LL.lambda,LL.model_full.lambda);
          beta= LL.model_full.beta;
        else
            ll = 1:length(LL.lambda);
            jlambda=LL.lambda;
            lf = 1:length(LL.lambda);
            beta = LL.beta;
            beta = LL.NbetaAll;
            lambda = LL.lambda;
        end
        if isfield(LL,'accuracy')
          acc = LL.accuracy';  %(1:20:end)';
          sens = LL.sensitivity';%(1:20:end)';
          spec = LL.specificity'; %(1:20:end)';
          Fscore = LL.Fscore;
        else
            acc = LL.acc';  %(1:20:end)';
            sens = LL.sens';%(1:20:end)';
            spec = LL.spec'; %(1:20:end)';
            Fscore = LL.Fscore;
        end
        
        
        figure
        subplot(3,1,1)
        plot(log10(jlambda),sens(ll),'b.-','linewidth',2)%,spec, acc])
        hold on
        plot(log10(jlambda),spec(ll),'g.-','linewidth',2)%,spec, acc])
        %plot(log10(jlambda),acc(ll),'r','linewidth',2)%,spec, acc])
        plot(log10(jlambda),Fscore(ll),'r.-','linewidth',2)%,spec, acc])
%       plot(log10(jlambda),LL.DOR(ll)./100,'--k')%,spec, acc])
        
        plot([log10(jlambda(LL.fOpt)),log10(jlambda(LL.fOpt))],[0 1],'k')
        ylim([0 1])
        xlim(log10([min(jlambda),max(jlambda)]))
        grid

        l = legend('sensitivity','specificity','Fscore','location','best');
        set(l,'fontsize',8,'fontweight','demi')
        xlabel('log10(lambda)','fontsize',12)
        set(gca,'fontsize',12)
       
        subplot(3,1,2)
%          if size(beta,2)==1
%             bar(log10(jlambda(LL.fOpt)),sum(beta~=0));
%         else
% %             bar(log10(jlambda),sum(beta(:,lf)~=0),'linewidth',2)%,spec, acc])
            
        bar(log10(jlambda),beta,'linewidth',2)%,spec, acc])
        hold on
        plot([log10(jlambda(LL.fOpt)),log10(jlambda(LL.fOpt))],get(gca,'YLim'),'k')
%  end
        %axis([min(log10(lambda)) max(log10(lambda)) 0 1])
        xlim(log10([min(jlambda),max(jlambda)]))
        xlabel('log10(lambda)','fontsize',12)
        ylabel('#weights')
        grid
        set(gca,'fontsize',12)
        
        subplot(3,1,3)
        lhood = mean([log(1-LL.p_spec);log(LL.p_sens)]);
        plot(log10(lambda),lhood,'*')
        xlim(log10([min(jlambda),max(jlambda)]))
        hold on
        plot([log10(jlambda(LL.fOpt)),log10(jlambda(LL.fOpt))],get(gca,'YLim'),'k')
        ylabel('mean log likelihood')
        xlabel('log10(lambda)')
        grid
        
        set(gcf,'position',[1600         674   597  648],'paperpositionmode','auto')
        
        clear beta Fscore spec sens acc