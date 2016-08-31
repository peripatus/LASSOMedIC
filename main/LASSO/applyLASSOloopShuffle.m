
function applyLASSOloopShuffle(dpath,data,opts)

if isfield(opts,'q') 
    if opts.q==2
        ext = 'groupLoop';
    elseif opts.q==1
         ext = 'L1L1Loop';
    end
else
    ext = 'groupLoop';
end

  data = strrep(data,'.mat','');
    load(fullfile(dpath,data),'mvalues')    

      if sum(isnan(mvalues(:))) >0
          display(['isnan values found'])
          display(['skipping'])
        return
      end
    if ~isempty(opts.sortInd)
        mvalues = mvalues(:,opts.sortInd); 
    end

    Nshuffle = opts.Nshuffle;
    Ncross = opts.Ncross;

    label = opts.label;
     
        f1 = find(label==0);
        f2 = find(label==1);
        N1 = length(f1);
        N2 = length(f2);

         %% groupLASSO
         labelg = double(label(:));
         labelg(f1)=-1;
         labelg(f2)= 1; clear label
   
        for shufflei = 1:Nshuffle
        
            % number subjects according to Ncross
            subN1 = rem(1:N1,Ncross)+1;
            subN2 = rem(1:N2,Ncross)+1;
         
            rng(shufflei)
            subN1 = subN1(randperm(N1));
            rng(shufflei)
            subN2 = subN2(randperm(N2));

            for crossi = 1:Ncross
              %  crossi
              display(['shuffle ',num2str(shufflei),' cross ',num2str(crossi)])
                [trainIdx, testIdx{crossi}] = getCVidx(subN1,subN2,crossi);
             
                %% inner CV
                mvalues2= mvalues(trainIdx,:);
                labelg2 = labelg(trainIdx);
           
                
                LL = groupLASSO(mvalues2,labelg2,opts);
%                 figure
%                 imagesc(mvalues2)
%                 pause
                
                %%   plot performance
                if opts.plotFlag == 1
                    if ~exist(['results/png/',ext,'/',data],'dir')
                        mkdir(['results/png/',ext,'/',data])
                    end
                    if shufflei < 3 && crossi ==1
                         %   performance and weights
                        plotLASSOresults(LL)
                        print(gcf,'-dpng',['results/png/',ext,'/',data,'/',data,'_cross_',num2str(crossi),'_shuff',num2str(shufflei),'acc']) 
                        %     distribution
                        plotPdistz(LL);
                        title([data,' LASSO cross',num2str(crossi)])
                        print(gcf,'-dpng',['results/png/',ext,'/',data,'/',data,'_cross_',num2str(crossi),'_shuff',num2str(shufflei),'dist']) 
                    end
                end
             
                %% outer CV with optimal lambda
                mtest = (mvalues(testIdx{crossi},:) - repmat(LL.base,[length(testIdx{crossi}),1]))./repmat(LL.scale, [length(testIdx{crossi}),1]) ; 
                tmp = mtest*LL.beta+LL.c;
                
               %% LL.beta
                % LL.c
                
                lambdaOpt(crossi) = LL.fOpt;
                z{crossi}=tmp;
            
                pp{crossi} = 1./(1+exp(-tmp));
            
                beta(:,crossi) = LL.beta;
                c(crossi) = LL.c;            
            end
         
         clear LL
         
         %% reorder
         for crossi = 1:Ncross
            LL.z(testIdx{crossi}) = z{crossi};
            LL.pp(testIdx{crossi}) = pp{crossi};
         end
         clear z pp
          
         LL.beta = beta;

         LL.c = c;
         LL.lambda = opts.lambda;
         LL.lambdaOpt = lambdaOpt;
        
         LL.p_spec = LL.pp(labelg==-1);
         LL.p_sens = LL.pp(labelg==1); clear pp
         
         FP = sum(LL.p_spec>0.5);
         TP = sum(LL.p_sens>0.5);
         
         TN = sum(LL.p_spec<0.5);
         FN = sum(LL.p_sens<0.5);
         
         LL.spec = mean(LL.p_spec<0.5);
         LL.sens = mean(LL.p_sens>0.5);
         LL.acc = (TP+TN)./(N1+N2);
         LL.prec = TP./(TP+FP);  %
         LL.recall = TP./(TP+FN); % = spec
         LL.Fscore = 2.*LL.recall.*LL.prec./(LL.recall+LL.prec);  
    
         LL.opts=opts;
         
        
         if ~exist(['results/matdata/',ext,'/',data],'dir')
             mkdir(['results/matdata/',ext,'/',data])
         end
       
         save(['results/matdata/',ext,'/',data,'/',data,'_shuff',num2str(shufflei)],'LL')
         clear LL min* max* beta c
        %close all
     end      



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% delete parallel pool
%poolobj = gcp('nocreate');
%delete(poolobj)
         