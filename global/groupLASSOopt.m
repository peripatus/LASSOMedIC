function LL = groupLASSOopt(mvalues,label,opts);

Ncross = 10;
lambda = opts.lambda;
%Nlambda = length(lambda);

N1 = sum(label==-1);
N2 = sum(label==1);

% number subjects according to Ncross
subN1 = rem(1:N1,Ncross)+1;
subN2 = rem(1:N2,Ncross)+1;

%rng(shufflei)
subN1 = subN1(randperm(N1));
%rng(shufflei)
subN2 = subN2(randperm(N2));
 
z2 = cell(Ncross,1);
pp2 = z2;

labelg = label;
%% groupLASSO 
parfor crossi = 1:Ncross
   
   % display(['CV ',num2str(crossi)])
    [trainIdx, testIdx{crossi}] = getCVidx(subN1,subN2,crossi);
    mvalues2 = mvalues(trainIdx,:);
     
    % train
    if opts.normalize ==1
        [mtrain,scale,base] = normalize0class(mvalues2,labelg(trainIdx));
    else
         mtrain = mvalues2;
         scale = ones(1,size(mvalues,2));
         base = zeros(1,size(mvalues,2));
    end        
    
    [w c]= pathSolutionLogistic(mtrain,labelg(trainIdx), lambda,opts); 
    
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

% LL.opts=opts;

%plotLASSOresults
%plotPdistz;
            
% retrain with optimal lambda
if opts.normalize == 1
    [mvalues, LL.scale, LL.base] = normalize0class(mvalues,label);
else
      LL.scale = ones(1,size(mvalues,2));
       LL.base = zeros(1,size(mvalues,2));
end
[LL.beta, LL.c] = pathSolutionLogistic(mvalues,label, lambda,opts);clear mtrain

