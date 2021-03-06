function [LL,fit]=looCVLogitLasso(x,y,varargin)
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

%%
%
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
    error('y is not a output vector for binary classification.');
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
% Training phase in leave-one-out cross validation
%

% get lambda sequence from first dataset
n=1;
    idx=[1:n-1,n+1:Ndata];
    x_tr = x(idx,:);
    y_tr = y(idx,:);
    fit(n)=glmnet(x_tr,y_tr,'binomial',options); 

options.lambda = fit(1).lambda;
     
% use same lambda sequence for rest of cross validation
parfor n=2:Ndata,
    idx=[1:n-1,n+1:Ndata];
    x_tr = x(idx,:);
    y_tr = y(idx,:);
    fit(n)=glmnet(x_tr,y_tr,'binomial',options); 
end


%lambda = unique(cat(1,fit(:).lambda)); % yu may 2012, redundant, as lambda adjusted to first dataset
%lambda = sort(lambda,'descend');
lambda = options.lambda;
nlambda=length(lambda);

y_link=zeros(Ndata,nlambda);
y_prob=zeros(Ndata,nlambda);
y_pred=ones(Ndata,nlambda);
tf_flag=ones(Ndata,nlambda);
logP=zeros(Ndata,nlambda);


%%
%
% Validation phase in leave-one-out cross validation
%

for n=1:Ndata,
    x_test = x(n,:);
    y_test = y(n,:);
    z=glmnetPredict(fit(n),'link',x_test,lambda);
    
    y_link(n,:)=z;
    y_prob(n,:)=1./(1+exp(-z));
    y_pred(n,z>=0)=2;
    tf_flag(n,z.*(y_test-1.5)<0)=0;%
    
    idx1=find(z>=0);
    idx2=find(z<0);
    if(y_test==2),
        logP(n,idx1)=-log(1+exp(-z(idx1)));
        logP(n,idx2)=z(idx2)-log(1+exp(z(idx2)));
    else
        logP(n,idx2)=-log(1+exp(z(idx2)));
        logP(n,idx1)=-z(idx1)-log(1+exp(-z(idx1)));
    end
end
accuracy=mean(tf_flag,1);
sensitivity=mean(tf_flag(y==2,:),1);
specificity=mean(tf_flag(y==1,:),1);
mlogP=mean(logP,1);

% figure
% plot(logP')
% hold on
% plot(mlogP','k--')
LL.fit = fit;
LL.y=y; % test values
LL.y_prob = y_prob; % probability of predicted labels
LL.flag = tf_flag; % predicted values
LL.lambda=lambda;
LL.accuracy=accuracy;
LL.sensitivity=sensitivity;
LL.specificity=specificity;
LL.mlogP=mlogP;


     

%% Training phase using all the data and optimized lambda

LL.model_full=glmnet(x,y,'binomial',options);
    % get best lambda
       acc = LL.accuracy';
       sens = LL.sensitivity';%(1:20:end)';
       spec = LL.specificity';%(1:20:end)';
       lambda = LL.lambda;
       
       
       nlambda = length(LL.model_full.lambda);
        Q1 = [0,0];
       Q2 = [1,1];
       parfor li = 1:nlambda
            P=[1-spec(li),sens(li)]; 
            d(li) = det([Q2-Q1;P-Q1])/norm(Q2-Q1); 
       end
       
         if max(d(:))==0
            LL.fOpt = 1;    
       else
            fd = find(d==max(d(:)));
            LL.fOpt = fd(end);
       end
       

%LL.model_mlogPopt=glmnet(x,y,'binomial',options);

%[~,idx]=max(accuracy-(abs(specificity-sensitivity)));
%options.lambda=lambda(idx);
%LL.model_predOpt=glmnet(x,y,'binomial',options);

end
