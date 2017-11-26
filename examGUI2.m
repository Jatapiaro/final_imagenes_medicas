function varargout = examGUI2(varargin)
% EXAMGUI MATLAB code for examGUI.fig
%      EXAMGUI, by itself, creates a new EXAMGUI or raises the existing
%      singleton*.
%
%      H = EXAMGUI returns the handle to a new EXAMGUI or the handle to
%      the existing singleton*.
%
%      EXAMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXAMGUI.M with the given input arguments.
%
%      EXAMGUI('Property','Value',...) creates a new EXAMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before examGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to examGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help examGUI

% Last Modified by GUIDE v2.5 25-Nov-2017 16:10:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @examGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @examGUI_OutputFcn, ...
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


% --- Executes just before examGUI is made visible.
function examGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to examGUI (see VARARGIN)

% Choose default command line output for examGUI
handles.output = hObject;

nombreImagenes = evalin('base','nombreImagenes');
for i = 1 : length(nombreImagenes)
    nombreImagenes(i)
end

set(handles.listbox1,'string',nombreImagenes);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes examGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = examGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

handles.output = hObject;

nombreImagenes = evalin('base','nombreImagenes');

index = get(handles.listbox1,'value');
assignin('base', 'selectedIndex', index);

estudioMRI = evalin('base','estudioMRI');
estudioIamp = evalin('base','estudioIamp');
Iamp = estudioIamp(:,:,index);

estudioIfase = evalin('base','estudioIfase');
Ifase = estudioIfase(:,:,index);

estudioIfaseBW = evalin('base','estudioIfaseBW');
IfaseBW = estudioIfaseBW(:,:,index);

axes(handles.axes1);
imshow(Iamp, []), colormap(jet);
set(handles.text2, 'String', strcat('Iamp ','  ',nombreImagenes(index)));

axes(handles.axes3);
imshow(Ifase, []), colormap(jet);
set(handles.text3, 'String', strcat('Ifase', '   ' ,nombreImagenes(index)));

axes(handles.axes4);
imshow(IfaseBW,[]);
set(handles.text4, 'String', strcat('IfaseBW', '   ' ,nombreImagenes(index)));

polyH = [];
polyR = [];

pause(0.1);
for i = 1:1:2
   
    if i == 1
        polyH = roipoly;
        meanOfPolyH = mean(polyH);
        set(handles.meanL, 'String', num2str(mean(meanOfPolyH)));
        set(handles.modeL, 'String', num2str(mode(polyH)));
        set(handles.stdL, 'String', num2str(std(meanOfPolyH)));
        assignin('base', 'meanH', meanOfPolyH);
    else
        polyR = roipoly;
        meanOfPolyR = mean(polyR);
        set(handles.meanR, 'String', num2str(mean(meanOfPolyH)));
        set(handles.modeR, 'String', num2str(mode(polyR)));
        set(handles.stdR, 'String', num2str(std(meanOfPolyR)));
        assignin('base', 'meanR', meanOfPolyR);
    end
    
end

IfaseVI=((int16(Ifase).*int16(polyH))+pi)*180/pi;
axes(handles.axes7);
imshow(IfaseVI,[]), colormap(jet), colorbar;
set(handles.text5, 'String', strcat('Ventriculo A', '   ' ,nombreImagenes(index)));

IfaseVI2=((int16(Ifase).*int16(polyR))+pi)*180/pi;
axes(handles.axes6);
imshow(IfaseVI2,[]), colormap(jet), colorbar;
set(handles.text6, 'String', strcat('Ventriculo B', '   ' ,nombreImagenes(index)));


%wait(polyH)
%polyH
%
%axes(handles.axes7);
%imshow(IfaseVI,[]), colormap(jet), colorbar;
%%polyH = impoly( handles.axes4 );



guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)

% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

%IfaseVI=((imag.*BW)+pi)*180/pi;
%f, imshow(IfaseVI,[]), colormap(jet), colorbar;


% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
