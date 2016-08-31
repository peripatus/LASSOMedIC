
%function computeCVStatistics(DatasetName,method,Max_S)


%
% Draw the distribution of discriminativescore
%
Zpred_sens = LL.Zpred_sens; %%?? why is there a minus???
Zpred_spec = LL.Zpred_spec;
   
Ytest = repmat(label,1,Nshuffle)';
   
% Compute the distribution
DS=[Zpred_sens(:);Zpred_spec(:)];

MaxAbsDS=max(abs(DS));
DS=DS/MaxAbsDS;
B=-1.05:0.05:+1.05;
[Np,~]=hist(DS(1:length(Zpred_sens(:))),B);
[Nn,~]=hist(DS(length(Zpred_sens(:))+1:end),B);

% Draw the graph
figure
h1=bar(B,Np./sum(Np),'hist');
hold on;
h2=bar(B,Nn./sum(Nn),'hist');
hold off;
set(gca,'FontSize',14);
set(h1,'FaceAlpha',0.5,'FaceColor','r');
set(h2,'FaceAlpha',0.5,'FaceColor','b');
xlim([-1.05,+1.05]);
xlabel('normalized discriminative score');
ylabel('Relative frequency');
legend('Dep','Cont');
set(gca,'Position',[0.115,0.1,0.850,0.8350]);
grid on;

%% plot subjectwise distribution
%   %%
%   
%   p_sensz = Zpred(Ytest==+1);
%   p_specz = Zpred(Ytest==-1);
%   
%   DS=[p_sensz(:);p_specz(:)];
%   MaxAbsDS=max(abs(DS));
%       
%   Nshuffle = size(data,1);
%   
%   N1 = sum(Ytest==-1)./Nshuffle;
%   N2 = sum(Ytest==+1)./Nshuffle;
%   
%   
%       p_specz = reshape(p_specz/MaxAbsDS,N1,Nshuffle);
%       p_sensz = reshape(p_sensz/MaxAbsDS,N2,Nshuffle);
%       
%      % DS=DS/MaxAbsDS;
%     %  B=-1.05:0.1:+1.05;
%  
%        figure
%         % probability for Control
%         boxplot(p_specz')
% %        plot(p_specz,'xk','linewidth',1.2)
%         ylabel('predicted probability')
%         xlabel('Control subjects')
%         set(gca,'xtick',1:N1)
%         %set(gca,'xticklabel',subjects(1:N1))
%        % xticklabel_rotate([],45,subjects(1:N1));
%        hold on
%        plot([0 N1+1],[0 0],'k','linewidth',1.5)
%         ylim([-1.05 1.05])
%         xlim([0 N1+1])
%         grid
%                 
%         set(gcf,'position',[ 518         766        1033         331], 'paperpositionmode','auto')
%         fname=sprintf('figures/%s_%s_PzN',DatasetName,method);
% 
%         print('-dpng',fname)
%         close
%         
%        figure
%         % probability for Control
%         boxplot(p_sensz')
% %        plot(p_sensz,'xk','linewidth',1.2)
%         ylabel('predicted probability')
%         xlabel('MDD subjects')
%         set(gca,'xtick',1:N2)
%         %set(gca,'xticklabel',subjects(1:N1))
%        % xticklabel_rotate([],45,subjects(1:N1));
%        hold on
%        plot([0 N2+1],[0 0],'k','linewidth',1.5)
%         ylim([-1.05 1.05])
%         xlim([0 N2+1])
%         grid
%                 
%         set(gcf,'position',[ 518         766        1033         331], 'paperpositionmode','auto')
%         fname=sprintf('figures/%s_%s_PzD',DatasetName,method);
% 
% %        print('-dpng',fname)
% %        close





