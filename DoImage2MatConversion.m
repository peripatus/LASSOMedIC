   
    display('Image Conversion to Datamatrix')

        Folders = get(handles.ImageFolders,'string');
        Btemplate = get(handles.ChooseBrainTemplate,'String');
        TemplateSelected = Btemplate{get(handles.ChooseBrainTemplate,'Value')};
        TemplateSelected = strrep(TemplateSelected,' (AAL)','');
        display(['Using ',TemplateSelected])    
    
        % get images
        for folderi = 1:length(Folders)
          
            %% get images
            filenames = cfg_getfile('FPList',Folders{folderi},'nii');
            filenames = [filenames;cfg_getfile('FPList',Folders{folderi},'hdr')];
            
            template = filenames{1};
            
            % use first image as template for brain areas
            [BAlabelvol,BAnom]= eval([TemplateSelected,'vol(template);']);
            features = BAlabelvol(:)>0;   

            mvalues = zeros(length(filenames),sum(features));
            display('Reading Data')
            for ffi = 1:length(filenames)
                tmpImg = load_nii(filenames{ffi});
                vol3D = double(tmpImg.img);  clear tmpImage
                vol3D(isnan(vol3D)) = 0;
                mvalues(ffi,:) = vol3D(features); clear vol3D
            end
            
            %%  getlabel
            if get(handles.MakeLabelButton,'Value') == 1
                display('Making Label')
                filt1 = get(handles.GetGroup1Filt,'String');
                filt0 = get(handles.GetGroup0Filt,'String');
                label = ~cellfun(@isempty, strfind(filenames,filt1));
            else
                display(['Loading Label ',get(handles.LabelFile,'String')]);
                load(get(handles.LabelFile,'String'))
                filt0='C';
                filt1='T';
            end
            
            %% save
            resultdir = get(handles.ResultDirectory,'String');
            [~,saveName] = fileparts(Folders{folderi});
            
            Cdata{folderi} = [saveName,'_',TemplateSelected];
            
            savefile = fullfile(resultdir,Cdata{folderi});
            save(savefile,'mvalues','BAlabelvol','BAnom','features','template','label','filt*') 
            display(['Data saved to ',savefile])

            %% mean of brain areas 
            if get(handles.MeanBrainActivityButton,'Value') == 1
                display('Calculating mean activation')
                areas = BAlabelvol(features);
                tmp = zeros(size(mvalues,1),length(BAnom));
                for ai = 1:length(BAnom)  
                    tmp(:,ai) = mean(mvalues(:,areas==ai),2);
                end
                mvalues = tmp;
                features = ones(1,length(BAnom));
                % discard where too many 0
                savefile = [savefile,'_BAmean'];
                Cdata{folderi} = [saveName,'_',TemplateSelected,'_BAmean'];
               
                save(savefile,'mvalues','BAlabelvol','BAnom','features','label','filt*') 
                display(['Data saved to ',savefile])
            end
        end
        %if get(handles.Classification,'Value')==1 
             if isempty(get(handles.DataFiles,'String'))  || ~isempty(strfind(get(handles.DataFiles,'String'),'<'))
                set(handles.DataFiles, 'String',Cdata);
             end
        %end