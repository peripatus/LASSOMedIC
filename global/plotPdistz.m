

function plotPdistz(LL)

if  ~isfield(LL,'fOpt') 
    LL.p_specz = -log(1./LL.p_spec-1);
    LL.p_sensz = -log(1./LL.p_sens-1);
else
    fOpt = LL.fOpt;
    % probability for Control
    LL.p_specz = -log(1./LL.p_spec(:,fOpt)-1);
    LL.p_sensz = -log(1./LL.p_sens(:,fOpt)-1);
end

      figure
      DS=[LL.p_sensz(:);LL.p_specz(:)];
%      DS=[-p_sensz(:);-p_specz(:)];

      DSmax = abs(DS);
      DSmax(isinf(DSmax))= 0;
      DSmax(isnan(DSmax))= 0;
      
      MaxAbsDS=max(DSmax);
      DS(isinf(DS(:)))=sign(DS(isinf(DS(:))));
      DS=DS/MaxAbsDS;
      B=-1.05:0.05:+1.05;

      B1=-1.04:0.05:+1.06;
      
      B2=-1.06:0.05:+1.05;
      
      [Np,~]=hist(DS(1:length(LL.p_sensz(:))),B);
      [Nn,~]=hist(DS(length(LL.p_sensz(:))+1:end),B);
      

%% Draw the graph
clf;
hold off;
%h1=bar(B,Np./sum(Np),'hddist');
h1=bar(B1,Np./sum(Np)*100,0.35,'hist');
set(h1,'FaceAlpha',0.5,'FaceColor','r');
hold on;

h2=bar(B2,Nn./sum(Nn)*100,0.35,'hist');
hold off;
set(gca,'FontSize',14);
set(h2,'FaceAlpha',0.5,'FaceColor','b');
xlim([-1.05,1.05]);
%ylim([0 0.3])
xlabel('normalized weighted sum');
ylabel('Subjects (%)');

%% if 
%% legend(subject_ext1,subject_ext2)
legend('Target','Control');
title('gLASSO','FontSize',14);
set(gca,'Position',[0.115,0.1,0.850,0.8350]);
grid


%min(DS(1:length(LL.p_sensz(:))))
%max(DS(length(LL.p_sensz(:))+1:end))
