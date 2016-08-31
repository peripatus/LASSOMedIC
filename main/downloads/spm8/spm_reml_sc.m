function [C,h,Ph,F,Fa,Fc] = spm_reml_sc(YY,X,Q,N,hE,hC,V)
% ReML estimation of covariance components from y*y' - proper components
% FORMAT [C,h,Ph,F,Fa,Fc] = spm_reml_sc(YY,X,Q,N,[hE,hC,V]);
%
% YY  - (m x m) sample covariance matrix Y*Y'  {Y = (m x N) data matrix}
% X   - (m x p) design matrix
% Q   - {1 x q} covariance components
% N   - number of samples
%
% hE  - hyperprior expectation in log-space [default = -32]
% hC  - hyperprior covariance  in log-space [default = 256]
% V   - fixed covariance component
%
% C   - (m x m) estimated errors = h(1)*Q{1} + h(2)*Q{2} + ...
% h   - (q x 1) ReML hyperparameters h
% Ph  - (q x q) conditional precision of log(h)
%
% F   - [-ve] free energy F = log evidence = p(Y|X,Q) = ReML objective
%
% Fa  - accuracy
% Fc  - complexity (F = Fa - Fc)
%
% Performs a Fisher-Scoring ascent on F to find MAP variance parameter
% estimates.  NB: uses weakly informative log-normal hyperpriors.
% See also spm_reml for an unconstrained version that allows for negative
% hyperparameters
%
%__________________________________________________________________________
%
% SPM ReML routines:
%
%      spm_reml:    no positivity constraints on covariance parameters
%      spm_reml_sc: positivity constraints on covariance parameters
%      spm_sp_reml: for sparse patterns (c.f., ARD)
%
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging
 
% Karl Friston
% $Id: spm_reml_sc.m 3813 2010-04-07 19:21:49Z karl $

 
% assume a single sample if not specified
%--------------------------------------------------------------------------
try, N; catch, N  = 1;  end
try, V; catch, V  = 0;  end

% initialise h
%--------------------------------------------------------------------------
n     = length(Q{1});
m     = length(Q);
h     = zeros(m,1);
dFdh  = zeros(m,1);
dFdhh = zeros(m,m);
 
% ortho-normalise X
%--------------------------------------------------------------------------
if isempty(X)
    X = sparse(n,0);
    R = speye(n,n);
else
    X = spm_svd(X,0);
    R = speye(n,n) - X*X';
end

% check fixed component
%--------------------------------------------------------------------------
if length(V) == 1
    V = V*speye(n,n);
end

 
% initialise and specify hyperpriors
%==========================================================================

% scale Q and YY
%--------------------------------------------------------------------------
sY = trace(R*YY)/(N*n);
YY = YY/sY;
V  = V/sY;
for i = 1:m
    sh(i,1) = trace(R*Q{i})/n;
    Q{i}    = Q{i}/sh(i);
end


% hyperpriors
%--------------------------------------------------------------------------
try, hE = hE(:);        catch, hE = -32;   end
try, hP = spm_inv(hC);  catch, hP = 1/256; end
 
% check sise
%--------------------------------------------------------------------------
if length(hE) < m, hE = hE(1)*ones(m,1);   end
if length(hP) < m, hP = hP(1)*speye(m,m);  end

% intialise h: so that sum(exp(h)) = 1
%--------------------------------------------------------------------------
if any(diag(hP) > exp(16))
    h = hE;
end
 
% ReML (EM/VB)
%--------------------------------------------------------------------------
dF    = Inf;
as    = 1:m;
t     = 4;
for k = 1:32
 
    % compute current estimate of covariance
    %----------------------------------------------------------------------
    C     = V;
    for i = as
        C = C + Q{i}*exp(h(i));
    end
    iC    = spm_inv(C);
 
    % E-step: conditional covariance cov(B|y) {Cq}
    %======================================================================
    iCX    = iC*X;
    if ~isempty(X)
        Cq = inv(X'*iCX);
    else
        Cq = sparse(0);
    end
 
    % M-step: ReML estimate of hyperparameters
    %======================================================================
 
    % Gradient dF/dh (first derivatives)
    %----------------------------------------------------------------------
    P     = iC - iCX*Cq*iCX';
    U     = speye(n) - P*YY/N;
    for i = as
 
        % dF/dh = -trace(dF/diC*iC*Q{i}*iC)
        %------------------------------------------------------------------
        PQ{i}   = P*Q{i};
        dFdh(i) = -trace(PQ{i}*U)*N/2;
 
    end
 
    % Expected curvature E{dF/dhh} (second derivatives)
    %----------------------------------------------------------------------
    for i = as
        for j = as
 
            % dF/dhh = -trace{P*Q{i}*P*Q{j}}
            %--------------------------------------------------------------
            dFdhh(i,j) = -trace(PQ{i}*PQ{j})*N/2;
            dFdhh(j,i) =  dFdhh(i,j);
 
        end
    end
 
    % modulate
    %----------------------------------------------------------------------
    dFdh  = dFdh.*exp(h);
    dFdhh = dFdhh.*(exp(h)*exp(h)');
 
    % add hyperpriors
    %----------------------------------------------------------------------
    e     = h     - hE;
    dFdh  = dFdh  - hP*e;
    dFdhh = dFdhh - hP;
 
    % Fisher scoring: update dh = -inv(ddF/dhh)*dF/dh
    %----------------------------------------------------------------------
    dh    = spm_dx(dFdhh(as,as),dFdh(as),{t});
    h(as) = h(as) + dh;
    

    % predicted change in F - increase regularisation if increasing
    %----------------------------------------------------------------------
    pF    = dFdh(as)'*dh;
    if pF > dF
        t = t - 1;
    else
        t = t + 1/8;
    end
    dF    = pF;
    
    % convergence
    %----------------------------------------------------------------------
    fprintf('%s %-23d: %10s%e [%+3.2f]\n','  ReML Iteration',k,'...',full(dF),t);
    if dF < 1e-2
        break
    else
        % eliminate redundant components (automatic selection)
        %------------------------------------------------------------------
        as  = find(h > -16);
        as  = as(:)';
    end
end

% log evidence = ln p(y|X,Q) = ReML objective = F = trace(R'*iC*R*YY)/2 ...
%--------------------------------------------------------------------------
Ph    = -dFdhh;
if nargout > 3
 
    % tr(hP*inv(Ph)) - nh + tr(pP*inv(Pp)) - np (pP = 0)
    %----------------------------------------------------------------------
    Ft = trace(hP/Ph) - length(Ph) - length(Cq);
 
    % complexity - KL(Ph,hP)
    %----------------------------------------------------------------------
    Fc = Ft/2 + e'*hP*e/2 + spm_logdet(Ph/hP)/2 - N*spm_logdet(Cq)/2;
 
    % Accuracy - ln p(Y|h)
    %----------------------------------------------------------------------
    Fa = Ft/2 - trace(C*P*YY*P)/2 - N*n*log(2*pi)/2  - N*spm_logdet(C)/2;
 
    % Free-energy
    %----------------------------------------------------------------------
    F  = Fa - Fc - N*n*log(sY)/2;
 
end


% return exp(h) hyperpriors and rescale
%--------------------------------------------------------------------------
h  = sY*exp(h)./sh;
C  = sY*C;