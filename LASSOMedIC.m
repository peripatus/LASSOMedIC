
function varargout = LASSOMedIC(varargin)
% LASSOMEDIC MATLAB code for LASSOMedIC.fig
%      LASSOMEDIC, by itself, creates a new LASSOMEDIC or raises the existing
%      singleton*.
%
%      H = LASSOMEDIC returns the handle to a new LASSOMEDIC or the handle to
%      the existing singleton*.
%
%      LASSOMEDIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LASSOMEDIC.M with the given input arguments.
%
%      LASSOMEDIC('Property','Value',...) creates a new LASSOMEDIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LASSOMedIC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LASSOMedIC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to runbutton (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LASSOMedIC

% Last Modified by GUIDE v2.5 27-Jun-2016 12:08:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LASSOMedIC_OpeningFcn, ...
                   'gui_OutputFcn',  @LASSOMedIC_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%addpath(genpath('~/matlab_misc'))
addpath(genpath('global'))
addpath(genpath('main'))



% --- Executes just before LASSOMedIC is made visible.
function LASSOMedIC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user GetDataToClassify (see GUIDATA)
% varargin   command line arguments to LASSOMedIC (see VARARGIN)

% Choose default command line output for LASSOMedIC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LASSOMedIC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LASSOMedIC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user GetDataToClassify (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% Process selection %%%%%%%%%%%%%%%%%%%%%%

%% Image Conversion and Classification selection
function Image2MatConversion_Callback(hObject, eventdata, handles)
    if get(hObject,'value') ==1
        set(handles.PreprocessingPanel,'ForegroundColor', [ 0.314 0.6 0.314])
          set(handles.RunButton,'ForegroundColor','k')
           set(handles.ChooseBrainTemplate,'ForegroundColor','k')
    else
        set(handles.PreprocessingPanel,'ForegroundColor',[0.314 0.314 0.314])
        set(handles.ChooseBrainTemplate,'ForegroundColor',[0.314 0.314 0.314])
        if get(handles.Classification,'value') == 0
            set(handles.RunButton,'ForegroundColor',[0.502 0.502 0.502])
        end
    end
    
    
function Classification_Callback(hObject, eventdata, handles)
    if get(hObject,'value') ==1
        set(handles.ClassificationPanel,'ForegroundColor',[ 0.314 0.6 0.314])
        set(handles.RunButton,'ForegroundColor','k')
       
    else
        set(handles.ClassificationPanel,'ForegroundColor',[0.314 0.314 0.314])
        if get(handles.Image2MatConversion,'value') == 0
            set(handles.RunButton,'ForegroundColor',[0.502 0.502 0.502])
        end
    end
    
   

%% Image Preprocessing %%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in GetImagefolders.
function GetImagefolders_Callback(hObject, eventdata, handles)
% hObject    handle to GetImagefolders (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user GetDataToClassify (see GUIDATA)

%% folders or image files
Folders =  uigetfile_n_dir;
set(handles.ImageFolders,'Value',length(Folders))
%get(handles.GetImagefolders,'Value')
%handles.Folders = Folders;
%guidata(hObject,handles)
set(handles.ImageFolders,'string',Folders)


% --- Executes during object creation, after setting all properties.
function ImageFolders_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ImageFolders.
function ImageFolders_Callback(hObject, eventdata, handles)
%delete folders clicked on 
     prev_str = get(hObject, 'String');
    if ~isempty(prev_str)
        prev_str(get(hObject,'Value')) = [];
        set(handles.ImageFolders,'Value',length(prev_str))
        set(hObject, 'String', prev_str)
    end
  


% --- Executes on selection change in ChooseBrainTemplate.
function ChooseBrainTemplate_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ChooseBrainTemplate_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function MeanBrainActivityButton_Callback(hObject, eventdata, handles)


%%% Labels %%%%%       
function MakeLabelButton_Callback(hObject, eventdata, handles)
if get(hObject,'Value') ==1;
    set(handles.LoadLabelButton,'Value',0);
else
    set(handles.LoadLabelButton,'Value',1);    
end

function GetGroup0Filt_Callback(hObject, eventdata, handles)
function GetGroup0Filt_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function GetGroup1Filt_Callback(hObject, eventdata, handles)
function GetGroup1Filt_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LoadLabelButton_Callback(hObject, eventdata, handles)
if get(hObject,'Value') ==1;
    set(handles.MakeLabelButton,'Value',0);
else
    set(handles.MakeLabelButton,'Value',1);    
end

function LoadLabelFile_Callback(hObject, eventdata, handles)
    set(handles.LoadLabelButton,'Value',1) ;
    set(handles.MakeLabelButton,'Value',0);
    [Labelfile,Lpath] = uigetfile('*.mat','Choose Labelfile');
    set(handles.LabelFile,'String',fullfile(Lpath,Labelfile));


function LabelFile_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%% Result Directory

function GetResultDirectory_Callback(hObject, eventdata, handles)
directoryname = uigetdir(pwd); 
set(handles.ResultDirectory,'String',directoryname,'ForegroundColor','k');

%function ResultDirectory_Callback(hObject, eventdata, handles)


function ResultDirectory_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%% CLASSIFICATION %%%%%%%%%%%

% --- Executes on button press in GetDataToClassify.
function GetDataToClassify_Callback(hObject, eventdata, handles)
    [FileName,PathName] = uigetfile({'*.mat'},'MultiSelect', 'on');
    handles.CPathName=PathName;
    guidata(hObject,handles)
    if ischar(FileName)
        FileName = {FileName};
    end
    set(handles.DataFiles,'Value',length(FileName))
    set(handles.DataFiles,'String',FileName)

% --- Executes on selection 
function DataFiles_Callback(hObject, eventdata, handles)
    %delete folders clicked on  
    prev_str = get(hObject, 'String');
    if ischar(prev_str)
        prev_str = {prev_str};
    end
      if ~isempty(prev_str)
        prev_str(get(hObject,'Value')) = [];
        set(hObject,'Value',length(prev_str))
        set(hObject, 'String', prev_str)
    end
    
    
% --- Executes during object creation, after setting all properties.
function DataFiles_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChooseAlgorithm.
function ChooseAlgorithm_Callback(hObject, eventdata, handles)
    handles.achoice = get(hObject,'Value');
    guidata(hObject,handles);
switch handles.achoice
    case 1
        set(handles.lambda1Input,'Enable','on')
        set(handles.lambda2Input,'Enable','off')
        set(handles.groupBvoxelsButton,'Enable','off')
    case 2
        set(handles.lambda1Input,'Enable','off')
        set(handles.lambda2Input,'Enable','on')
        set(handles.groupBvoxelsButton,'Enable','on')
    case 3
        set(handles.lambda1Input,'Enable','on')
        set(handles.lambda2Input,'Enable','on')
        set(handles.groupBvoxelsButton,'Enable','on')
end

function ChooseAlgorithm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lambda1Input_Callback(hObject, eventdata, handles)
function lambda1Input_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lambda2Input_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function lambda2Input_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    
function groupBvoxelsButton_Callback(hObject, eventdata, handles)
set(handles.groupIndicesButton,'Value',~get(hObject,'Value'))

function groupIndicesButton_Callback(hObject, eventdata, handles)
set(handles.groupBvoxelsButton,'Value',~get(hObject,'Value'))


% --- Executes on button press in plotButton.
function plotButton_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN                   %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in RunButton.
function RunButton_Callback(hObject, eventdata, handles)

        set(hObject,'string','Running','backgroundcolor',[0.7 0.314  0.314]);
        pause(0.1) % time for gui... stop button doesn't work right now
        set(handles.RunButton,'string','Run','backgroundcolor','white');
    
        %% do Image2MatConversion?
        if get(handles.Image2MatConversion,'Value') == 1
            DoImage2MatConversion;
        end
        
        %% Classification?
        if get(handles.Classification,'Value') == 1
            if ~isfield(handles,'CPathName') 
                handles.CPathName = get(handles.ResultDirectory,'String');
            elseif strcmp(num2str(handles.CPathName),'0')
                  handles.CPathName = get(handles.ResultDirectory,'String');
            end
           DoClassification;
        end
        
%         function ChangeParametersButton_Callback(hObject, eventdata, handles)
%     prompt={'Nshuffle','Ncross','Normalize','opts.rflag','opts.tol'};
%     name='Change Defaults';
%     numlines=1;
%     defaultanswer={'10','10','1','1','10^-8'};
%     handles.parameters = inputdlg(prompt,name,numlines,defaultanswer);
%  
