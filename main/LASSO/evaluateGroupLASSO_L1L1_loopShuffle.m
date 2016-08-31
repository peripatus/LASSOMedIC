

function evaluateGroupLASSO_L1L1_loopShuffle(dpath,data,opts)

Nshuffle = opts.Nshuffle;
Ncross = opts.Ncross;
label = opts.label;
thresh = 0;%.001; % weight threshold of weight maps
freqthresh = 75; % threshold for feature selection frequency (affects display only)
    

load(fullfile(dpath,data),'label','BAlabelvol','features','BAnom','filt0','filt1')

subject_ext0 = {filt0};    
subject_ext1 = {filt1};    

%%
subjects(label==1) = num2cell(1:sum(label==1));
subjects(label~=1) = num2cell(1:sum(label~=1));

subjects(label~=1) = strcat(subject_ext0,cellfun(@num2str,subjects(label~=1),'uniformoutput',false));
subjects(label==1) = strcat(subject_ext1,cellfun(@num2str,subjects(label==1),'uniformoutput',false));

%%


        
   
    f = find(features);
    if ~exist('marker','var')
        marker = {BAnom.Nom_L};
    end
    
    
    f1 = find(label==0);
    f2 = find(label==1);
    N1 = length(f1);
    N2 = length(f2);

    w = [];
            
    for shufflei = 1:Nshuffle
        shufflei
        load(['results/matdata/L1L1Loop/',data,'/',data,'_shuff',num2str(shufflei)])
  
        %% PERFORMANCE
        lambda(shufflei,:) = LL.lambda(LL.lambdaOpt);
        acc(shufflei) = (sum(LL.p_spec<0.5)+sum(LL.p_sens>0.5))./(N1+N2);
        sens(shufflei) = LL.sens; % should be similar to performance at optimal lambda
        spec(shufflei) = LL.spec;
        Fscore(shufflei) = LL.Fscore;
        p_spec(shufflei,:) = LL.p_spec;
        p_sens(shufflei,:) = LL.p_sens;
     
    %  ML(shufflei)= mean(log([1-LL.p_spec,LL.p_sens]));
        w = [w,LL.beta];
    end
   % whos w

    lambdaAll = LL.lambda;
    wnon0 = sum(sum(w~=0,2)>0);
    

    %%%%
    freq = sum(w~=0,2)./(Nshuffle*Ncross)*100;
   % sum(freq>80)
    

    figure
    [nn,xtick] = hist(freq',0:10:100);
    bar(xtick(6:end),nn(6:end)./wnon0.*100);
    xlabel('% of all crossvalidate models in which the feature was selected')
    ylabel('% of all voxels non-zero in at least one crossvalidated model')
    grid
    set(gca,'fontsize', 12)
    print(gcf,'-dpng',['results/png/L1L1Loop/',data,'/',data,'_weightDist'])
    %%
      
    
   % mean(mean(log10(lambda),2));
   % std(mean(log10(lambda),2))
    %%
    
    int = linspace(min(log10(lambda(:)))-0.05,max(log10(lambda(:)))+0.05,length(lambda(:)));
    figure
    n = hist(log10(lambda(:)),int ,10);
    bar(int,n./10);
    
    grid
    xlabel('log(\lambda_{Sopt})','fontsize',14,'fontweight','bold')
    ylabel('frequency (%)','fontsize',14,'fontweight','bold')
  % xlim([-2.2 -0.4])
     ylim([0 50])
    set(gca,'fontsize',12,'fontweight','bold')
    print(gcf,'-dpng',['results/png/L1L1Loop/',data,'/',data,'_lambda1All'])

    
  %  continue
    
    %%
   % return
    
      opts = LL.opts;
     mw = mean(w,2);
     sw = std(w,0,2);
    
     clear LL
    
     LL.opts = opts;
     LL.freq = freq;
        LL.acc = acc;
       LL.macc = mean(acc);
       LL.sacc = std(acc); 
       
       LL.lambda = lambda;
%       LL.slambda = std(mean(log10(lambda),2));
       
       LL.sens = sens;
      LL.msens = mean(sens);
       LL.ssens = std(sens);
      
       LL.p_spec=p_spec;
       LL.p_sens = p_sens;
       
       LL.spec = spec;
       LL.mspec = mean(spec);
       LL.sspec = std(spec);
      
       LL.Fscore = Fscore;
       LL.mFscore= mean(Fscore);
       LL.sFscore=std(Fscore);
     
       LL.mp = mean(mean([1-p_spec,p_sens],2));
       LL.sp = std(mean([1-p_spec,p_sens],2));
      % LL.max = max(max([1-p_spec,p_sens]));
       LL.min = min(min([1-p_spec,p_sens]));
       
%       LL.ML = ML;
       LL.p = mean([1-p_spec,p_sens],2);
       LL.mplog = mean(mean(log([1-p_spec,p_sens]),2));
       LL.splog = std(mean(log([1-p_spec,p_sens]),2));
      
      
      %%
    
      
      %%
      plotPdistz(LL);
    print(gcf,'-dpng',['results/png/L1L1Loop/',data,'/',data,'_shuff'])
 %   close all
    
    
%     sc = getMarkerAll(subjects,{'MRImageacquisition'});
%    sc =sc.MRImageacquisition(:,1);
    
     plotSubjectsPz;
 %   plot(sc(label==0)-2,'og','markersize',6)
      print(gcf,'-dpng',['results/png/L1L1Loop/',data,'/',data,'_shuff_subjectPz'])

    
    %%
    figure
    mybarweb([ LL.msens; LL.mspec; LL.mFscore; LL.mp],[ LL.ssens; LL.sspec; LL.sFscore; LL.sp]);
    legend('sens','spec','Fscore','L','location','northwest')
    grid 	      
	print(gcf,'-dpng',['results/png/L1L1Loop/',data,'/',data,'_shuffN',num2str(Nshuffle)])
      
       
    %%   
    select1 = sum(w~=0,2)./(Ncross*Nshuffle).*100; % number of times each feature is selected
      LL.wAll= sum(mw~=0);

     mselect2 = sum(w~=0,1); % number of remaining features for each model
     LL.ms2 = full(mean(mselect2));
     LL.ss2 = full(std(mselect2));
     LL.wunion = length(find(mw));
     
     
     % write to textfile
     if ~exist(['results/performance/L1L1Loop/',data],'dir')
        mkdir(['results/performance/L1L1Loop/',data])
     end
     resultfile = ['results/performance/L1L1Loop/',data,'/',data,'_BAstat',num2str(Nshuffle),'.txt'];
      fid = fopen(resultfile,'w');
           
        fprintf(fid,'%30s \t %6.4f %3s %6.4f \n','sens',LL.msens,'+/-',LL.ssens); 
        fprintf(fid,'%30s \t %6.4f %3s %6.4f \n','spec',LL.mspec,'+/-',LL.sspec);
                fprintf(fid,'%30s \t %6.4f %3s %6.4f \n','Acc', LL.macc,'+/-',LL.sacc);

        fprintf(fid,'%30s \t %6.4f %3s %6.4f \n','Fscore', LL.mFscore,'+/-',LL.sFscore);
        fprintf(fid,'%30s \t %6.4f %3s %6.4f \n','L', LL.mp,'+/-',LL.sp);
        fprintf(fid,'%30s \t %6.4f %3s %6.4f %3s %6.4\n\n','#areas', LL.ms2,'+/-',LL.ss2,' out of',length(wm));

        
  %   if strfind(data,'BA')
         
        [mwsort, idx] =sort(mw);
         
        fprintf(fid,'%30s \t %s \t %s \t %s \n','BrainArea','freqMax','mean', 'std');
        
        for gi = 1:length(mw)
            if mwsort(gi)~=0
                if select1(idx(gi))>=freqthresh
               if length(BAnom)==1
                    fprintf(fid,'%30s \t ',BAnom.Nom_L{(f(idx(gi)))});
                else
                    fprintf(fid,'%30s \t ', BAnom(f(idx(gi))).Nom_L);
               end
                    fprintf(fid,' %6.2f \t %4i\t %6.2f \n', select1(idx(gi)), mwsort(gi), sw(idx(gi)));  
                end
            end
        end
        
        
        save(['results/performance/L1L1Loop/',data,'/',data,'performance_Nshuffle',num2str(Nshuffle)],'LL','mw','sw')

        
          fclose('all');        
        type(resultfile)

        %%
       
        clearvars -EXCEPT Ndata data ci thresh Nshuffle Ncross freqthresh ext

end
