function LL = sgroupLASSO(mvalues,label,opts)

Ncross = 10;
lambda1 = opts.lambda1;
lambda2 = opts.lambda2;


Nlambda = length(lambda1)*length(lambda2);

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

testIdx = cell(1,Ncross);

LMBD = zeros(2,Nlambda);
li = 1;

for kk = 1:length(lambda1)
        for jj = 1:length(lambda2)
            LMBD(:,li)=[lambda1(kk),lambda2(jj)];
            li = li+1;
        end
end

%% groupLASSO 
if isfield(opts,'normalize')
    nflag = opts.normalize;
else
    nflag = 1;
end

if isfield(opts,'scanner')
    scanner = opts.scanner;
else
    scanner = ones(1,size(mvalues,1));
end


binary = [];
for fbi = 1:size(mvalues,2)
        if (sum(abs(unique(mvalues(:,fbi)))) == 2) || (sum(abs(unique(mvalues(:,fbi)))) == 1)
            binary = [binary,fbi];
        end        
end


%% groupLASSO 
for crossi = 1:Ncross
   
  %  display(['CV ',num2str(crossi)])
    [trainIdx, testIdx{crossi}] = getCVidx(subN1,subN2,crossi);
    mvalues2 = mvalues(trainIdx,:);
    labeltrain = label(trainIdx);  
    scannertrain = scanner(trainIdx);
    scannertest = scanner(testIdx{crossi});
    % train
    
       % train
    if nflag==1
        [mtrain,scale,base] = normalize0class_scannerwise(mvalues2,labeltrain,scannertrain);
        mtrain(:,binary) = mvalues2(:,binary);
        for sci = 1:length(scale)
            scale{sci}(binary) = 1;
            base{sci}(binary) = 0;
        end
    else
        mtrain = mvalues2;
        scale{1} = ones(1,size(mvalues2,2));
        base{1} = zeros(1,size(mvalues2,2));
    end
    
    mtest = mvalues(testIdx{crossi},:);
    for sci = unique(scannertest)'
        ff = (scannertest==sci);
        if ~isempty(base{sci})
            mtest(ff,:) =  (mtest(ff,:)- repmat(base{sci},[sum(ff),1]))./repmat(scale{sci}, [sum(ff),1]);        
        else
            mtest(ff,:) =  (mtest(ff,:)- repmat(base{1},[sum(ff),1]))./repmat(scale{1}, [sum(ff),1]);
        end
    end
    
    zz = zeros(length(testIdx{crossi}),Nlambda);
    pp = zz;
       
  %  sum(isnan(mtrain(:)))
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
  if nflag==1
     [mtmp, LL.scale, LL.base] = normalize0class_scannerwise(mvalues,label,scanner);
        mtmp(:,binary) = mvalues(:,binary);
         mvalues = mtmp; clear mtmp
        for sci = 1:length(LL.scale)
            LL.scale{sci}(binary) = 1;
            LL.base{sci}(binary) = 0;
        end
       
  else
     LL.scale{1} = ones(1,size(mvalues,2));
     LL.base{1} = zeros(1,size(mvalues,2));
  end
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

