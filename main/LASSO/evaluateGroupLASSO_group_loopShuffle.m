

function evaluateGroupLASSO_group_loopShuffle(dpath,data,opts)

    Nshuffle = opts.Nshuffle;
    Ncross = opts.Ncross;
    label = opts.label;

    subject_ext1 = 'C'; % Control
    subject_ext2 = 'T'; % Target

    if isfield(opts,'filt1')
        subject_ext1 = filt1;    
    elseif isfield(opts,'filt2')
        subject_ext2 = filt2;       
    end

%%
subjects(label==1) = num2cell(1:sum(label==1));
subjects(label~=1) = num2cell(1:sum(label~=1));

subjects(label~=1) = strcat(subject_ext1,cellfun(@num2str,subjects(label~=1),'uniformoutput',false));
subjects(label==1) = strcat(subject_ext2,cellfun(@num2str,subjects(label==1),'uniformoutput',false));

%%

thresh = 0;%.001; % weight threshold of weight maps
freqthresh = opts.freq; % threshold for feature selection frequency (affects display only)
    
load([dpath,data],'label','BAlabelvol','features','BAnom', 'template')

w_template = load_nii(template);
features = logical(features);

% if opts.brainarea ==1
[vol3Dsort,sortInd] = sort(BAlabelvol(features));
f = find(features); clear features
f = f(sortInd);
    
    
f1 = find(label==0);
f2 = find(label==1);
N1 = length(f1);
N2 = length(f2);

    w = [];
    c =[];

    
    for shufflei = 1:Nshuffle
    shufflei
        % >>>>>>> evaluate outer loop >>>>>>>>>>>>>>>>>
        load(['results/matdata/groupLoop/',data,'/',data,'_shuff',num2str(shufflei)])
        %% PERFORMANCE  
        lambda(shufflei,:) = LL.lambda(LL.lambdaOpt);
      %   lambdaOpt(shufflei,:) = LL.lambdaOpt;
        acc(shufflei) = LL.acc;
        sens(shufflei) = LL.sens; % should be similar to performance at optimal lambda
        spec(shufflei) = LL.spec;
        Fscore(shufflei) = LL.Fscore;
        p_spec(shufflei,:) = LL.p_spec;
        p_sens(shufflei,:) = LL.p_sens;
        % ML(shufflei)= mean(log([1-LL.p_spec(:);LL.p_sens(:)]));
         
        % w(:,shufflei) = LL.beta(:,round(mean(fOpt(shufflei,:))));
       
        w = [w,LL.beta];
        c = [c,LL.c];
        
      % whos w
        mNw(shufflei) = mean(sum(LL.beta~=0,2));
        sNw(shufflei) = std(sum(LL.beta~=0,2));
   
    end
 %   lambdaOpt
    %%
%     figure
%     imagesc(lambdaOpt)
%     title(data)
%     colorbar
%     continue
    %%
    
    wnon0 = sum(sum(w~=0,2)>0);
   % log10(mean(mean ))
    %%
    freq = sum(w~=0,2)./(Nshuffle*Ncross)*100;
