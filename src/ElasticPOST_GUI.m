function varargout = ElasticPOST_GUI(varargin)
% ELASTICPOST_GUI MATLAB code for ElasticPOST_GUI.fig
%      ELASTICPOST_GUI, by itself, creates a new ELASTICPOST_GUI or raises the existing
%      singleton*.
%
%      H = ELASTICPOST_GUI returns the handle to a new ELASTICPOST_GUI or the handle to
%      the existing singleton*.
%
%      ELASTICPOST_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ELASTICPOST_GUI.M with the given input arguments.
%
%      ELASTICPOST_GUI('Property','Value',...) creates a new ELASTICPOST_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ElasticPOST_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ElasticPOST_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ElasticPOST_GUI

% Last Modified by GUIDE v2.5 28-Feb-2019 17:12:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ElasticPOST_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @ElasticPOST_GUI_OutputFcn, ...
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


% --- Executes just before ElasticPOST_GUI is made visible.
function ElasticPOST_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ElasticPOST_GUI (see VARARGIN)

% Choose default command line output for ElasticPOST_GUI
handles.output = hObject;

% InitialData = load('InitialData.mat');
% handles.InitialData = InitialData;
% % handles.DataFile = '';
% handles.n_Cij = 1;
% handles.NO = 1;
% handles.CIJ = handles.InitialData.Initial3D(1).Cij;
% handles.X = 0; handles.Y = 0; handles.Z = 0; handles.V = 0;
% handles.Slice = 0;
% 
% handles.SaveName = InitialData.SaveSetting.Name;
% handles.SavePath = InitialData.SaveSetting.Path;
% handles.SaveExt = InitialData.SaveSetting.Ext;
% handles.SaveResolution = InitialData.SaveSetting.Resolution;
% handles.PlotTitle = InitialData.PlotSetting.Title;
% handles.PlotTitleStr = InitialData.PlotSetting.TitleStr;
% handles.PlotColorMap = InitialData.PlotSetting.ColorMap;
% handles.PlotColorBar = InitialData.PlotSetting.ColorBar;
% handles.PlotAxes = InitialData.PlotSetting.Axes;
% handles.PlotView = InitialData.PlotSetting.View;
% handles.PlotTypeInit = InitialData.PlotSetting.PlotType;
% handles.PlotLegend = InitialData.PlotSetting.Legend;
% handles.PlotLegendStr = InitialData.PlotSetting.LegendStr;
% guidata(hObject, handles);
% clear InitialData
% % Set Icon
% warning('off', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
% newIcon = javax.swing.ImageIcon('Logo2.png');
% javaFrame = get(hObject, 'JavaFrame');
% javaFrame.setFigureIcon(newIcon);
% warning('on', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ElasticPOST_GUI wait for user response (see UIRESUME)
% uiwait(handles.ElasticPOST);


% --- Outputs from this function are returned to the command line.
function varargout = ElasticPOST_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in DataMode.
function DataMode_Callback(hObject, eventdata, handles)
% hObject    handle to DataMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[CIJ, ComName] = DataModeSelect(hObject, eventdata, handles);
MalType = get(handles.MType, 'Value');
PlotType = get(handles.Plot3D, 'Value');
if (MalType == 1) && (PlotType == 1)
    Plot3D_Callback(hObject, eventdata, handles);
else
    C_tmp = CIJ(:, :, 1);
    C_tmp = C_tmp(3:5, 3:5);
    if (sum(sum(abs(C_tmp))) ~= 0) && (MalType == 2)
        set(handles.MsgTxt, 'String', 'This is not a CIJ of 2D material',...
            'ForegroundColor', [1, 0, 0])
    end
    Plot2D_Callback(hObject, eventdata, handles);
end
% handles.DataFile = FileOut;
handles.NO = 1;
% Datamode = get(handles.DataMode, 'Value');
% if Datamode == 1
% handles.n_Cij = 1;
% end
handles.n_Cij = size(CIJ, 3);
handles.CIJ = CIJ;
handles.SaveName = ComName;
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns DataMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DataMode


% --- Executes during object creation, after setting all properties.
function DataMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CrystalType.
function CrystalType_Callback(hObject, eventdata, handles)
% hObject    handle to CrystalType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[CIJ, ComName] = Crytype(hObject, eventdata, handles);
MalType = get(handles.MType, 'Value');
PlotType = get(handles.Plot3D, 'Value');
if (MalType == 1) && (PlotType == 1)
    Plot3D_Callback(hObject, eventdata, handles);
else
    if MalType == 2
        Ctmp = CIJ(3:5, 3:5);
        if sum(sum(Ctmp)) ~= 0
            set(handles.MsgTxt, 'String', 'Note: This is not a CIJ of 2D materials', ...
                'ForegroundColor', [1, 0, 0]);
        end
    end
    Plot2D_Callback(hObject, eventdata, handles);
end
handles.NO = 1;
handles.n_Cij = size(CIJ, 3);
handles.CIJ = CIJ;
handles.SaveName = ComName;
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns CrystalType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CrystalType


% --- Executes during object creation, after setting all properties.
function CrystalType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CrystalType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CIJApply.
function handles = CIJApply_Callback(hObject, eventdata, handles)
% hObject    handle to CIJApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% CIJ = GetCIJ(handles);
handles.SliceOnOff = 0;
h_arrow = findobj(handles.Axes, 'Type', 'quiver');
MalType = get(handles.MType, 'Value');
% if MalType == 1
CIJ = handles.CIJ;
% else 
% %     CIJ = handles.InitialData.Initial2D
% end
n_Cij = size(CIJ, 3);
handles.n_Cij = n_Cij;
guidata(hObject, handles);
i_Cij = handles.NO;
Cij = CIJ(:, :, i_Cij);
flag_stable = StableofMechanical(Cij);
handles.stable = flag_stable;
SetCij(handles, Cij);
if ~flag_stable
    StabeStr = 'This structure is UNSTABLE.';
    set(handles.MsgTxt, 'String', StabeStr, 'ForegroundColor', [1, 0, 0]);
    guidata(hObject, handles);
    return
else
    set(handles.MsgTxt, 'String', 'OK', 'ForegroundColor', [0, 0, 0]);
    set(handles.InfoTxt, 'String', 'The Structure is STABLE');
end
if MalType == 1
    S = inv(Cij);
elseif MalType == 2
    C_tmp = D3toD2(Cij);
    S = inv(C_tmp);
    S = D2toD3(S);
end
n = str2double(get(handles.InterNum, 'String'));
% flag = {'G'};
flag = get(handles.Propertyi, 'String');
flag_value = get(handles.Propertyi, 'Value');
flagi = flag(flag_value);
flag_save = 0;
Name = 'Name';
%Plot, 2D or 3D
PlotType = get(handles.Plot3D, 'Value');
if PlotType
    amm_str = get(handles.Planei, 'String');
    amm_value = get(handles.Planei, 'Value');
    flag_amm = amm_str(amm_value);
    handles = ElasticPlot_3D_GUI(handles, S, n, flagi, flag_amm, flag_save, Name);
else
    if MalType == 1
        plane = get(handles.Planei, 'String');
        planei = get(handles.Planei, 'Value');
        flag_plane = plane(planei);
        handles = ElasticPlot_2D_GUI(handles, S, n, flagi, flag_plane, flag_save, Name);
    elseif MalType == 2
%         flag_plane = {'xy'};
%         ElasticPlot_2D_GUI(handles.Axes, S, n, flagi, flag_plane, flag_save, Name);
        handles = ElasticPlot_2DM_GUI(handles, S, n, flagi, flag_save, Name);
    end    
end

if ~isempty(h_arrow)
    AddAxes_Callback(hObject, eventdata, handles);
end
guidata(hObject, handles);

function c11_Callback(hObject, eventdata, handles)
% hObject    handle to c11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c11 as text
%        str2double(get(hObject,'String')) returns contents of c11 as a double


% --- Executes during object creation, after setting all properties.
function c11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c12_Callback(hObject, eventdata, handles)
% hObject    handle to c12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c12 as text
%        str2double(get(hObject,'String')) returns contents of c12 as a double


% --- Executes during object creation, after setting all properties.
function c12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c13_Callback(hObject, eventdata, handles)
% hObject    handle to c13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c13 as text
%        str2double(get(hObject,'String')) returns contents of c13 as a double


% --- Executes during object creation, after setting all properties.
function c13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c14_Callback(hObject, eventdata, handles)
% hObject    handle to c14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c14 as text
%        str2double(get(hObject,'String')) returns contents of c14 as a double


% --- Executes during object creation, after setting all properties.
function c14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c15_Callback(hObject, eventdata, handles)
% hObject    handle to c15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c15 as text
%        str2double(get(hObject,'String')) returns contents of c15 as a double

% --- Executes during object creation, after setting all properties.
function c15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c16_Callback(hObject, eventdata, handles)
% hObject    handle to c16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c16 as text
%        str2double(get(hObject,'String')) returns contents of c16 as a double


% --- Executes during object creation, after setting all properties.
function c16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c21_Callback(hObject, eventdata, handles)
% hObject    handle to c21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c21 as text
%        str2double(get(hObject,'String')) returns contents of c21 as a double


% --- Executes during object creation, after setting all properties.
function c21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c22_Callback(hObject, eventdata, handles)
% hObject    handle to c22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c22 as text
%        str2double(get(hObject,'String')) returns contents of c22 as a double


% --- Executes during object creation, after setting all properties.
function c22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c23_Callback(hObject, eventdata, handles)
% hObject    handle to c23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c23 as text
%        str2double(get(hObject,'String')) returns contents of c23 as a double


% --- Executes during object creation, after setting all properties.
function c23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c24_Callback(hObject, eventdata, handles)
% hObject    handle to c24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c24 as text
%        str2double(get(hObject,'String')) returns contents of c24 as a double


% --- Executes during object creation, after setting all properties.
function c24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c25_Callback(hObject, eventdata, handles)
% hObject    handle to c25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c25 as text
%        str2double(get(hObject,'String')) returns contents of c25 as a double


% --- Executes during object creation, after setting all properties.
function c25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c26_Callback(hObject, eventdata, handles)
% hObject    handle to c26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c26 as text
%        str2double(get(hObject,'String')) returns contents of c26 as a double


% --- Executes during object creation, after setting all properties.
function c26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c31_Callback(hObject, eventdata, handles)
% hObject    handle to c31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c31 as text
%        str2double(get(hObject,'String')) returns contents of c31 as a double


% --- Executes during object creation, after setting all properties.
function c31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c32_Callback(hObject, eventdata, handles)
% hObject    handle to c32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c32 as text
%        str2double(get(hObject,'String')) returns contents of c32 as a double


% --- Executes during object creation, after setting all properties.
function c32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c33_Callback(hObject, eventdata, handles)
% hObject    handle to c33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c33 as text
%        str2double(get(hObject,'String')) returns contents of c33 as a double


% --- Executes during object creation, after setting all properties.
function c33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c34_Callback(hObject, eventdata, handles)
% hObject    handle to c34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c34 as text
%        str2double(get(hObject,'String')) returns contents of c34 as a double


% --- Executes during object creation, after setting all properties.
function c34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c35_Callback(hObject, eventdata, handles)
% hObject    handle to c35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c35 as text
%        str2double(get(hObject,'String')) returns contents of c35 as a double


% --- Executes during object creation, after setting all properties.
function c35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c36_Callback(hObject, eventdata, handles)
% hObject    handle to c36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c36 as text
%        str2double(get(hObject,'String')) returns contents of c36 as a double


% --- Executes during object creation, after setting all properties.
function c36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c41_Callback(hObject, eventdata, handles)
% hObject    handle to c41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c41 as text
%        str2double(get(hObject,'String')) returns contents of c41 as a double


% --- Executes during object creation, after setting all properties.
function c41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c42_Callback(hObject, eventdata, handles)
% hObject    handle to c42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c42 as text
%        str2double(get(hObject,'String')) returns contents of c42 as a double


% --- Executes during object creation, after setting all properties.
function c42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c43_Callback(hObject, eventdata, handles)
% hObject    handle to c43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c43 as text
%        str2double(get(hObject,'String')) returns contents of c43 as a double


% --- Executes during object creation, after setting all properties.
function c43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c44_Callback(hObject, eventdata, handles)
% hObject    handle to c44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c44 as text
%        str2double(get(hObject,'String')) returns contents of c44 as a double


% --- Executes during object creation, after setting all properties.
function c44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c45_Callback(hObject, eventdata, handles)
% hObject    handle to c45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c45 as text
%        str2double(get(hObject,'String')) returns contents of c45 as a double


% --- Executes during object creation, after setting all properties.
function c45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c46_Callback(hObject, eventdata, handles)
% hObject    handle to c46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c46 as text
%        str2double(get(hObject,'String')) returns contents of c46 as a double


% --- Executes during object creation, after setting all properties.
function c46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c51_Callback(hObject, eventdata, handles)
% hObject    handle to c51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c51 as text
%        str2double(get(hObject,'String')) returns contents of c51 as a double


% --- Executes during object creation, after setting all properties.
function c51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c52_Callback(hObject, eventdata, handles)
% hObject    handle to c52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c52 as text
%        str2double(get(hObject,'String')) returns contents of c52 as a double


% --- Executes during object creation, after setting all properties.
function c52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c53_Callback(hObject, eventdata, handles)
% hObject    handle to c53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c53 as text
%        str2double(get(hObject,'String')) returns contents of c53 as a double


% --- Executes during object creation, after setting all properties.
function c53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c54_Callback(hObject, eventdata, handles)
% hObject    handle to c54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c54 as text
%        str2double(get(hObject,'String')) returns contents of c54 as a double


% --- Executes during object creation, after setting all properties.
function c54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c55_Callback(hObject, eventdata, handles)
% hObject    handle to c55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c55 as text
%        str2double(get(hObject,'String')) returns contents of c55 as a double


% --- Executes during object creation, after setting all properties.
function c55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c56_Callback(hObject, eventdata, handles)
% hObject    handle to c56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c56 as text
%        str2double(get(hObject,'String')) returns contents of c56 as a double


% --- Executes during object creation, after setting all properties.
function c56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c61_Callback(hObject, eventdata, handles)
% hObject    handle to c61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c61 as text
%        str2double(get(hObject,'String')) returns contents of c61 as a double


% --- Executes during object creation, after setting all properties.
function c61_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c62_Callback(hObject, eventdata, handles)
% hObject    handle to c62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c62 as text
%        str2double(get(hObject,'String')) returns contents of c62 as a double


% --- Executes during object creation, after setting all properties.
function c62_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c63_Callback(hObject, eventdata, handles)
% hObject    handle to c63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c63 as text
%        str2double(get(hObject,'String')) returns contents of c63 as a double


% --- Executes during object creation, after setting all properties.
function c63_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c64_Callback(hObject, eventdata, handles)
% hObject    handle to c64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c64 as text
%        str2double(get(hObject,'String')) returns contents of c64 as a double


% --- Executes during object creation, after setting all properties.
function c64_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c65_Callback(hObject, eventdata, handles)
% hObject    handle to c65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c65 as text
%        str2double(get(hObject,'String')) returns contents of c65 as a double


% --- Executes during object creation, after setting all properties.
function c65_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c66_Callback(hObject, eventdata, handles)
% hObject    handle to c66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetOtherCij(handles, get(hObject, 'tag'));
CIJ = GetCij(handles);
handles.CIJ = CIJ;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of c66 as text
%        str2double(get(hObject,'String')) returns contents of c66 as a double


% --- Executes during object creation, after setting all properties.
function c66_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function File_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Elastic_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Elastic_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Hardness_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Hardness_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function InputGen_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to InputGen_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Help_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Manual_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Manual_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Tutorial_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Tutorial_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function About_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to About_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CASTEP_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to CASTEP_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function VASP_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to VASP_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function QE_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to QE_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function BE_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to BE_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function BG_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to BG_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function GE_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to GE_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Poly_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Poly_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Aniotropy_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Aniotropy_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Open_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Close_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Close_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Exit_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Exit_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function ElasticPOST_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ElasticPOST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

InitialData = load('InitialData.mat');
handles.InitialData = InitialData;
% handles.DataFile = '';
handles.n_Cij = 1;
handles.NO = 1;
handles.CIJ = handles.InitialData.Initial3D(1).Cij;
handles.stable = 1;
handles.SaveSingleV = 1;
handles.X = 0; handles.Y = 0; handles.Z = 0; handles.V = 0;
handles.SliceOnOff = 0;

handles.SaveName = InitialData.SaveSetting.Name;
handles.SavePath = InitialData.SaveSetting.Path;
handles.SaveDataPath = InitialData.SaveSetting.DataPath;
handles.SaveExt = InitialData.SaveSetting.Ext;
handles.SaveDataExt = InitialData.SaveSetting.DataExt;
handles.SaveResolution = InitialData.SaveSetting.Resolution;
handles.SaveData3D = InitialData.SaveSetting.SaveData3D;
handles.SaveDataToWS = InitialData.SaveSetting.SaveDataToWS;

% handles.stable = InitialData.SaveSetting.stable;
handles.PlotTitle = InitialData.PlotSetting.Title;
handles.PlotTitleStr = InitialData.PlotSetting.TitleStr;
handles.PlotColorMap = InitialData.PlotSetting.ColorMap;
handles.PlotColorBar = InitialData.PlotSetting.ColorBar;
handles.PlotColarBarSet = InitialData.PlotSetting.ColorBarSet;
handles.PlotColarBarMode = InitialData.PlotSetting.ColorBarMode;
handles.PlotColarBarCmin = InitialData.PlotSetting.ColorBarCmin;
handles.PlotColarBarCmax = InitialData.PlotSetting.ColorBarCmax;
handles.PlotAxes = InitialData.PlotSetting.Axes;
handles.PlotView = InitialData.PlotSetting.View;
handles.PlotTypeInit = InitialData.PlotSetting.PlotType;
handles.PlotLegend = InitialData.PlotSetting.Legend;
handles.PlotLegendStr = InitialData.PlotSetting.LegendStr;
handles.PlotNumPoint = InitialData.PlotSetting.n;
guidata(hObject, handles);
clear InitialData
% Set Icon
warning('off', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
newIcon = javax.swing.ImageIcon('Logo2.png');
javaFrame = get(hObject, 'JavaFrame');
javaFrame.setFigureIcon(newIcon);
warning('on', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');



function NameInfo_Callback(hObject, eventdata, handles)
% hObject    handle to NameInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ComName = {get(hObject, 'String')};
handles.SaveName = ComName;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of NameInfo as text
%        str2double(get(hObject,'String')) returns contents of NameInfo as a double


% --- Executes during object creation, after setting all properties.
function NameInfo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NameInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Propertyi.
function Propertyi_Callback(hObject, eventdata, handles)
% hObject    handle to Propertyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Propertyi = get(handles.Propertyi, 'Value');
PlotType = get(handles.Plot3D, 'Value');     %3D or 2D
if PlotType
    if (Propertyi == 1) || (Propertyi == 2) || (Propertyi == 5)
        PlaneStr = {'Unused'};
        set(handles.Planei, 'Enable', 'off');
    else
        PlaneStr = {'Ave', 'Min', 'Max', 'All'};
        set(handles.Planei, 'Enable', 'on');
    end
else
    PlaneStr = {'xy', 'xz', 'yz'};
end
set(handles.Planei, 'String', PlaneStr);
set(handles.Planei, 'Value', 1);
% Hints: contents = cellstr(get(hObject,'String')) returns Propertyi contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Propertyi


% --- Executes during object creation, after setting all properties.
function Propertyi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Propertyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AddAxes.
function AddAxes_Callback(hObject, eventdata, handles)
% hObject    handle to AddAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
L_Arrow = 1.5;
ArrowSize = 0.25;
LineSize = 2.3;
Offset_ArrowTxt = 0.05;
FontSize = 15;
Pos_ArrowTxt = L_Arrow + Offset_ArrowTxt;
PlotType = get(handles.Plot3D, 'Value');
h_arrow = findobj(handles.Axes, 'Type', 'quiver');
if isempty(h_arrow)
    if PlotType == 1
        hold on
        x_max = max(get(handles.Axes, 'XLim'));
        y_max = max(get(handles.Axes, 'YLim'));
        z_max = max(get(handles.Axes, 'ZLim'));
        Ax = quiver3(handles.Axes, 0, 0, 0, L_Arrow*x_max, 0, 0, 1, 'k',...
            'LineWidth', LineSize, 'MaxHeadSize', ArrowSize);
        Ay = quiver3(handles.Axes, 0, 0, 0, 0, L_Arrow*y_max, 0, 1, 'k',...
            'LineWidth', LineSize, 'MaxHeadSize', ArrowSize);
        Az = quiver3(handles.Axes, 0, 0, 0, 0, 0, L_Arrow*z_max, 1, 'k',...
            'LineWidth', LineSize, 'MaxHeadSize', ArrowSize);
        Txt_Ax = text(handles.Axes, Pos_ArrowTxt*x_max, 0, 0, '[100]', 'HorizontalAlignment',...
            'right', 'FontSize', FontSize);
        Txt_Ay = text(handles.Axes, 0, Pos_ArrowTxt*y_max, 0, '[010]', 'FontSize', FontSize);
        Txt_Az = text(handles.Axes, 0, 0, (Pos_ArrowTxt+0.15)*z_max, '[001]', ...
            'HorizontalAlignment', 'center', 'FontSize', FontSize);
        hold off
    else
        PlaneStr = get(handles.Planei, 'String');
        PlaneValue = get(handles.Planei, 'Value');
        PlaneFlag = cell2mat(PlaneStr(PlaneValue));
        MalType = get(handles.MType, 'Value');
        if MalType == 2  %2D material
            AxesStr = '[100]';
        elseif strcmp(PlaneFlag, 'xy')
            AxesStr = '[100]';
        elseif strcmp(PlaneFlag, 'xz')
            AxesStr = '[001]';
        elseif strcmp(PlaneFlag, 'yz')
            AxesStr = '[001]';
        end
        hold on
        x_max = max(get(handles.Axes, 'XLim'));
        y_max = max(get(handles.Axes, 'YLim'));
        Ax = quiver(handles.Axes, 0, 0, 1.2*x_max, 0, 'k', 'LineWidth', 2, 'MaxHeadSize', 0.2);
        Txt_Ax = text(handles.Axes, 1.1*x_max, -0.07*y_max, AxesStr, 'HorizontalAlignment',...
            'right', 'FontSize', FontSize);
        Txt_Ay = ''; Txt_Az= '';
        Ay = ''; Az = '';
        hold off
    end
    handles.Ax = Ax; handles.Ay = Ay; handles.Az = Az;
    handles.Txt_Ax = Txt_Ax; handles.Txt_Ay = Txt_Ay; handles.Txt_Az = Txt_Az;
    guidata(hObject, handles);
%     LegendSetting_Callback(hObject, eventdata, handles)
%     LegendSetting_Callback(hObject, eventdata, handles)
    LegendOn = handles.PlotLegend;
    PlotType = get(handles.Plot3D, 'Value');
    if strcmp(LegendOn, 'on') && (PlotType == 0)
        LegendStr = handles.PlotLegendStr;
        legend(LegendStr, 'Interpreter', 'LaTex');
    else
        legend('off');
    end
%     legend(Ax, 'visibilityOption', 'hide')
else
%     delete(handles.Ax); delete(handles.Ay); delete(handles.Az);
%     delete(handles.Txt_Ax); delete(handles.Txt_Ay); delete(handles.Txt_Az);
    delete(h_arrow);
%     delete(handles.Txt_Ax); delete(handles.Txt_Ay); delete(handles.Txt_Az);
    h_text = findobj(handles.Axes, 'String', '[100]', '-or', 'String', '[001]', '-or', 'String', '[010]');
    delete(h_text);
end




% --- Executes on button press in Next.
function handles = Next_Callback(hObject, eventdata, handles)
% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NO = handles.NO;
n_Cij = handles.n_Cij;
if NO == n_Cij
    handles.NO = 1;
else
    handles.NO = NO + 1;
end
handles = CIJApply_Callback(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes on button press in Previous.
function Previous_Callback(hObject, eventdata, handles)
% hObject    handle to Previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NO = handles.NO;
n_Cij = handles.n_Cij;
if NO == 1
    handles.NO = n_Cij;
else
    handles.NO = NO - 1;
end
guidata(hObject, handles);
CIJApply_Callback(hObject, eventdata, handles);


% --- Executes on selection change in MType.
function MType_Callback(hObject, eventdata, handles)
% hObject    handle to MType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.DataMode, 'Value', 1);
set(handles.CrystalType, 'Value', 1);
% CIJ = DataModeSelect(hObject, eventdata, handles);

MalType = get(handles.MType, 'Value');
switch MalType
    case 1
        set(handles.Plot3D, 'Enable', 'on');
        set(handles.Plot3D, 'Value', 1);
        Plot3D_Callback(hObject, eventdata, handles);
%         set(handles.Planei, 'Enable', 'off');
%         set(handles.Planei, 'Value', 1);
    case 2
        set(handles.Plot3D, 'Value', 0);
        set(handles.Plot3D, 'Enable', 'off');
        set(handles.Plot2D, 'Value', 1);
%         set(handles.Planei, 'Enable', 'on');
        Plot2D_Callback(hObject, eventdata, handles);
end
[CIJ, ComName] = DataModeSelect(hObject, eventdata, handles);
handles.CIJ = CIJ;
handles.SaveName = ComName;
handles.NO = 1;
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns MType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MType


% --- Executes during object creation, after setting all properties.
function MType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Planei.
function Planei_Callback(hObject, eventdata, handles)
% hObject    handle to Planei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Planei contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Planei


% --- Executes during object creation, after setting all properties.
function Planei_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Planei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Plot3D.
function Plot3D_Callback(hObject, eventdata, handles)
% hObject    handle to Plot3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Propertyi = get(handles.Propertyi, 'Value');
CIJ = GetCij(handles);
handles.Cij = CIJ;
CijNotZero = sum(sum(abs(CIJ)));
if (Propertyi == 1) || (Propertyi == 2)
    PlaneStr = {'Unused'};
    set(handles.Planei, 'Enable', 'off');
else
    PlaneStr = {'Ave', 'Min', 'Max', 'All'};
    if CijNotZero
        set(handles.Planei, 'Enable', 'on');
    else
        set(handles.Planei, 'Enable', 'off');
    end
end
set(handles.Planei, 'String', PlaneStr);
set(handles.Planei, 'Value', 1);
set(handles.Propertyi, 'String', {'B', 'E', 'G', 'v', 'H'});
PlotType = get(handles.Plot3D, 'Value');
if PlotType == 1
    set(handles.LegendSetting, 'Enable', 'off');
    set(handles.ColorbarSetting, 'Enable', 'on');
    set(handles.ColorSetting, 'Enable', 'on');
    set(handles.ViewHigh, 'Enable', 'on');
    set(handles.ViewLow, 'Enable', 'on');
    set(handles.AnyViewDir, 'Enable', 'on');
    set(handles.AnyDirection, 'Enable', 'on');
    set(handles.ApplyDirection, 'Enable', 'on');
    set(handles.V1, 'Enable', 'on');
    set(handles.V2, 'Enable', 'on');
    set(handles.SlicePB, 'Enable', 'on');
    set(handles.HLPoint, 'Enable', 'on');
    set(handles.SliceHL, 'Enable', 'on');
else
    set(handles.LegendSetting, 'Enable', 'on');
    set(handles.ColorbarSetting, 'Enable', 'off');
    set(handles.ColorSetting, 'Enable', 'off');
    set(handles.ViewHigh, 'Enable', 'off');
    set(handles.ViewLow, 'Enable', 'off');
    set(handles.AnyViewDir, 'Enable', 'off');
    set(handles.AnyDirection, 'Enable', 'off');
    set(handles.ApplyDirection, 'Enable', 'off');
    set(handles.V1, 'Enable', 'off');
    set(handles.V2, 'Enable', 'off');
    set(handles.SlicePB, 'Enable', 'off');
    set(handles.HLPoint, 'Enable', 'off');
    set(handles.SliceHL, 'Enable', 'off');
end
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of Plot3D


% --- Executes on button press in Plot2D.
function Plot2D_Callback(hObject, eventdata, handles)
% hObject    handle to Plot2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Plot2D, 'Value', 1);
MalType = get(handles.MType, 'Value');
CIJ = GetCij(handles);
handles.Cij = CIJ;
CijNotZero = sum(sum(abs(CIJ)));
if MalType == 1     %3D material
    %     set(handles.CrystalType, 'Value', 1);
    PlaneStr = {'xy', 'xz', 'yz'};
    set(handles.Planei, 'String', PlaneStr);
    if CijNotZero
        set(handles.Planei, 'Enable', 'on');
    else
        set(handles.Planei, 'Enable', 'off');
    end
    set(handles.Propertyi, 'String', {'B', 'E', 'G', 'v', 'H'});
else     %2D materials
    PlaneStr = {'Unused'};
    set(handles.Propertyi, 'String', {'E', 'G', 'v'});
    set(handles.Planei, 'String', PlaneStr);
    set(handles.Planei, 'Enable', 'off');
end
set(handles.Planei, 'Value', 1);
set(handles.Propertyi, 'Value', 1);
PlotType = get(handles.Plot3D, 'Value');
if PlotType == 1
    set(handles.LegendSetting, 'Enable', 'off');
    set(handles.ColorbarSetting, 'Enable', 'on');
    set(handles.ColorSetting, 'Enable', 'on');
    set(handles.ViewHigh, 'Enable', 'on');
    set(handles.ViewLow, 'Enable', 'on');
    set(handles.AnyViewDir, 'Enable', 'on');
    set(handles.AnyDirection, 'Enable', 'on');
    set(handles.ApplyDirection, 'Enable', 'on');
    set(handles.V1, 'Enable', 'on');
    set(handles.V2, 'Enable', 'on');
    set(handles.SlicePB, 'Enable', 'on');
    set(handles.HLPoint, 'Enable', 'on');
    set(handles.SliceHL, 'Enable', 'on');
else
    set(handles.LegendSetting, 'Enable', 'on');
    set(handles.ColorbarSetting, 'Enable', 'off');
    set(handles.ColorSetting, 'Enable', 'off');
    set(handles.ViewHigh, 'Enable', 'off');
    set(handles.ViewLow, 'Enable', 'off');
    set(handles.AnyViewDir, 'Enable', 'off');
    set(handles.AnyDirection, 'Enable', 'off');
    set(handles.ApplyDirection, 'Enable', 'off');
    set(handles.V1, 'Enable', 'off');
    set(handles.V2, 'Enable', 'off');
    set(handles.SlicePB, 'Enable', 'off');
    set(handles.HLPoint, 'Enable', 'off');
    set(handles.SliceHL, 'Enable', 'off');
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of Plot2D


% --- Executes during object creation, after setting all properties.
function Axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% axis(handles.Axes, 'off')
% Hint: place code in OpeningFcn to populate Axes


% --- Executes on button press in View100.
function View100_Callback(hObject, eventdata, handles)
% hObject    handle to View100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ViewAnyDir(handles, [1, 0, 0]);
guidata(hObject, handles);


% --- Executes on button press in View010.
function View010_Callback(hObject, eventdata, handles)
% hObject    handle to View010 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ViewAnyDir(handles, [0, 1, 0]);
guidata(hObject, handles);


% --- Executes on button press in View001.
function View001_Callback(hObject, eventdata, handles)
% hObject    handle to View001 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ViewAnyDir(handles, [0, 0, 1]);
guidata(hObject, handles);


% --- Executes on button press in View111.
function View111_Callback(hObject, eventdata, handles)
% hObject    handle to View111 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ViewAnyDir(handles, [1, 1, 1]);
guidata(hObject, handles);


% --- Executes on button press in View_111.
function View_111_Callback(hObject, eventdata, handles)
% hObject    handle to View_111 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ViewAnyDir(handles, [-1, 1, 1]);
guidata(hObject, handles);


% --- Executes on button press in View1_11.
function View1_11_Callback(hObject, eventdata, handles)
% hObject    handle to View1_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ViewAnyDir(handles, [1, -1, 1]);
guidata(hObject, handles);


% --- Executes on button press in View11_1.
function View11_1_Callback(hObject, eventdata, handles)
% hObject    handle to View11_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ViewAnyDir(handles, [1, 1, -1]);
guidata(hObject, handles);


% --- Executes on button press in View011.
function View011_Callback(hObject, eventdata, handles)
% hObject    handle to View011 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ViewAnyDir(handles, [0, 1, 1]);
guidata(hObject, handles);


% --- Executes on button press in View101.
function View101_Callback(hObject, eventdata, handles)
% hObject    handle to View101 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ViewAnyDir(handles, [1, 0, 1]);
guidata(hObject, handles);


% --- Executes on button press in View110.
function View110_Callback(hObject, eventdata, handles)
% hObject    handle to View110 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ViewAnyDir(handles, [1, 1, 0]);
guidata(hObject, handles);



function AnyDirection_Callback(hObject, eventdata, handles)
% hObject    handle to AnyDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnyDirection as text
%        str2double(get(hObject,'String')) returns contents of AnyDirection as a double


% --- Executes during object creation, after setting all properties.
function AnyDirection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnyDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ApplyDirection.
function ApplyDirection_Callback(hObject, eventdata, handles)
% hObject    handle to ApplyDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
direction = get(handles.AnyDirection, 'String');
direction = strsplit(direction, {' ', ',', ';'});
n_direction = length(direction);
if n_direction ~= 3
    set(handles.MsgTxt, 'String', 'It not a effective crystal direction.', ...
        'ForegroundColor', [1, 0, 0]);
    return
else
    set(handles.MsgTxt, 'String', 'OK', 'ForegroundColor', [0, 0, 0]);
end
ViewDir = zeros(1, 3);
for i = 1:n_direction
    ViewDir(i) = str2double(cell2mat(direction(i))); 
end
handles = ViewAnyDir(handles, ViewDir);
handles.PlotView = ViewDir;
guidata(hObject, handles);


% --- Executes on button press in ViewHigh.
function ViewHigh_Callback(hObject, eventdata, handles)
% hObject    handle to ViewHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
V = handles.V;
% n_V = size(V, 3);
% for i = 1:n_V
Vtmp = V(:, :, 1);
[max_col, index_row] = max(abs(Vtmp));
[max_max, index_col] = max(max_col);
% end
row_index = index_row(index_col);
X = handles.X;
Y = handles.Y;
Z = handles.Z;
x = X(row_index, index_col);
y = Y(row_index, index_col);
z = Z(row_index, index_col, 1);
handles = ViewAnyDir(handles, [x, y, z]);
handles.PlotView = [x, y, z];
set(handles.InfoTxt, 'String', ['max=', num2str(max_max), ' at x=', ...
    num2str(x), ', y=', num2str(y), ', z=', num2str(z), '.']);
guidata(hObject, handles);

% --- Executes on button press in ViewLow.
function ViewLow_Callback(hObject, eventdata, handles)
% hObject    handle to ViewLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
V = handles.V;
% n_V = size(V, 3);
% for i = 1:n_V
Vtmp = V(:, :, 1);
[min_col, index_row] = min(abs(Vtmp));
[min_min, index_col] = min(min_col);
% end
row_index = index_row(index_col);
X = handles.X;
Y = handles.Y;
Z = handles.Z;
x = X(row_index, index_col);
y = Y(row_index, index_col);
z = Z(row_index, index_col, 1);
handles = ViewAnyDir(handles, [x, y, z]);
handles.PlotView = [x, y, z];
set(handles.InfoTxt, 'String', ['min=', num2str(min_min), ' at x=', ...
    num2str(x), ', y=', num2str(y), ', z=', num2str(z), '.']);
guidata(hObject, handles);


% --- Executes on button press in SaveSingle.
function SaveSingle_Callback(hObject, eventdata, handles)
% hObject    handle to SaveSingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% SaveSingle = handles.SaveSingleV;
SaveSingle = get(handles.SaveSingle, 'Value');
stable = handles.stable;
if stable == 0
    return
end
SliceOn = handles.SliceOnOff;
NO = handles.NO;
SaveName = handles.SaveName;
NameTmp = cell2mat(SaveName(NO));
Name1 = GetName(handles);
Resolution = handles.SaveResolution;
SavePath = handles.SavePath;
if ~exist(SavePath, 'dir')
    mkdir(SavePath);
end

% save data
PropString = get(handles.Propertyi, 'String');
PropValue = get(handles.Propertyi, 'Value');
Flag_M = get(handles.MType, 'Value');
Propi = PropString(PropValue);
V = handles.V;
X = handles.X;
Y = handles.Y;
if Flag_M == 1
    DataHead = {'Name', 'Property', 'Max', 'Max_x', 'Max_y', ...
        'Max_z', 'Min', 'Min_x', 'Min_y', 'Min_z'};
    Z = handles.Z;
    [VMax, VMin] = GetMaxMin(V, X, Y, Z, Flag_M);
else
    DataHead = {'Name', 'Property', 'Max', 'Max_x', 'Max_y', 'Min', 'Min_x', 'Min_y'};
    Z = 0;
    [VMax, VMin] = GetMaxMin(V, X, Y, Z, Flag_M);
end
% VMax = num2cell(VMax);
% VMin = num2cell(VMin);
FigureData = [SaveName(NO), Propi, VMax, VMin];
set(handles.MsgTxt, 'String', 'Saving the data...');
if SaveSingle
    SaveDataName = [SavePath, Name1, 'Result.txt'];
    FigureDataOut = [DataHead; FigureData];
    fileID = fopen(SaveDataName, 'w'); 
    for i = 1:size(FigureDataOut, 1)
        for j = 1:size(FigureDataOut, 2)
            fprintf(fileID, '%s', FigureDataOut{i, j}); 
            fprintf(fileID, '\t');
        end
        fprintf(fileID, '\n');
    end
    fclose(fileID);
else
    SaveDataName = [SavePath, Name1, 'BatchResult.txt'];
    fileID = fopen(SaveDataName, 'a'); 
    for i = 1:length(FigureData)
            fprintf(fileID, '%s', FigureData{i}); 
            fprintf(fileID, '\t');
    end
    fprintf(fileID, '\n');
    fclose(fileID);
end
%save figure
set(handles.MsgTxt, 'String', 'Saving the figure...');
SaveTypeStr = get(handles.SaveType, 'String');
SaveTypeValue = get(handles.SaveType, 'Value');
SaveType = cell2mat(SaveTypeStr(SaveTypeValue));
switch SaveType
    case 'tif'
        FormatType = '-dtiff';
        Ext = '.tif';
    case 'jpg'
        FormatType = '-djpeg';
        Ext = '.jpg';
    case 'eps'
        FormatType = '-depsc';
        Ext = '.eps';
    case 'fig'
        Ext = '.fig';
    case 'pdf'
        FormatType = '-dpdf';
        Ext = '.pdf';
    case 'emf'
        FormatType = '-dmeta';
        Ext = '.emf';
end
if SliceOn
    FullName = [SavePath, Name1, NameTmp, '-slice', Ext];
else
    FullName = [SavePath, Name1, NameTmp, Ext];
end

hFigure = figure('Visible', 'off');
hAxes = copyobj(handles.Axes, hFigure);
set(hAxes, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.8]);

LegendOn = handles.PlotLegend;
PlotType = get(handles.Plot3D, 'Value');
if strcmp(LegendOn, 'on') && (PlotType == 0)
    LegendStr = handles.PlotLegendStr;
    legend(hAxes, LegendStr, 'Interpreter', 'latex', 'Location', 'best');
    legend('boxoff');
end

% if SliceOn
%     text('textbox',[0 0 0.3 0.3],'String','test','FitBoxToText','on');
% end
ColorBarOn = handles.PlotColorBar;
if strcmp(ColorBarOn, 'on') && (PlotType == 1) && ~SliceOn
    colorbar(hAxes, 'Location','eastoutside')
end
% colorbar(gca, 'AxisLocation','out');
if strcmp(SaveType, 'fig')
    saveas(hFigure, FullName);
elseif strcmp(SaveType, 'eps')
    print(hFigure, FormatType, FullName);
else
    print(hFigure, FormatType, ['-r', Resolution], FullName);
end
% delete(gca);
% delete(hFigure);
close(hFigure);
set(handles.MsgTxt, 'String', 'Figure saved.');


% --- Executes on button press in BatchSave.
function BatchSave_Callback(hObject, eventdata, handles)
% hObject    handle to BatchSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% NO = handles.NO;
handles.SaveSingleV = 0;
NO = handles.NO;
n_Cij = handles.n_Cij;

Flag_M = get(handles.MType, 'Value');
Name1 = GetName(handles);
SavePath = handles.SavePath;
SaveDataName = [SavePath, Name1, 'BatchResult.txt'];
if Flag_M == 1
    DataHead = {'Name', 'Property', 'Max', 'Max_x', 'Max_y', ...
        'Max_z', 'Min', 'Min_x', 'Min_y', 'Min_z'};
else
    DataHead = {'Name', 'Property', 'Max', 'Max_x', 'Max_y', 'Min', 'Min_x', 'Min_y'};
end
fileID = fopen(SaveDataName, 'a');
for i = 1:length(DataHead)
    fprintf(fileID, '%s', DataHead{i});
    fprintf(fileID, '\t');
end
fprintf(fileID, '\n');
fclose(fileID);

for i = 1:n_Cij
    handles = Next_Callback(handles.Next, eventdata, handles);
    guidata(hObject, handles);
    SaveSingle_Callback(hObject, eventdata, handles);
%     if NO == n_Cij
%         handles.NO = 1;
%     else
%         handles.NO = NO + 1;
%     end
%     guidata(hObject, handles);
%     CIJApply_Callback(hObject, eventdata, handles);
end
set(handles.MsgTxt, 'String', 'Batch saving finished.');


% --- Executes on selection change in SaveType.
function SaveType_Callback(hObject, eventdata, handles)
% hObject    handle to SaveType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SaveType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SaveType


% --- Executes during object creation, after setting all properties.
function SaveType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SaveType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObjVal = handles.SaveExt;
set(hObject, 'Value', hObjVal);
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ResolutionValue_Callback(hObject, eventdata, handles)
% hObject    handle to ResolutionValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Resolution = get(hObject, 'String');
handles.SaveResolution = Resolution;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of ResolutionValue as text
%        str2double(get(hObject,'String')) returns contents of ResolutionValue as a double


% --- Executes during object creation, after setting all properties.
function ResolutionValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResolutionValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObjStr = handles.SaveResolution;
set(hObject, 'String', hObjStr);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SetDefaultPath.
function SetDefaultPath_Callback(hObject, eventdata, handles)
% hObject    handle to SetDefaultPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CurDir = handles.SavePath;
DirName = uigetdir(CurDir);
if DirName == 0
else
    handles.SavePath = [DirName, '\'];
    guidata(hObject, handles);
end


% --- Executes on button press in SliceHL.
function SliceHL_Callback(hObject, eventdata, handles)
% hObject    handle to SliceHL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SliceOnOff = 1;
V = handles.V;
% n_V = size(V, 3);
% for i = 1:n_V
Vtmp = V(:, :, 1);
[max_col, index_maxrow] = max(abs(Vtmp));
[max_max, index_maxcol] = max(max_col);
[min_col, index_minrow] = min(abs(Vtmp));
[min_min, index_mincol] = min(min_col);
% end
row_maxindex = index_maxrow(index_maxcol);
row_minindex = index_minrow(index_mincol);
X = handles.X;
Y = handles.Y;
Z = handles.Z;
x_max = X(row_maxindex, index_maxcol);
y_max = Y(row_maxindex, index_maxcol);
z_max = Z(row_maxindex, index_maxcol, 1);
x_min = X(row_minindex, index_mincol);
y_min = Y(row_minindex, index_mincol);
z_min = Z(row_minindex, index_mincol, 1);
% r_min = x_min^2+y_min^2 + z_min^2
x_slice = y_min*z_max - z_min*y_max;
y_slice = z_min*x_max - x_min*z_max;
z_slice = x_min*y_max - y_min*x_max;
slice_plane = [x_slice, y_slice, z_slice];

flag = get(handles.Propertyi, 'String');
flag_value = get(handles.Propertyi, 'Value');
flagi = flag(flag_value);
n = str2double(get(handles.InterNum, 'String'));

CIJ = handles.CIJ;
NO = handles.NO;
Cij = CIJ(:, :, NO);
S = inv(Cij);
handles = Plot_Slice_GUI(handles, S, n, flagi, slice_plane, 0, 'name');
ShowPoint = get(handles.HLPoint, 'Value');
n_vpa = 2;
if ShowPoint
    hold on
    c_m = 1;
    scatter3(handles.Axes, min_min*x_min, min_min*y_min, min_min*z_min, ...
        40, 'go', 'LineWidth', 1);
    text(handles.Axes, c_m*min_min*x_min, c_m*min_min*y_min, c_m*min_min*z_min,...
        '\leftarrow Min', 'Color', 'g', 'FontSize', 10);
    scatter3(handles.Axes, max_max*x_max, max_max*y_max, max_max*z_max, ...
        40, 'bo', 'LineWidth', 1);
    text(handles.Axes, c_m*max_max*x_max, c_m*max_max*y_max, c_m*max_max*z_max, ...
        '\leftarrow Max', 'Color', 'b', 'FontSize', 10);
%     annotation('textarrow', max_max*x_max, max_max*y_max, max_max*z_max, 'String', 'Max');
    hold off
end

TipString = ['Min=', num2str(roundn(min_min, -1)), ' at [' ...
    num2str(roundn(x_min, -n_vpa)), ' ', num2str(roundn(y_min, -n_vpa)), ...
    ' ', num2str(roundn(z_min, -n_vpa)), ']', ...
    ' Max=', num2str(roundn(max_max, -1)), ' at [', ...
    num2str(roundn(x_max, -n_vpa)), ' ', num2str(roundn(y_max, -n_vpa)), ...
    ' ', num2str(roundn(z_max, -n_vpa)), ']'];
set(handles.InfoTxt, 'String', TipString);

% annotation(handles.Axes, 'textbox',[0.2 0.5 0.3 0.3],'String',TipString,'FitBoxToText','on');

% Fig_legend = handles.PlotLegendStr;
% legend(handles.Axes, Fig_legend, 'Interpreter', 'LaTex', 'Location', 'best');
% legend('boxoff');
handles.SlicePlane = slice_plane;
guidata(hObject, handles);



% --- Executes on button press in SlicePB.
function SlicePB_Callback(hObject, eventdata, handles)
% hObject    handle to SlicePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SliceOnOff = 1;
direction1 = get(handles.V1, 'String');
direction1 = strsplit(direction1, {' ', ',', ';'});
direction2 = get(handles.V2, 'String');
direction2 = strsplit(direction2, {' ', ',', ';'});
n_direction1 = length(direction1);
n_direction2 = length(direction2);
slice_dir1 = zeros(1, n_direction1);
slice_dir2 = zeros(1, n_direction2);
for i = 1:n_direction1
    slice_dir1(i) = str2double(cell2mat(direction1(i)));        
end
for i = 1:n_direction2
    slice_dir2(i) = str2double(cell2mat(direction2(i)));
end
if (n_direction1 ~= 3 && n_direction2 ~= 3) || ...
        (sum(isnan(slice_dir1)) && sum(isnan(slice_dir2)))
    set(handles.MsgTxt, 'String', 'It not a effective crystal direction.', ...
        'ForegroundColor', [1, 0, 0]);
    return
elseif n_direction1 == 3 && n_direction2 == 3 && ...
        ~sum(isnan(slice_dir1)) && ~sum(isnan(slice_dir2))
    set(handles.MsgTxt, 'String', 'OK', 'ForegroundColor', [0, 0, 0]);
    slice_plane = zeros(1, 3);
    slice_plane(1) = slice_dir1(2)*slice_dir2(3) - slice_dir1(3)*slice_dir2(2);
    slice_plane(2) = slice_dir1(3)*slice_dir2(1) - slice_dir1(1)*slice_dir2(3);
    slice_plane(3) = slice_dir1(1)*slice_dir2(2) - slice_dir1(2)*slice_dir2(1);
elseif n_direction1 == 3 && ~sum(isnan(slice_dir1))
    set(handles.MsgTxt, 'String', 'The Non-effective direction was neglected.',...
        'ForegroundColor', [0, 0, 0]);
    set(handles.V2, 'String', '   ');
    slice_plane = slice_dir1;
elseif n_direction2 == 3 && ~sum(isnan(slice_dir2))
    set(handles.MsgTxt, 'String', 'The Non-effective direction was neglected.',...
        'ForegroundColor', [0, 0, 0]);
    set(handles.V1, 'String', '   ');
    slice_plane = slice_dir2;
end

flag = get(handles.Propertyi, 'String');
flag_value = get(handles.Propertyi, 'Value');
flagi = flag(flag_value);
n = str2double(get(handles.InterNum, 'String'));

CIJ = handles.CIJ;
NO = handles.NO;
Cij = CIJ(:, :, NO);
S = inv(Cij);
handles = Plot_Slice_GUI(handles, S, n, flagi, slice_plane, 0, 'name');

% Fig_legend =handles.PlotLegendStr;
% legend(handles.Axes, Fig_legend, 'Interpreter', 'LaTex', 'Location', 'best');
% legend('boxoff');
handles.SlicePlane = slice_plane;
guidata(hObject, handles);



function V1_Callback(hObject, eventdata, handles)
% hObject    handle to V1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of V1 as text
%        str2double(get(hObject,'String')) returns contents of V1 as a double


% --- Executes during object creation, after setting all properties.
function V1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function V2_Callback(hObject, eventdata, handles)
% hObject    handle to V2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of V2 as text
%        str2double(get(hObject,'String')) returns contents of V2 as a double


% --- Executes during object creation, after setting all properties.
function V2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ColorSetting.
function ColorSetting_Callback(hObject, eventdata, handles)
% hObject    handle to ColorSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ColorMapList = {'jet', 'parula', 'hsv', 'hot', 'cool', 'spring', 'summer',...
    'autumn', 'winter', 'gray', 'bone', 'copper', 'pink'};
[sel, ok] = listdlg('ListString', ColorMapList, 'Name', 'Select a colormap',...
    'OKString', 'OK', 'CancelString', 'Cancel', 'SelectionMode', 'single', ...
    'PromptString', 'Select a colormap', 'ListSize', [180, 60]);
if ok == 1
    NewColorMap = cell2mat(ColorMapList(sel));
    handles.PlotColorMap = NewColorMap;
    guidata(hObject, handles);
    colormap(handles.Axes, NewColorMap);
%     CIJApply_Callback(handles.CIJApply, eventdata, handles);
%     handles.PlotColorMap = 'jet';
%     guidata(hObject, handles);
end


% --- Executes on selection change in AnyViewDir.
function AnyViewDir_Callback(hObject, eventdata, handles)
% hObject    handle to AnyViewDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ViewDirStr = get(hObject, 'String');
ViewDirVal = get(hObject, 'Value');
ViewDir = cell2mat(ViewDirStr(ViewDirVal));
DirSplit = strsplit(ViewDir);
n = length(DirSplit);
DirNum = zeros(1, n);
for i = 1:n
    DirNum(i) = str2double(cell2mat(DirSplit(i)));
end
handles = ViewAnyDir(handles, DirNum);
handles.PlotView = DirNum;
guidata(hObject, handles);


% Hints: contents = cellstr(get(hObject,'String')) returns AnyViewDir contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnyViewDir


% --- Executes during object creation, after setting all properties.
function AnyViewDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnyViewDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TitleSetting.
function TitleSetting_Callback(hObject, eventdata, handles)
% hObject    handle to TitleSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TitleOn = handles.PlotTitle;
titlestr = handles.PlotTitleStr;
if strcmp(TitleOn, 'on')
    handles.PlotTitle = 'off';
%     hTitle = findobj(handles.Axes, 'String', titlestr);
%     delete(hTitle);
else 
    handles.PlotTitle = 'on';
%     title(handles.Axes, titlestr);
end
guidata(hObject, handles);
CIJApply_Callback(handles.CIJApply, eventdata, handles);


% --- Executes on button press in LegendSetting.
function LegendSetting_Callback(hObject, eventdata, handles)
% hObject    handle to LegendSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LegendOn = handles.PlotLegend;
LegendStr = handles.PlotLegendStr;
if strcmp(LegendOn, 'on')
    hLegend = findobj('Type', 'legend');
    handles.PlotLegend = 'off';
    delete(hLegend);
else
    legend(handles.Axes, LegendStr, 'Interpreter', 'LaTex', 'Location', 'best');
    legend('boxoff');
    handles.PlotLegend = 'on';
end
guidata(hObject, handles);
% CIJApply_Callback(hObject, eventdata, handles);


% --- Executes on button press in ColorbarSetting.
function ColorbarSetting_Callback(hObject, eventdata, handles)
% hObject    handle to ColorbarSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ColorBar = handles.PlotColorBar;
ColorBarSet = inputdlg({'Colorbar Mode', 'cmin', 'cmax'}, 'ColorBar Settings',...
    [1, 20; 1, 20; 1, 20], {'Auto', '20', '100'});
if ~isempty(ColorBarSet)
    ColorBarMode = cell2mat(ColorBarSet(1));
    ColorBarCmin = str2double(cell2mat(ColorBarSet(2)));
    ColorBarCmax = str2double(cell2mat(ColorBarSet(3)));
    handles.PlotColarBarMode = ColorBarMode;
    handles.PlotColarBarCmin = ColorBarCmin;
    handles.PlotColarBarCmax = ColorBarCmax;
    
    if strcmpi(ColorBarMode(1), 'A')
        if strcmp(ColorBar, 'on')
            handles.PlotColorBar = 'off';
            colorbar(handles.Axes, 'off');
        else
            handles.PlotColorBar = 'on';
            colorbar(handles.Axes, 'AxisLocation','out');
        end
        caxis auto
    elseif strcmpi(ColorBarMode(1), 'M')
        caxis([ColorBarCmin, ColorBarCmax])
    end
end
guidata(hObject, handles);
% CIJApply_Callback(handles.CIJApply, eventdata, handles);


% --- Executes on button press in SetAsDefault.
function SetAsDefault_Callback(hObject, eventdata, handles)
% hObject    handle to SetAsDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CurrPath = mfilename('fullpath');
index = strfind(CurrPath,'\');
CurrPath = CurrPath(1:index(end));
% prompt = {'Saving Path(1 change, 0 not)', 'Figure Format', 'Data Format', ...
%     'Resolution', 'Save 3D/2D Data', 'Send to Workspace', 'Show Title', ...
%     'Colormap', 'ColorBar', 'Axes', 'Legend', 'View Direction', 'Number of Point'};
% dlg_title = 'Set Default';
% DefaultVal = cell(1, length(prompt));
% for i = 1:length(prompt)
%     DefaultVal(i) = {'1'};
% end
% SaveDefault = inputdlg(prompt, dlg_title, 2, DefaultVal)
% if isempty(SaveDefault)
%     return
% end
InitialDataName = 'InitialData.mat';
load([CurrPath, InitialDataName]);

SaveSetting.Path = handles.SavePath;
SaveSetting.Ext = get(handles.SaveType, 'Value');
SaveSetting.DataExt = get(handles.DataExt, 'Value');
SaveSetting.Resolution = get(handles.ResolutionValue, 'String');
SaveSetting.SaveData3D = get(handles.Out3D, 'Value');
SaveSetting.SaveDataToWS = get(handles.SendToWS, 'Value');
PlotSetting.Title = handles.PlotTitle;
PlotSetting.ColorMap = handles.PlotColorMap;
PlotSetting.ColorBar = handles.PlotColorBar;
PlotSetting.Axes = handles.PlotAxes;
PlotSetting.Legend = handles.PlotLegend;
PlotSetting.View = handles.PlotView;
PlotSetting.n = get(handles.InterNum, 'String');

save([CurrPath, InitialDataName], 'Initial2D', 'Initial3D', ...
    'PlotSetting', 'SaveSetting');
set(handles.MsgTxt, 'String', 'The Default Setting Has Been Changed.')



% --- Executes on button press in SendToWS.
function SendToWS_Callback(hObject, eventdata, handles)
% hObject    handle to SendToWS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SendToWS


% --- Executes on button press in Out3D.
function Out3D_Callback(hObject, eventdata, handles)
% hObject    handle to Out3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Out3D


% --- Executes on button press in IncludeHead.
function IncludeHead_Callback(hObject, eventdata, handles)
% hObject    handle to IncludeHead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IncludeHead = get(handles.IncludeHead, 'Value');
if IncludeHead == 1
    set(handles.HeadEvery, 'Enable', 'on');
%     set(handles.HeadOne, 'Enable', 'on');
else
    set(handles.HeadEvery, 'Enable', 'off');
%     set(handles.HeadOne, 'Enable', 'off');
end
% Hint: get(hObject,'Value') returns toggle state of IncludeHead


% --- Executes on button press in SaveData.
function SaveData_Callback(hObject, eventdata, handles)
% hObject    handle to SaveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IncludeHead = get(handles.IncludeHead, 'Value');
HeadEvery = get(handles.HeadEvery, 'Value');
SingleOut = get(handles.OutInSingle, 'Value');
OrdVal = get(handles.Order, 'Value');
ExtStr = get(handles.DataExt, 'String');
ExtVal = get(handles.DataExt, 'Value');
DataExt = cell2mat(ExtStr(ExtVal));

PlotType = get(handles.Plot3D, 'Value');

SaveName = handles.SaveName;
FileName = cell2mat(SaveName(1));
[file, path] = uiputfile(['*', DataExt], 'Save Data', [FileName, DataExt]);
if file == 0
    return
else
    filename = [path, file];
    if exist(filename, 'file')
        delete(filename);
    end
end
set(handles.MsgTxt, 'String', 'Saving......');
guidata(hObject, handles);

SendToWS = get(handles.SendToWS, 'Value');
Out3D2D = get(handles.Out3D, 'Value');
PropertyStr = get(handles.Propertyi, 'String');
PropertyVal = get(handles.Propertyi, 'Value');
Propertyi = cell2mat(PropertyStr(PropertyVal));
V = handles.V;
[row_V, col_V] = size(V);

%get original Head
Heado = DataHead();
%get CIJ
NO = handles.NO;
n_Cij = handles.n_Cij;
CIJ = handles.CIJ;

%Initial EPoly
if OrdVal == 2 && SingleOut
    EPoly = zeros(n_Cij, 6, 8);
else
    EPoly = zeros(8, 6, n_Cij);
end
%Initial 3D information
if Out3D2D == 1
    if PlotType
        VOut = zeros(row_V, col_V, n_Cij);
        XOut = zeros(row_V, col_V, n_Cij);
        YOut = zeros(row_V, col_V, n_Cij);
        ZOut = zeros(row_V, col_V, n_Cij);
    else
        VOut = zeros(col_V, row_V, n_Cij);
        XOut = zeros(col_V, row_V, n_Cij);
        YOut = zeros(col_V, row_V, n_Cij);
%         XOut = zeros(
    end
end

if IncludeHead
    if OrdVal == 2 && SingleOut
        Head.Hx = SaveName;
        Head.Hy = Heado.Col;
        Head.Hz = Heado.Row;
    else
        Head.Hx = Heado.Row;
        Head.Hy = Heado.Col;
        Head.Hz = SaveName;
    end
end
%Get EPoly and 3D data
for i = 1:n_Cij
    CIJi = CIJ(:, :, i);
    EPolytmp = ElasticVRH3D(CIJi);
    if OrdVal == 2 && SingleOut
        for j = 1:size(EPoly, 3)
            EPoly(i, :, j) = EPolytmp(j, :);
        end
    else
        EPoly(:, :, i) = EPolytmp;
    end
    if Out3D2D == 1
        handles.NO = i;
        guidata(hObject, handles);
        handles = CIJApply_Callback(hObject, eventdata, handles);
        if PlotType
            VOut(:, :, i) = handles.V; XOut(:, :, i) = handles.X;
            YOut(:, :, i) = handles.Y; ZOut(:, :, i) = handles.Z;
        else
            VOut(:, :, i) = (handles.V)'; XOut(:, :, i) = (handles.X)';
            YOut(:, :, i) = (handles.Y)'; 
        end
    end
end
% send to workspace or not
if SendToWS == 1
    assignin('base', 'CIJ', handles.CIJ);
    if Out3D2D == 1
        assignin('base', [Propertyi, 'x'], VOut.*XOut);
        assignin('base', [Propertyi, 'y'], VOut.*YOut);        
        assignin('base', Propertyi, VOut);
        if PlotType
            assignin('base', [Propertyi, 'z'], VOut.*ZOut);
        end
    end
    assignin('base', 'EPoly', EPoly);
    if IncludeHead
        assignin('base', 'Head', Head);
    end
end
% Save the data in different format
if strcmp(DataExt, '.mat')
    if SingleOut
        save(filename, 'CIJ', 'EPoly');
        if Out3D2D == 1
            eval([Propertyi, ' = VOut;']);
            eval([[Propertyi, 'x'], ' = XOut;']);
            eval([[Propertyi, 'y'], ' = YOut;']);            
            save(filename, Propertyi, [Propertyi, 'x'], ...
                [Propertyi, 'y'],  '-append');
            if PlotType
                eval([[Propertyi, 'z'], ' = ZOut;']);
                save(filename, [Propertyi, 'z'], '-append');
            end
        end
        if IncludeHead
            save(filename, 'Head', '-append');
        end
    else
        for i = 1:n_Cij
            matname = cell2mat(SaveName(i));
            eval([['CIJ', num2str(i)], '= CIJ(:, :, i);']);
            eval([['EPoly', num2str(i)], '= ElasticVRH3D(CIJ(:, :, i));']);
            save(matname, ['CIJ', num2str(i)], ['EPoly', num2str(i)]);
            if Out3D2D == 1
                eval([[Propertyi, num2str(i)],' = VOut(:, :, i);']);
                eval([[Propertyi, num2str(i), 'x'], ' = XOut(:, :, i);']);
                eval([[Propertyi, num2str(i), 'y'], ' = YOut(:, :, i);']);
                save(matname, [Propertyi, num2str(i)], [Propertyi, num2str(i), 'x'], ...
                    [Propertyi, num2str(i), 'y'], '-append');
                if PlotType
                    eval([[Propertyi, num2str(i), 'z'], ' = ZOut(:, :, i);']);
                    save(matname, [Propertyi, num2str(i), 'z'], '-append');
                end
            end
            if IncludeHead
                save(matname, 'Head', '-append');
            end
        end
    end
elseif strcmp(DataExt, '.xlsx')
    CIJ = num2cell(CIJ);
    EPoly = num2cell(EPoly);
    [row_CIJ, col_CIJ, ~] = size(CIJ);
    [row_E, col_E, n_E] = size(EPoly);
    if IncludeHead
        CIJxls = cell(row_CIJ+1, col_CIJ, n_Cij);
        for i = 1:n_Cij
            CIJxls(1, 1, i) = SaveName(i);
            CIJxls(2:end, :, i) = CIJ(:, :, i);
        end
        CIJ = CIJxls;
        EPolyxls = cell(row_E + 1, col_E + 1, n_E);
        FlagName = Head.Hz;
        for i = 1:n_E
            EPolyxls(1, 1, i) = FlagName(i);
            EPolyxls(1, 2:end, i) = Head.Hy;
            EPolyxls(2:end, 1, i) = Head.Hx;
            EPolyxls(2:end, 2:end, i) = EPoly(:, :, i);
        end
        EPoly = EPolyxls;
    end
    [row_CIJ, col_CIJ, ~] = size(CIJ);
    [row_E, col_E, n_E] = size(EPoly);
    if SingleOut
        CIJOut = cell((row_CIJ + 1)*n_Cij, col_CIJ);
        EPolyOut = cell((row_E + 1)*n_E, col_E);
        for i = 1:n_Cij
            CIJOut(((row_CIJ + 1)*(i - 1) + 1):((row_CIJ + 1)*i - 1), :) = CIJ(:, :, i);
        end
        for i = 1:n_E
            EPolyOut(((row_E + 1)*(i - 1) + 1):((row_E + 1)*i - 1), :) = EPoly(:, :, i);
        end
        xlswrite(filename, CIJOut, 'CIJ');
        xlswrite(filename, EPolyOut, 'EVRH');
        if Out3D2D
            for i = 1:n_Cij
                sheetname = cell2mat(SaveName(i));
                if PlotType
                    SheetOut = [VOut(:, :, i).*XOut(:, :, i); VOut(:, :, i).*YOut(:, :, i); ...
                        VOut(:, :, i).*ZOut(:, :, i); VOut(:, :, i)];
                else
                    SheetOut = [VOut(:, :, i).*XOut(:, :, i); VOut(:, :, i).*YOut(:, :, i); ...
                        VOut(:, :, i)];
                end
                xlswrite(filename, SheetOut, sheetname);
            end
        end
    else
        for i = 1:n_Cij
            xlsname = [path, cell2mat(SaveName(i)), '.xlsx'];
            xlswrite(xlsname, CIJ(:, :, i), 'CIJ');
            xlswrite(xlsname, EPoly(:, :, i), 'EVRH');
            if Out3D2D
                xlswrite(xlsname, VOut(:, :, i).*XOut(:, :, i), 'X');
                xlswrite(xlsname, VOut(:, :, i).*YOut(:, :, i), 'Y');
                xlswrite(xlsname, VOut(:, :, i), Propertyi);
                if PlotType
                    xlswrite(xlsname, VOut(:, :, i).*ZOut(:, :, i), 'Z');
                end
            end
        end
    end
else  % txt
    if IncludeHead
        Hx = Head.Hx; Hy = Head.Hy; Hz = Head.Hz;
    end
    [row_CIJ, ~, ~] = size(CIJ);
    [row_E, col_E, n_E] = size(EPoly);
    if SingleOut
        fid = fopen(filename, 'a');
        for i = 1:n_Cij
            %for CIJ
            if IncludeHead
                fprintf(fid, '%s\n', cell2mat(SaveName(i)));
            end
            for j = 1:row_CIJ
                fprintf(fid, '%4.2f\t', CIJ(j, :, i));
                fprintf(fid, '\n');
            end
            fprintf(fid, '\n');
        end
        for i = 1:n_E
            % for EPoly
            if IncludeHead
                fprintf(fid, '%s\t', cell2mat(Hz(i)));
                for j = 1:col_E
                    fprintf(fid, '%s\t', cell2mat(Hy(j)));
                end
                fprintf(fid, '\n');
            end
            for j = 1:row_E
                if IncludeHead
                    fprintf(fid, '%s\t', cell2mat(Hx(j)));
                end
                fprintf(fid, '%4.2f\t', EPoly(j, :, i));
                fprintf(fid, '\n');
            end
            fprintf(fid, '\n');
        end
        if Out3D2D
            for i = 1:n_Cij
                row_3D = size(XOut, 1);
                for j = 1:row_3D
                    fprintf(fid, '%4.4f\t', VOut(j, :, i).*XOut(j, :, i));
                    fprintf(fid, '\n');
                end
                fprintf(fid, '\n');
                for j = 1:row_3D
                    fprintf(fid, '%4.4f\t', VOut(j, :, i).*YOut(j, :, i));
                    fprintf(fid, '\n');
                end
                fprintf(fid, '\n');
                if PlotType
                    for j = 1:row_3D
                        fprintf(fid, '%4.4f\t', VOut(j, :, i).*ZOut(j, :, i));
                        fprintf(fid, '\n');
                    end
                    fprintf(fid, '\n');
                end
                for j = 1:row_3D
                    fprintf(fid, '%4.4f\t', VOut(j, :, i));
                    fprintf(fid, '\n');
                end
                fprintf(fid, '\n');
            end
        end
        fclose(fid);
    else
        for i = 1:n_Cij
            txtname = [path, cell2mat(SaveName(i)), '.txt'];
            if exist(txtname, 'file')
                delete(txtname);
            end
            fid = fopen(txtname, 'a');
            %for CIJ
            if IncludeHead
                fprintf(fid, '%s\n', cell2mat(SaveName(i)));
            end
            for j = 1:row_CIJ
                fprintf(fid, '%4.2f\t', CIJ(j, :, i));
                fprintf(fid, '\n');
            end
            fprintf(fid, '\n');
            %for EPoly
            if IncludeHead
                fprintf(fid, '%s\t', cell2mat(Hz(i)));                
                for j = 1:col_E
                    fprintf(fid, '%s\t', cell2mat(Hy(j)));
                end
                fprintf(fid, '\n');
            end
            for j = 1:row_E
                if IncludeHead
                    fprintf(fid, '%s\t', cell2mat(Hx(j)));
                end
                fprintf(fid, '%4.2f\t', EPoly(j, :, i));
                fprintf(fid, '\n');
            end
            fprintf(fid, '\n');
            %for XYZV
            if Out3D2D
                row_3D = size(XOut, 1);
                for j = 1:row_3D
                    fprintf(fid, '%4.4f\t', VOut(j, :, i).*XOut(j, :, i));
                    fprintf(fid, '\n');
                end
                fprintf(fid, '\n');
                for j = 1:row_3D
                    fprintf(fid, '%4.4f\t', VOut(j, :, i).*YOut(j, :, i));
                    fprintf(fid, '\n');
                end
                fprintf(fid, '\n');
                if PlotType
                    for j = 1:row_3D
                        fprintf(fid, '%4.4f\t', VOut(j, :, i).*ZOut(j, :, i));
                        fprintf(fid, '\n');
                    end
                    fprintf(fid, '\n');
                end
                for j = 1:row_3D
                    fprintf(fid, '%4.4f\t', VOut(j, :, i));
                    fprintf(fid, '\n');
                end
                fprintf(fid, '\n');
            end
            fclose(fid);
        end
    end
end


set(handles.MsgTxt, 'String', 'The Data has been saved.');


% --- Executes on selection change in Order.
function Order_Callback(hObject, eventdata, handles)
% hObject    handle to Order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Order contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Order


% --- Executes during object creation, after setting all properties.
function Order_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DataExt.
function DataExt_Callback(hObject, eventdata, handles)
% hObject    handle to DataExt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DataExt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DataExt


% --- Executes during object creation, after setting all properties.
function DataExt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataExt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObjVal = handles.SaveDataExt;
set(hObject, 'Value', hObjVal);
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function InterNum_Callback(hObject, eventdata, handles)
% hObject    handle to InterNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
InterNum = get(hObject, 'String');
InterNumI = str2double(InterNum);
if InterNumI == floor(InterNumI)
    set(handles.MsgTxt, 'String', 'OK.', 'ForegroundColor', [0, 0, 0]);
else
    set(handles.MsgTxt, 'String', 'Must be Integer.', 'ForegroundColor', [1, 0, 0]);
    InterNumI = floor(InterNumI);
end
set(hObject, 'String', num2str(InterNumI));
% Hints: get(hObject,'String') returns contents of InterNum as text
%        str2double(get(hObject,'String')) returns contents of InterNum as a double


% --- Executes during object creation, after setting all properties.
function InterNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InterNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObjStr = handles.PlotNumPoint;
set(hObject, 'String', hObjStr);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in HLPoint.
function HLPoint_Callback(hObject, eventdata, handles)
% hObject    handle to HLPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HLPoint


% --- Executes during object creation, after setting all properties.
function GraphicPOST_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GraphicPOST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function SendToWS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SendToWS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObjVal = handles.SaveDataToWS;
set(hObject, 'Value', hObjVal);


% --- Executes during object creation, after setting all properties.
function Out3D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Out3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObjVal = handles.SaveData3D;
set(hObject, 'Value', hObjVal);


% --- Executes on button press in Restore.
function Restore_Callback(hObject, eventdata, handles)
% hObject    handle to Restore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CurrPath = mfilename('fullpath');
index = strfind(CurrPath,'\');
CurrPath = CurrPath(1:index(end));
InitialDataName = 'InitialData.mat';
BackupFile = 'InitialData_backup.mat';
sourcefile = [CurrPath, BackupFile];
destifile = [CurrPath, InitialDataName];
copyfile(sourcefile, destifile);
TipString = 'The Default Setting Was Restored, Please Re-Start the Software.';
set(handles.MsgTxt, 'String', TipString);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over SaveSingle.
function SaveSingle_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to SaveSingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SaveSingleV = 1;
guidata(hObject, handles);
