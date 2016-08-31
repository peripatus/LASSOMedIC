function [LL,fit]=looCVLogitLasso2(x,y,varargin)

%% test on one D and one N each 
%% cycle through all subjects when unequal number of D and N
%% 
%%
% Function: looCVLogitLasso
%   fits a logistic regression model with the L-1 norm regularization to
%   given data (x,y). The hyper-parameter for controlling the the
%   regularization, lambda, is optimized based on the leave-one-out cross
%   validation.
%
% USAGE:
%   [LL,fit]=looCVLogitLasso(x,y)
%   LL=looCVLogitLasso(x,y,nlambda,lambda_min)
%   LL=looCVLogitLasso(x,y,nlambda,lambda_min)
%
% More detail will be added in the future.
% Jun May 2012
%
%   fit ... array, Models of crossvalidation
%   LL .... Model resulting from training using all subjects
%
%
%   sequence of lambda adjusted to coincide for all models in the cross
%   evaluation (first automatically evaluated sequence used for all the others)
%   yu June 2012

%  number of group 1 and group 2 subjects adjusted to be the same 
%  rotate other subjects to achieve more crosscorrelation options
%  yu november 2012

% Constants
%

% Get the number of data
Ndata=size(x,1);

%%
%
% Preprocessing
%

% Check dimensionality
if size(y,1)~=Ndata
    error('y should have the same number of rows as x.')
end
if size(y,2)~=1
    error('y should be a row vector');
end

% Check the labels of y
label=sort(unique(y),'ascend');
if length(label)~=2,
    error('y is not an output vector for binary classification.');
end
yy=ones(Ndata,1);
yy(y==label(2))=2;
y=yy;

if length(varargin)>3
    error('The number of inputs should be less than 5.');
end

% Set options for Logit-LASSO model
options=glmnetSet;
options.alpha=1;
options.maxit=500;
options.HessianExact=false;
if(length(varargin)>=1)
     if length(varargin{1})==1
        options.nlambda=varargin{1};
    else
        options.lambda = varargin{1};
    end
end
if(length(varargin)>=2)
    options.lambda_min=varargin{2};
end

%%
%
% Training phase in leave-one-out for each group - cross validation
%

f1 = find(y == 1);
f2 = find(y == 2);

N1 = length(f1);
N2 = length(f2);
Nnew = abs(N1-N2);
Ndata = min(N1,N2)


% get lambda sequence from first dataset
%whos lambda
%idx=[f1(2:Ndata),f2(2:Ndata)];
idx=[f1(2:N1);f2(2:N2)];
x_tr = x(idx,:);
y_tr = y(idx,:);
fit(1)=glmnet(x_tr,y_tr,'binomial',options); 
options.lambda = fit(1).lambda;
lambda = options.lambda;
%figure
%plot(options.lambda,'rx-')
%hold on 

% use same lambda sequence for rest of cross validation
parfor n=2:Ndata
    idx=[f1([1:n-1,n+1:end]);f2([1:n-1,n+1:end])];
    x_tr = x(idx,:);
    y_tr = y(idx,:);
    fit(n)=glmnet(x_tr,y_tr,'binomial',options); 
end

    

%lambda = unique(cat(1,fit(:).lambda)); % yu may 2012, redundant, as lambda adjusted to first dataset
%lambda = sort(lambda,'descend');
nlambda=length(options.lambda);

y_link=zeros(Ndata,2,nlambda);
y_prob=zeros(Ndata,2,nlambda);
y_pred=ones(Ndata,2,nlambda);
tf_flag=ones(Ndata,2,nlambda);
logP=zeros(Ndata,2,nlambda);


%%
%
% Validation phase  
%
%k = 1;
for n=1:Ndata
    x_test = x([f1(n),f2(n)],:);
    y_test = y([f1(n),f2(n)],:);

    z=glmnetPredict(fit(n),'link',x_test,lambda);
    
    y_link(n,:,:)=z;
    y_prob(n,:,:)=1./(1+exp(-z));
    
    for li = 1:2
        y_pred(n,li,z(li,:)>=0)=2;
        tf_flag(n,li,z(li,:).*(y_test(li)-1.5)<0)=0;
   
        idx1=find(z(li,:)>=0);
        idx2=find(z(li,:)<0);
        
        if li == 1
            logP(n,li,idx2)=-log(1+exp(z(li,idx2)));
            logP(n,li,idx1)=-z(li,idx1)-log(1+exp(-z(li,idx1)));
        else
            logP(n,li,idx1)=-log(1+exp(-z(li,idx1)));
            logP(n,li,idx2)=z(li,idx2)-log(1+exp(z(li,idx2)));
        end
        
    end
end
 
 
%whos tf_flag

%% save 

accuracy=squeeze(mean(mean(tf_flag,1),2));
tf_flag_sens = squeeze(tf_flag(:,1,:));
tf_flag_spec = squeeze(tf_flag(:,2,:));

specificity=mean(tf_flag_spec,1);
sensitivity=mean(tf_flag_sens,1);

TP = sum(tf_flag_sens>0);
TN = sum(tf_flag_spec>0);   

    FN = sum(tf_flag_sens==0);    
    FP = sum(tf_flag_spec==0);    
    
    LL.prec = TP./(TP+FP);  %
    LL.recall = TP./(TP+FN); % = spec
    LL.Fscore = 2.*LL.recall.*LL.prec./(LL.recall+LL.prec);  


mlogP=squeeze(mean(mean(logP,1),2));

% figure
% plot(logP')
% hold on
% plot(mlogP','k--')
LL.fit = fit;
LL.y_pred=y_pred;
LL.ytest=y; % test values
LL.p_spec= squeeze(y_prob(:,1,:)); % probability of predicted labels
LL.p_sens =  squeeze(y_prob(:,2,:));
LL.flag = tf_flag; % predicted values
LL.lambda=lambda;
LL.acc=accuracy;
LL.sens=sensitivity;
LL.spec=specificity;
LL.mlogP=mlogP;
     

    %% Training phase using all the data and optimized lambda

   LL.model_full=glmnet(x,y,'binomial',options);
   LL.fOpt = getfOpt(LL.spec,LL.sens,LL.p_spec,LL.p_sens);
       

end
