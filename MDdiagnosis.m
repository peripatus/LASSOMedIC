function varargout = Diagnosis(varargin)
% DIAGNOSIS MATLAB code for Diagnosis.fig
%      DIAGNOSIS, by itself, creates a new DIAGNOSIS or raises the existing
%      singleton*.
%
%      H = DIAGNOSIS returns the handle to a new DIAGNOSIS or the handle to
%      the existing singleton*.
%
%      DIAGNOSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIAGNOSIS.M with the given input arguments.
%
%      DIAGNOSIS('Property','Value',...) creates a new DIAGNOSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Diagnosis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Diagnosis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Diagnosis

% Last Modified by GUIDE v2.5 09-Aug-2016 14:50:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Diagnosis_OpeningFcn, ...
                   'gui_OutputFcn',  @Diagnosis_OutputFcn, ...
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


% --- Executes just before Diagnosis is made visible.
function Diagnosis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Diagnosis (see VARARGIN)

% Choose default command line output for Diagnosis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Diagnosis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Diagnosis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function BDNFexon_Callback(hObject, eventdata, handles)


function BDNFexon_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function T1image_Callback(hObject, eventdata, handles)


function T1image_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function RESTfolder_Callback(hObject, eventdata, handles)


function RESTfolder_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function DiagnoseButton_Callback(hObject, eventdata, handles)


function HealthyToggle_Callback(hObject, eventdata, handles)
 basecir(:,:,1)=ones(20);
basecir(:,:,2)=ones(20);
basecir(:,:,3) = ones(20);
%basecir=uint8(basecir);
set(handles.HealthyToggle,'CData',basecir);


function MDDbutton_Callback(hObject, eventdata, handles)


function CredibilityValue_Callback(hObject, eventdata, handles)


function CredibilityValue_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
