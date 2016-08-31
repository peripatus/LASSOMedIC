   %% get algorithm
            algorithms = get(handles.ChooseAlgorithm,'String'); 
            achoice = get(handles.ChooseAlgorithm,'Value'); 
            %% verbose
            display(['Classifying using ',algorithms{achoice},' LASSO']);

            %% parameters 
            % Data
            LoadLASSOParameters;
            opts.plotFlag = get(handles.plotButton,'Value');

            %% get data
            DataFiles = get(handles.DataFiles,'String');
            %whos DataFiles
            if ischar(DataFiles)
                DataFiles= {DataFiles};
            end
            
            PathName = handles.CPathName;
            DataFiles=strrep(DataFiles,'.mat','');
          
            %% 
            
            switch achoice
            %%%%%%%%%%%%%%%%%%%%%%% L1L1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 1 % L1L1
                    opts.fName = 'glLogisticR';
                    opts.q = 1; %<< L1L1
                    lambda1 = get(handles.lambda1Input,'String');
                    if strfind(lambda1,'<')
                        display('Input parameter range for feature sparseness')
                    else
                        opts.lambda =  eval(lambda1);
                    end
                    
                    %% classify
                 
                        for di = 1:length(DataFiles)
                            analyseData = fullfile(PathName,DataFiles{di})
                            display(['Classifying ',DataFiles{di}])
                            load(analyseData,'features','BA*','label')
        
                            features =logical(features);
                            
                            bins = ones(1,sum(features));
                            opts.label = label;
                            opts.ind = [0 cumsum(bins(1:end))]
                            clear features 
 
                            applyLASSOloopShuffle(PathName,DataFiles{di},opts);
                            display('Done')
                            display('Evaluating Performance')
                            evaluateGroupLASSO_L1L1_loopShuffle(PathName,DataFiles{di},opts);
                        end
                  
            %%%%%%%%%%%%%%%%%%%%%%% group %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 2 % group
                opts.q=2;
                opts.fName = 'glLogisticR';
                opts.lambda =  eval(get(handles.lambda2Input,'String'));
                  %% classify
                        for di = 1:length(DataFiles)
                            analyseData = fullfile(PathName,DataFiles{di});
                            display(['Classifying ',DataFiles{di}])
                            load(analyseData,'features','BA*','label')
                            opts.label = label;
                            features =logical(features);
                           
                            if isempty(opts.bins) && get(handles.groupBvoxelsButton,'Value')==1
                                % sort mvalues acoording to brain areas 
                                [vol3Dsort,sortInd] = sort(BAlabelvol(features)); clear features BAlabelvol
                                opts.sortInd=sortInd;
                                clear BAnom sortInd

                                % count voxels for each brain area
                                vol3Dsort_u = unique(vol3Dsort);
                                opts.bins = hist(vol3Dsort,vol3Dsort_u);
                                clear vol3Dsort*
                           % else
                           %     bins = opts.bins;
                            end
                            opts.ind = [0 cumsum(opts.bins)]

                            clear features 
    
                            applyLASSOloopShuffle(PathName,DataFiles{di},opts);
                            display('Done')
                            display('Evaluating Performance')
                            evaluateGroupLASSO_group_loopShuffle(PathName,DataFiles{di},opts);
                            close all
                        end
             
            %%%%%%%%%%%%%%%%%%%%%%% sparse group %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            case 3 %group sparse
                    opts.fName = '';
                    opts.lambda1 =  eval(get(handles.lambda1Input,'String'));
                    opts.lambda2 =  eval(get(handles.lambda2Input,'String'));
                    display('sorry, not implemented yet...')
                    display('please use groupLASSO as approximate consolation')
                    
                    %% classify
                      %applyLASSOloopShuffle(PathName,DataFiles{di},opts);
                        %    display('Done')
                        %    display('Evaluating Performance')
                       %    evaluateGroupLASSO_group_loopShuffle(PathName,DataFiles{di},opts);
            end
     