%   sum(freq>=90)/wnon0
%   sum(freq>80)
%   continue
    %%
    
    figure
    [nn,xtick] = hist(freq',10:10:100);
    bar(xtick,nn./wnon0.*100)
    %     [nn,xtick] = hist(freq',0:10:100);
    %     bar(xtick(6:end),nn(6:end)./wnon0.*100)
    grid
       xlabel('% of all crossvalidate models in which the feature was selected')
    ylabel('% of all voxels non-zero in at least one crossvalidated model')
  
    print(gcf,'-dpng',['results/png/groupLoop/',data,'/',data,'_weightDist_N',num2str(Nshuffle)])
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
    print(gcf,'-dpng',['results/png/groupLoop/',data,'/',data,'_lambda1All'])
    
 
%     %%
% % %%
    
     mw = mean(w,2);
     sw = std(w,0,2);
     opts = LL.opts;
     clear LL
     
      LL.mw = mw;
      LL.mc = mean(c);
      LL.opts = opts;
       LL.freq = freq;
       LL.acc = acc;
       LL.macc = mean(acc);
       LL.sacc = std(acc); 
       
      LL.lambda = lambda;
      LL.mlambda = mean(log10(lambda),2);
      LL.slambda = std(log10(lambda),0,2);
       
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
     
%       LL.ML = ML;

       LL.p = mean([1-p_spec,p_sens],2);
       LL.mp = mean(mean([1-p_spec,p_sens],2));
       LL.sp = std(mean([1-p_spec,p_sens],2));
      % LL.max = max(max([1-p_spec,p_sens]));
       LL.min = min(min([1-p_spec,p_sens]));
       
       
       LL.mplog = mean(mean(log([1-p_spec,p_sens]),2));
       LL.splog = std(mean(log([1-p_spec,p_sens]),2));
      
      
      %%
      save(['results/matdata/groupLoop/',data,'/',data,'_shuffleN',num2str(Nshuffle)],'LL')
      clear p*
      
      % performance
      
    plotPdistz(LL);
    print(gcf,'-dpng',['results/png/groupLoop/',data,'/',data,'_shuff',num2str(Nshuffle)])
   
    plotSubjectsPz
    print(gcf,'-dpng',['results/png/groupLoop/',data,'/',data,'_shuff',num2str(Nshuffle),'_subjectPz'])
 
    %%
    
    
      figure
       mybarweb([ LL.msens; LL.mspec; LL.mFscore; LL.mp],[ LL.ssens; LL.sspec; LL.sFscore; LL.sp]);
      legend('sens','spec','Fscore','L','location','northwest');
      grid
      title(data)
      ylim([0 1])
       print(gcf,'-dpng',['results/png/groupLoop/',data,'_shuff',num2str(Nshuffle)])
        
     %%%%%%% weights
     
     w_img = zeros(size(BAlabelvol));% w_template.img));
     w_imgB = w_img;
    
     select1 = sum(w~=0,2)./(Ncross*Nshuffle).*100; % number of times each voxel is selected
     LL.wAll=sum(select1==100);
  
     
     mselect2 = sum(w~=0,1); % number of remaining voxels for each model
     LL.ms2 = mean(mselect2);
     LL.ss2 = std(mselect2);
     
     w_img(f) = select1; % number of times each voxel is selected
     w_imgB(f) = mw;         %mean weight
      
     % weight stat
     LL.wunion = length(find(mw));

    
       %% save weight maps
       if ~exist(['results/weights/groupLoop/',data],'dir')
           mkdir(['results/weights/groupLoop/',data])
       end
       
       %% selection frequency image
       w_template.img = volResize(w_img,size(w_template.img));
       img_name =  ['results/weights/groupLoop/',data,'/',data,'_SelectionFrequency_Nshuffle',num2str(Nshuffle),'.nii']; % name of resulting weight image
       w_template.fileprefix = img_name;    
       save_nii(w_template,img_name);
         
       %%%%%%%%%%%%%%%%%%%%% 
       %% mean weights pos  
       %%%%%%%%%%%%%%%%%%%%
        w_imgB(f) = mw;
        w_imgBp = w_imgB;
        w_imgBp(w_imgB<thresh)=0;

        w_template.img = volResize(w_imgBp,size(w_template.img));
        img_name =  ['results/weights/groupLoop/',data,'/',data,'_weightsPos_Nshuffle',num2str(Nshuffle),'.nii']; % name of resulting weight image
        w_template.fileprefix = img_name;    
        save_nii(w_template,img_name);


        % mean pos weights selected more than 75% of the time
        w_imgBp(w_img<freqthresh)=0;
        w_template.img = volResize(w_imgBp,size(w_template.img));
        img_name =  ['results/weights/groupLoop/',data,'/',data,'_weightsPos_selectionFreqBiggerThan',num2str(freqthresh),'_Nshuffle',num2str(Nshuffle),'.nii']; % name of resulting weight image
        w_template.fileprefix = img_name;    
        save_nii(w_template,img_name);
        clear w_imgBp
         
        %%%%%%%%%%%%%%%%%%%%%
        %% mean weights neg  
        %%%%%%%%%%%%%%%%%%%%%
         w_imgBn = w_imgB;
         w_imgBn(w_imgB>-thresh)=0;
         w_imgBn(w_img<freqthresh)=0;
       
         w_template.img = volResize(w_imgBn,size(w_template.img));
         img_name =  ['results/weights/groupLoop/',data,'/',data,'_weightsNeg_Nshuffle',num2str(Nshuffle),'.nii'];      
         w_template.fileprefix = img_name;    
         save_nii(w_template,img_name);
             
         % mean neg weights selected more than % of the time
         w_imgBn(w_img<freqthresh)=0;
         w_template.img = volResize(w_imgBn,size(w_template.img));
         img_name =  ['results/weights/groupLoop/',data,'/',data,'_weightsNeg_selectionFreqBiggerThan',num2str(freqthresh),'_Nshuffle',num2str(Nshuffle),'.nii']; % name of resulting weight image
         w_template.fileprefix = img_name;    
         save_nii(w_template,img_name);
    
         
         
        %% BRAIN area stats
         if ~exist(['results/performance/groupLoop/',data],'dir')
           mkdir(['results/performance/groupLoop/',data])
       end
        
        ff = find(w_imgB); 
       
        [~, BA,stat] = getBrainAreas(BAnom, BAlabelvol,1:length(BAlabelvol(:)),ff);
  
          ffthresh = find(w_imgB~=0 & (w_img>=freqthresh)==1);
        [~, BAthresh,~] = getBrainAreas(BAnom, BAlabelvol,1:length(BAlabelvol(:)),ffthresh);

        ffthreshp = find(w_imgB>0 & (w_img>=freqthresh)==1);
        [~, BAthreshp,~] = getBrainAreas(BAnom, BAlabelvol,1:length(BAlabelvol(:)),ffthreshp);
        
        ffthreshn = find(w_imgB<0 & (w_img>=freqthresh)==1);
        [~, BAthreshn,~] = getBrainAreas(BAnom, BAlabelvol,1:length(BAlabelvol(:)),ffthreshn);
        
        if ~exist(['results/performance/groupLoop/',data],'dir')
            mkdir(['results/performance/groupLoop/',data])
        end
         
        % write to textfile
        resultfile = ['results/performance/groupLoop/',data,'/',data,'_performance_Nshuffle',num2str(Nshuffle),'.txt'];
      
        fid = fopen(resultfile,'w');
        
           
        fprintf(fid,'%30s \t %6.4f %3s %6.4f \n','Sensitivity',LL.msens,'+/-',LL.ssens); 
        fprintf(fid,'%30s \t %6.4f %3s %6.4f \n','Specificity',LL.mspec,'+/-',LL.sspec);
        fprintf(fid,'%30s \t %6.4f %3s %6.4f \n','Fscore', LL.mFscore,'+/-',LL.sFscore);
        fprintf(fid,'%30s \t %6.4f %3s %6.4f \n','Accuracy', LL.macc,'+/-',LL.sacc);
        fprintf(fid,'%30s \t %6.4f %3s %6.4f \n','Likelihood', LL.mp,'+/-',LL.sp);
        fprintf(fid,'%30s \t %6.4f %3s %6.4f %3s %6.4f \n\n','#features', LL.ms2,'+/-',LL.ss2,' out of', length(ff));

       
        fprintf(fid,'%30s \t %s \t %s \t %s \t %s  \t %s  \t %s \t %s  \t %s \n','BrainArea','Selection Freq','#Voxels','%of area','%pos voxels','mean pos', 'std','mean neg','std');
        
        
      for gi = 1:length(BA.BA)
        %    fprintf(fid,'%30s \t ', BA.BA{gi});
            Nwp(gi) = sum(w_imgB(BA.ind{gi})>0);
            ppp = find(w_imgB(BA.ind{gi})>0);
            wpBm(gi) = mean(w_imgB(BA.ind{gi}(ppp)));
            wpBs(gi) = std(w_imgB(BA.ind{gi}(ppp)));
            
            Nwn(gi) = sum(w_imgB(BA.ind{gi})<0);
            nnn = find(w_imgB(BA.ind{gi})<0);
            wnBm(gi) = mean(w_imgB(BA.ind{gi}(nnn)));
            wnBs(gi) = std(w_imgB(BA.ind{gi}(nnn)));
            
           % freq(gi) = max(w_img(BA.ind{gi}));
            freqp(gi) = mean(max(w_img(BA.ind{gi}(ppp)))); % mean in order to prevent error due to empty matrix!!!!
            freqn(gi) = mean(max(w_img(BA.ind{gi}(nnn))));
            
       %     fprintf(fid,' %6.2f \t %4i\t %6.2f \t %7.2f\t %8.2e\t %8.2e\t %8.2e\t %8.2e \n', freq(gi), BA.Vselected(gi),(BA.Vselected(gi)/BA.Vall(gi))*100,Nwp(gi)/BA.Vselected(gi)*100, wpBm(gi),wpBs(gi),wnBm(gi),wnBs(gi));
        end
        
        
         [~,indp]= sort(wpBm,'descend');
        
        
       % print
         fprintf(fid,'%30s \n', 'positive weights');
        for ti = 1:length(BA.BA)
            gi = indp(ti);
            if freqp(gi)> freqthresh
                fprintf(fid,'%30s \t ', BA.BA{gi});
                fprintf(fid,' %6.2f \t %4i\t %6.2f \t %7.2f\t %8.2e\t %8.2e\t %8.2e\t %8.2e \n', freqp(gi), BA.Vselected(gi),(BA.Vselected(gi)/BA.Vall(gi))*100,Nwp(gi)/BA.Vselected(gi)*100, wpBm(gi),wpBs(gi),wnBm(gi),wnBs(gi));
            end
        end
        
        
        % sort neg
        [~,indn]= sort(wnBm,'ascend');
        
        
        %print
          fprintf(fid,'\n%30s \n', 'negative weights');
        for ti = 1:length(BA.BA)
              gi = indn(ti);
                if freqn(gi)> freqthresh
              fprintf(fid,'%30s \t ', BA.BA{gi});
            fprintf(fid,' %6.2f \t %4i\t %6.2f \t %7.2f\t %8.2e\t %8.2e\t %8.2e\t %8.2e \n', freqn(gi), BA.Vselected(gi),(BA.Vselected(gi)/BA.Vall(gi))*100,Nwp(gi)/BA.Vselected(gi)*100, wpBm(gi),wpBs(gi),wnBm(gi),wnBs(gi));
        
                end
        end
          fclose('all');        
        type(resultfile)
        
        save(['results/performance/groupLoop/',data,'/',data,'_performance_Nshuffle',num2str(Nshuffle),],'BA*','stat','LL','wpBm','wnBm','wpBs','wnBs','Nwp','Nwn','freq*','w_img','ind*')

      
        
      %  close all
       %% 
       clearvars -execpt Ncontrast contrast ci Nshuffle Ncross thresh freqthresh cflag
    
end
