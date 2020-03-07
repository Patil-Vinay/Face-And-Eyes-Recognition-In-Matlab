function varargout = face_recognition(varargin)
% TESTING MATLAB code for face_recognition.fig
%      TESTING, by itself, creates a new TESTING or raises the existing
%      singleton*.
%
%      H = TESTING returns the handle to a new TESTING or the handle to
%      the existing singleton*.

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @face_recognition_OpeningFcn, ...
                   'gui_OutputFcn',  @face_recognition_OutputFcn, ...
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

function face_recognition_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
axes(handles.axes1);
imshow('nature.jpg');
axis off;
guidata(hObject, handles);

function varargout = face_recognition_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vid = videoinput('winvideo' , 1,'MJPG_1280x720');
%preview(handles.vid);
guidata(hObject, handles);

% --- Executes on button press in face.
function face_Callback(hObject, eventdata, handles)
% hObject    handle to face (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.vid = videoinput('winvideo' , 1, 'MJPG_1280x720');
triggerconfig(handles.vid ,'manual');
set(handles.vid, 'TriggerRepeat',inf);
set(handles.vid, 'FramesPerTrigger',5);
handles.vid.ReturnedColorspace = 'rgb';
 handles.vid.Timeout = 5;
start(handles.vid);
while(1)
facedetector = vision.CascadeObjectDetector;                                                 
trigger(handles.vid); 
handles.im = getdata(handles.vid, 1);
bbox = step(facedetector, handles.im);
hello = insertObjectAnnotation(handles.im,'rectangle',bbox,'FACE');
imshow(hello);
end
guidata(hObject, handles);


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
stop(handles.vid),clear handles.vid %, ,delete(handles.vid)
guidata(hObject, handles);


% --- Executes on button press in eyes.
function eyes_Callback(hObject, eventdata, handles)
% hObject    handle to eyes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
triggerconfig(handles.vid ,'manual');
set(handles.vid, 'TriggerRepeat',inf);
set(handles.vid, 'FramesPerTrigger',1);
handles.vid.ReturnedColorspace = 'rgb';
 handles.vid.Timeout = 2;
start(handles.vid);
while(1)
bodyDetector = vision.CascadeObjectDetector('EyePairBig');
bodyDetector.MinSize = [11 45]; 
%bodyDetector.ScaleFactor = 1.05;                                                 
trigger(handles.vid); 
handles.im = getdata(handles.vid, 1);
bbox = step(bodyDetector, handles.im);
hello = insertObjectAnnotation(handles.im,'rectangle',bbox,'EYE');
imshow(hello);
end
guidata(hObject, handles);