function LL = sgroupLASSOscannerNorm12(mvalues,label,scanner,opts)

Ncross = 10;
lambda1 = opts.lambda1;
lambda2 = opts.lambda2;
Nlambda = length(lambda1)*length(lambda2);

LMBD = zeros(2,Nlambda);
li = 1;

for kk = 1:length(lambda1)
        for jj = 1:length(lambda2)
            LMBD(:,li)=[lambda1(kk),lambda2(jj)];
            li = li+1;
        end
end


N11 = sum(label(scanner==1)==-1);
N12 = sum(label(scanner==1)==1);

N21 = sum(label(scanner==2)==-1);
N22 = sum(label(scanner==2)==1);

f1 = find(scanner ==1);
f2 = find(scanner ==2);

% number subjects according to Ncross
subN11 = rem(1:N11,Ncross)+1;
subN12 = rem(1:N12,Ncross)+1;

subN21 = rem(1:N21,Ncross)+1;
subN22 = rem(1:N22,Ncross)+1;

%%
rng(0)
subN11 = subN11(randperm(N11));
rng(0)
subN12 = subN12(randperm(N12));

rng(0)
subN21 = subN21(randperm(N21));
rng(0)
subN22 = subN22(randperm(N22));


z2 = cell(Ncross,1);
pp2 = z2;

labelg = label;
%% groupLASSO 

testIdx  = cell(1,Ncross);

%% groupLASSO 
for crossi = 1:Ncross
   
     % display(['CV ',num2str(crossi)])
    [trainIdx1, testIdx1] = getCVidx(subN11,subN12,crossi);
    [trainIdx2, testIdx2] = getCVidx(subN21,subN22,crossi);

    trainIdx = [f1(trainIdx1);f2(trainIdx2)];
    testIdx{crossi} = [f1(testIdx1);f2(testIdx2)];
    
    mvalues2 = mvalues(trainIdx,:);
    labeltrain = labelg(trainIdx);
     
    % train
    [mtrain,scale,base] = normalize0class_scannerwise(mvalues2,labeltrain,scanner(trainIdx));
    % test
    sctest = scanner(testIdx{crossi});
    mtest = mvalues(testIdx{crossi},:);
    
    for sci = 1:2%unique(sctest)'
        ff = (sctest == sci);
        mtest(ff,:) =  (mtest(ff,:)- repmat(base{sci},[sum(ff),1]))./repmat(scale{sci}, [sum(ff),1]);        
    end
    
    zz = zeros(length(testIdx{crossi}),Nlambda);
    pp = zz;
       
    parfor li = 1:Nlambda
        [w, c] = sgLogisticR(mtrain,labeltrain, LMBD(:,li),opts);
        tmp =  mtest*w(:)+c;
        zz(:,li) = tmp;
        pp(:,li) = 1./(1+exp(-tmp));
    end
    z2{crossi} = zz; 
    pp2{crossi} = pp;
end

%% reorder
for crossi = 1:Ncross
    LL.z(testIdx{crossi},:) = z2{crossi};
    LL.pp(testIdx{crossi},:) = pp2{crossi};
end

%% evaluate performance
p_spec2 =LL.pp(label==-1,:);
p_sens2 =LL.pp(label==1,:); clear pp2
             
FP = sum(p_spec2>0.5);
TP = sum(p_sens2>0.5);

TN = sum(p_spec2<0.5);
FN = sum(p_sens2<0.5);


LL.p_spec = p_spec2;
LL.p_sens = p_sens2;
 
LL.spec = mean(p_spec2<0.5,1);
LL.sens = mean(p_sens2>0.5,1);
LL.acc = (TP+TN)./(length(label));
 
prec = TP./(TP+FP);  %
recall = TP./(TP+FN); % = spec
             
 LL.Fscore = 2.*recall.*prec./(recall+prec);  
 LL.fOpt = getfOpt(LL.p_spec,LL.p_sens);

Nlambda2 = length(lambda2);
LL.fOpt1 = ceil(LL.fOpt/Nlambda2);
LL.fOpt2 = rem(LL.fOpt,Nlambda2);
if LL.fOpt2 ==0
    LL.fOpt2 = Nlambda2;
end

LL.opts=opts;

%plotLASSOresults2D;
%plotPdistz2D;
            
% retrain with optimal lambda
 % if nflag==1
     [mvalues, LL.scale, LL.base] = normalize0class_scannerwise(mvalues,label,scanner);
 % else
 %    LL.scale{1} = ones(1,size(mvalues,2));
 %    LL.base{1} = zeros(1,size(mvalues,2));
 % end
LL.lambda{1} = lambda1;
LL.lambda{2} = lambda2;


% retrain with optimal lambda
betaAll = zeros(size(mvalues,2),Nlambda);
cAll = zeros(1,Nlambda);
parfor li = 1:Nlambda
        [betaAll(:,li), cAll(li)] = sgLogisticR(mvalues,label, LMBD(:,li),opts);     
 end
LL.betaAll = betaAll;
LL.cAll = cAll;
LL.beta = LL.betaAll(:,LL.fOpt);
LL.c  = LL.cAll(LL.fOpt);

