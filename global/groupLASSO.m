function LL = groupLASSO(mvalues,label,opts);

    if isfield(opts,'Ncross')
        Ncross = opts.Ncross;
    else
        Ncross = 10;
    end

    %if isfield(opts,'Nshuffle')
        Nshuffle = opts.Nshuffle;
    %else
    %    Nshuffle = 1;
    %end


lambda = opts.lambda;
Nlambda = length(lambda);

N1 = sum(label==-1);
N2 = sum(label==1);

% number subjects according to Ncross
subN1 = rem(1:N1,Ncross)+1;
subN2 = rem(1:N2,Ncross)+1;

rng(Nshuffle)
subN1 = subN1(randperm(N1));
rng(Nshuffle)
subN2 = subN2(randperm(N2));
 
z2 = cell(Ncross,Nlambda);
pp2 = z2;

labelg = label;

%% groupLASSO 
if isfield(opts,'normalize')
    nflag = opts.normalize;
else
    nflag = 1;
end


  binary = [];
    for fbi = 1:size(mvalues,2)
        if (sum(abs(unique(mvalues(:,fbi)))) == 2) || (sum(abs(unique(mvalues(:,fbi)))) == 1)
            binary = [binary,fbi];
        end
    end
   
%betaAll = zeros(Ncross,size(mvalues,2),Nlambda);
NbetaAll = zeros(Ncross,size(mvalues,2),Nlambda);

%parfor crossi = 1:Ncross
parfor crossi = 1:Ncross

    
 %   display(['CV ',num2str(crossi)])
    [trainIdx, testIdx{crossi}] = getCVidx(subN1,subN2,crossi);
    
    mvalues2 = mvalues(trainIdx,:);
    
 
    % train
    if nflag==1
        [mtrain,scale,base] = normalize0class(mvalues2,labelg(trainIdx));
        % keep binary data binary
       mtrain(:,binary) = mvalues2(:,binary);
       scale(binary) = 1;
       base(binary) = 0;
    else
        mtrain = mvalues2;
        scale = ones(1,size(mvalues2,2));
        base = zeros(1,size(mvalues2,2));
    end
    [w,c]= pathSolutionLogistic(mtrain,labelg(trainIdx), lambda,opts); 
  %   size(w)
    
  %  betaAll(crossi,:,:) = w;
  
    NbetaAll(crossi,:,:) = (w~=0);
  
     
    % test
    mtest = (mvalues(testIdx{crossi},:) - repmat(base,[length(testIdx{crossi}),1]))./repmat(scale, [length(testIdx{crossi}),1]);
    for kk=1:length(lambda)
        ww = w(:,kk);
        z2{crossi}(:,kk)= mtest*ww(:)+c(kk);
        pp2{crossi}(:,kk) = 1./(1+exp(-z2{crossi}(:,kk)));
    end
end

 %% reorder
         for crossi = 1:Ncross
            LL.z(testIdx{crossi},:) = z2{crossi};
            LL.pp(testIdx{crossi},:) = pp2{crossi};
         end
%% evaluate performance
%LL.z = z2; clear z2
p_spec2 =LL.pp(labelg==-1,:);
p_sens2 =LL.pp(labelg==1,:); clear pp2
             
FP = sum(p_spec2>0.5);
TP = sum(p_sens2>0.5);

TN = sum(p_spec2<0.5);
FN = sum(p_sens2<0.5);
%         
 LL.lambda = lambda;
% 
LL.p_spec = p_spec2;
 LL.p_sens = p_sens2;
 
 LL.spec = mean(p_spec2<0.5,1);
 LL.sens = mean(p_sens2>0.5,1);
 LL.acc = (TP+TN)./(length(label));
 
 prec = TP./(TP+FP);  %
 recall = TP./(TP+FN); % = spec
             
 LL.Fscore = 2.*recall.*prec./(recall+prec);  
LL.fOpt = getfOpt(LL.p_spec,LL.p_sens);
%whos betaAll
%LL
%LL.betaAll = squeeze(betaAll(:,:,LL.fOpt));
LL.NbetaAll = squeeze(mean(sum(NbetaAll,2),1));

% LL.opts=opts;


%plotLASSOresults
%plotPdistz;
 
% retrain with optimal lambda
  if nflag==1
     [mtmp, LL.scale, LL.base] = normalize0class(mvalues,label);
     mtmp(:,binary) = mvalues(:,binary);
     mvalues = mtmp; clear mtmp
     LL.scale(binary) = 1;
     LL.base(binary) = 0;
  else
     LL.scale = ones(1,size(mvalues,2));
     LL.base = zeros(1,size(mvalues,2));
  end

  
[LL.beta, LL.c] = pathSolutionLogistic(mvalues,label, lambda(LL.fOpt),opts);clear mtrain
%[LL.beta, LL.c] = pathSolutionLogistic(mvalues,label, lambda,opts);clear mtrain

