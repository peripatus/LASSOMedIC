

 %%
 
 if  ~isfield(LL,'fOpt') 
    p_specz = log(1./LL.p_spec-1);
    p_sensz = log(1./LL.p_sens-1);
else
    fOpt = LL.fOpt;
    % probability for Control
    p_specz = log(1./LL.p_spec(:,fOpt)-1);
    p_sensz = log(1./LL.p_sens(:,fOpt)-1);
 end
 
 
 DS=[-p_sensz(:);-p_specz(:)];
 DSmax = abs(DS);
    DSmax(isinf(DSmax))= 0;
      DSmax(isnan(DSmax))= 0;
 MaxAbsDS=max(DSmax);
      
      
      p_specz = -p_specz/MaxAbsDS;
      p_sensz = -p_sensz/MaxAbsDS;
 
      N1 = size(p_specz,2);
 N2 = size(p_sensz,2);
 
 
 %%     
%  if exist('subjects','var')
%     subjects = subjects;
% 
%     subjects = strrep(subjects,'Dep','');
%     subjects = strrep(subjects,'Cont','');
%  else
%      subjects = num2cell(1:length(p_specz));
%  end
%  
    figure
    % probability for Control
    subplot(2,1,1)
    boxplot(p_specz);
    ylabel('normalized odds ratio','fontweight','demi')
    xlabel('Control subjects','fontweight','demi')
    set(gca,'xtick',1:length(p_specz),'xticklabel',subjects(1:N1));
   xticklabel_rotate([],90,subjects(1:N1));
    hold on
    plot([0 N1+1],[0 0],'k','linewidth',1.5);
    ylim([-1.05 1.05])
    xlim([0 N1+1])
   
    grid
 %   set(gcf,'position',[ 518 766 1033 331], 'paperpositionmode','auto')
        
    %%
    %% probability for Target Group
    subplot(2,1,2)
    boxplot(p_sensz);
    ylabel('normalized odds ratio','fontweight','demi')
    xlabel('Target subjects','fontweight','demi')
    set(gca,'xtick',1:length(p_sensz),'xticklabel',subjects(N1+1:end));

       xticklabel_rotate([],90,subjects(N1+1:end));
       hold on
       plot([0 N2+1],[0 0],'k','linewidth',1.5);
        ylim([-1.05 1.05])
        xlim([0 N2+1])
        grid
                
        set(gcf,'position',[ 518         766        1033         600], 'paperpositionmode','auto');
  