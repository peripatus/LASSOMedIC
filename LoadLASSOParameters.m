
% Data
opts.normalize = 1; % normalization

% algorithm (for further options see SLEP toolbox)
opts.rFlag = 0;  % use multiples of biggest lambda, yes/no
opts.tol = 10^-8; %  lower threshold for weights, 
%should really be adjusted according to the number of input features and the value they take....
opts.bins = []; % use for grouping different from brain area grouping
opts.sortInd = []; % sorting index for features in case resorting of the features is necessary for grouping

% cross validation
opts.Ncross = 10;  %% nr of folds
opts.Nshuffle = 3; %% shuffle data Nshuffle times

% Evaluation
opts.freq = 75; % frequency of 
