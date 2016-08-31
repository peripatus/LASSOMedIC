         
function plotLASSOresults2D(LL)

    lambda1 = LL.lambda{1};
    lambda2 = LL.lambda{2};

    Nl1 = length(lambda1);
    Nl2 = length(lambda2);
%        beta = LL.beta;
 
%         acc = reshape(LL.acc,Nl1,Nl2);  %(1:20:end)';
%         sens = reshape(LL.sens,Nl1,Nl2);%(1:20:end)';
%         spec = reshape(LL.spec,Nl1,Nl2); %(1:20:end)';
         Fscore = reshape(LL.Fscore,Nl2,Nl1)';
        
        Mlog = reshape(mean([log(1-LL.p_spec);log(LL.p_sens)],1),Nl2,Nl1)';
        w = reshape(sum(LL.betaAll ~=0),Nl2,Nl1);
        
    %    C(:,:,1)= spec;
    %    C(:,:,2)= sens;
    %    C(:,:,3)= Fscore;

        yy  = floor(log10(lambda2(1:Nl2))*100)./100;
        xx = floor(log10(lambda1(1:2:Nl1))*100)./100;
       
        
        figure
        subplot(3,1,1)
        imagesc(flipud(Fscore'))
        title('Fscore','fontsize',16,'fontweight','demi')
        xlabel('log10(\lambda_S)','fontsize',10,'fontweight','demi')
        ylabel('log10(\lambda_G)','fontsize',10,'fontweight','demi')
        colorbar
        % set(gca,'xtick',1:2:Nl2,'xticklabel',xx,'ytick',1:Nl1,'yticklabel',yy)
        set(gca,'ytick',1:Nl2,'yticklabel',fliplr(yy),'xtick',1:2:Nl1,'xticklabel',xx)

        
        subplot(3,1,2)
      
        imagesc(flipud(Mlog'))
        title('mean log likelihood','fontsize',16,'fontweight','demi')
        xlabel('log10(\lambda_S)','fontsize',10,'fontweight','demi')
        ylabel('log10(\lambda_G)','fontsize',10,'fontweight','demi')
        
        colorbar
        %set(gca,'xtick',1:2:Nl2,'xticklabel',xx,'ytick',1:Nl1,'yticklabel',yy)
        set(gca,'ytick',1:Nl2,'yticklabel',fliplr(yy),'xtick',1:2:Nl1,'xticklabel',xx)

        
        subplot(3,1,3)
        imagesc(flipud(w'))
        title('mean number of weights','fontsize',16,'fontweight','demi')
        xlabel('log10(\lambda_S)','fontsize',10,'fontweight','demi')
        ylabel('log10(\lambda_G)','fontsize',10,'fontweight','demi')
%         set(gca,'xtick',1:2:Nl2,'xticklabel',xx,'ytick',1:Nl1,'yticklabel',yy)
        set(gca,'ytick',1:Nl2,'yticklabel',fliplr(yy),'xtick',1:2:Nl1,'xticklabel',xx)

        colorbar
%         figure
%          mesh(flipud(Mlog'))
       
       
       % set(gcf,'position',[3400 306 575 891],'paperpositionmode','auto')
 %%
        
%         figure
%         subplot(2,1,1)
%         mesh(Mlog)
%         zlabel('mean log likelihood','fontsize',16,'fontweight','demi')
%         xlabel('log(lambda2)','fontsize',12,'fontweight','demi')
%         ylabel('log(lambda1)','fontsize',12,'fontweight','demi')
%         
%         colorbar
%         set(gca,'xtick',1:2:Nl2,'xticklabel',xx,'ytick',1:Nl1,'yticklabel',yy)
%       
%         subplot(2,1,2)
%        mesh(w)
%         zlabel('mean number of weights','fontsize',16,'fontweight','demi')
%         xlabel('log(lambda2)','fontsize',12,'fontweight','demi')
%         ylabel('log(lambda1)','fontsize',12,'fontweight','demi')
%          set(gca,'xtick',1:2:Nl2,'xticklabel',xx,'ytick',1:Nl1,'yticklabel',yy)
%         colorbar
%       set(gcf,'position',[ 263   501   816   519],'paperpositionmode','auto')


