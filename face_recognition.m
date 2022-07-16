function varargout = face_recognition(varargin)
% FACE_RECOGNITION MATLAB code for face_recognition.fig
%      FACE_RECOGNITION, by itself, creates a new FACE_RECOGNITION or
%      raises the existing singleton*.
%
%      H = FACE_RECOGNITION returns the handle to a new FACE_RECOGNITION
%      or the handle to the existing singleton*.

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

% the fig was first saved as testing.fig and its buttons still call testing(),
% so point them back to this file
set(handles.start, 'Callback', @(h,e)face_recognition('start_Callback',h,e,guidata(h)));
set(handles.face,  'Callback', @(h,e)face_recognition('face_Callback',h,e,guidata(h)));
set(handles.eyes,  'Callback', @(h,e)face_recognition('eyes_Callback',h,e,guidata(h)));
set(handles.stop,  'Callback', @(h,e)face_recognition('stop_Callback',h,e,guidata(h)));

% make the detectors once instead of every frame
handles.faceDetector = vision.CascadeObjectDetector;
handles.eyeDetector = vision.CascadeObjectDetector('EyePairBig');
handles.eyeDetector.MinSize = [11 45];
handles.mode = 'none';

axes(handles.axes1);
axis off;
guidata(hObject, handles);

function varargout = face_recognition_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'vid') && isvalid(handles.vid) && isrunning(handles.vid)
    return;
end

% use the webcam's default format so it works on other cameras too
handles.vid = videoinput('winvideo', 1);
handles.vid.ReturnedColorspace = 'rgb';
triggerconfig(handles.vid, 'manual');
guidata(hObject, handles);

start(handles.vid);
fig = handles.figure1;
while ishandle(fig) && isrunning(handles.vid)
    img = getsnapshot(handles.vid);

    % face and eyes buttons only change the mode, read it again every frame
    h = guidata(fig);
    if strcmp(h.mode, 'face')
        bbox = step(handles.faceDetector, img);
        img = insertObjectAnnotation(img, 'rectangle', bbox, 'FACE');
    elseif strcmp(h.mode, 'eyes')
        bbox = step(handles.eyeDetector, img);
        img = insertObjectAnnotation(img, 'rectangle', bbox, 'EYE');
    end

    imshow(img, 'Parent', handles.axes1);
    drawnow;
end

% stop button pressed or window closed
if isvalid(handles.vid)
    stop(handles.vid);
    delete(handles.vid);
end


% --- Executes on button press in face.
function face_Callback(hObject, eventdata, handles)
% hObject    handle to face (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mode = 'face';
guidata(hObject, handles);


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'vid') && isvalid(handles.vid)
    stop(handles.vid);
end


% --- Executes on button press in eyes.
function eyes_Callback(hObject, eventdata, handles)
% hObject    handle to eyes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mode = 'eyes';
guidata(hObject, handles);
