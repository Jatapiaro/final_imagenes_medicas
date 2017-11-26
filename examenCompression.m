function varargout = examenCompression(varargin)
% EXAMENCOMPRESSION MATLAB code for examenCompression.fig
%      EXAMENCOMPRESSION, by itself, creates a new EXAMENCOMPRESSION or raises the existing
%      singleton*.
%
%      H = EXAMENCOMPRESSION returns the handle to a new EXAMENCOMPRESSION or the handle to
%      the existing singleton*.
%
%      EXAMENCOMPRESSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXAMENCOMPRESSION.M with the given input arguments.
%
%      EXAMENCOMPRESSION('Property','Value',...) creates a new EXAMENCOMPRESSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before examenCompression_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to examenCompression_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help examenCompression

% Last Modified by GUIDE v2.5 26-Nov-2017 00:27:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @examenCompression_OpeningFcn, ...
                   'gui_OutputFcn',  @examenCompression_OutputFcn, ...
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


% --- Executes just before examenCompression is made visible.
function examenCompression_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

nombreImagenes = evalin('base','nombreImagenes');
for i = 1 : length(nombreImagenes)
    nombreImagenes(i)
end

set(handles.listbox1,'string',nombreImagenes);
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to examenCompression (see VARARGIN)

% Choose default command line output for examenCompression
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes examenCompression wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = examenCompression_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

handles.output = hObject;
index = get(handles.listbox1,'value');
assignin('base', 'selectedIndex2', index);


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

index = evalin('base','selectedIndex2');
nombreImagenes = evalin('base','nombreImagenes');
mriFolder = evalin('base','mriFolder');

nombreImagen = fullfile(mriFolder, nombreImagenes{index});

fileinfo = dir(nombreImagen);

imagen = dicomread(nombreImagen);
i = uint16(imagen(:,:,1));
i = im2double(imagen(:,:,1)); 

i_mean = mean(i);      
[a b] = size(i); 
i_mean2 = repmat(i_mean,a,1); 
i_Adjust = i - i_mean2; 
i_cov = cov(i_Adjust);   
[V, D] = eig(i_cov); 
i_eigen=V'*i_Adjust';   
i_Original = inv(V') * i_eigen;                         
i_Original = i_Original' + i_mean2;                

nCols = str2num(get(handles.nCol,'String'));
PCs=nCols;                    
PCs = b - PCs;                                                         
V_red = V;                                                         
for idx = 1:PCs,                                                         
    V_red(:,1) =[]; 
end 
Y=V_red'* i_Adjust';                                        
i_compres=V_red*Y;                                           
i_compres = i_compres' + i_mean2;  

axes(handles.axes1);
imshow(i,[]);

axes(handles.axes4);
imshow(i_compres,[]);

[rows,cols] = size(i(:,:,1));

originalMemory = rows * cols
necessaryMemory = (rows*nCols);
compressionFactor = necessaryMemory / originalMemory;
compressionRate = 1 - compressionFactor;
set(handles.rate1, 'String', num2str(compressionRate));
err = immse(i, i_compres);
set(handles.mse2, 'String', num2str(err));



%%Sinoidal Code
T = dctmtx(8);
dct = @(block_struct) T * block_struct.data * T';
B = blockproc(i,[8 8],dct);

mask = [1   1   1   1   0   0   0   0
        1   1   1   0   0   0   0   0
        1   1   0   0   0   0   0   0
        1   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0];
    
B2 = blockproc(B,[8 8],@(block_struct) mask .* block_struct.data);
invdct = @(block_struct) T' * block_struct.data * T;
I2 = blockproc(B2,[8 8],invdct);

axes(handles.axes5);
imshow(I2,[]);

%{
%% Guardamos la imagen para conocer el tamaño del archivo y
%% poder calcular el rate de compresion 
%% https://en.wikipedia.org/wiki/Data_compression_ratio
%}
imwrite(I2,'Compressed.jpg');
fileinfo2 = dir('Compressed.jpg');
fileinfo.bytes;
fileinfo2.bytes;

compressionRate2 = 1-(fileinfo2.bytes / fileinfo.bytes)
set(handles.rate2, 'String', num2str(compressionRate2));
err2 = immse(i, I2);
set(handles.mse3, 'String', num2str(err2));


function nCol_Callback(hObject, eventdata, handles)
% hObject    handle to nCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nCol as text
%        str2double(get(hObject,'String')) returns contents of nCol as a double


% --- Executes during object creation, after setting all properties.
function nCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
