function varargout = mine_clearance(varargin)
% MINE_CLEARANCE MATLAB code for mine_clearance.fig
%      MINE_CLEARANCE, by itself, creates a new MINE_CLEARANCE or raises the existing
%      singleton*.
%
%      H = MINE_CLEARANCE returns the handle to a new MINE_CLEARANCE or the handle to
%      the existing singleton*.
%
%      MINE_CLEARANCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MINE_CLEARANCE.M with the given input arguments.
%
%      MINE_CLEARANCE('Property','Value',...) creates a new MINE_CLEARANCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mine_clearance_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mine_clearance_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mine_clearance

% Last Modified by GUIDE v2.5 02-Oct-2017 18:34:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mine_clearance_OpeningFcn, ...
                   'gui_OutputFcn',  @mine_clearance_OutputFcn, ...
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


% --- Executes just before mine_clearance is made visible.
function mine_clearance_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mine_clearance (see VARARGIN)

% Choose default command line output for mine_clearance
handles.output = hObject;

% ���������Ϊ��ϵͳ���
rng('shuffle')

% ��������
handles.crNum = 10;

% �Ѿ���ǵķ�������
handles.mapMark = zeros(9);

% �����ʼ��
handles.selectLoc = [0, 0];

% ��ʼ����������
handles.flagNum = 0;

% ��ɫ��ʼ��
for aa = 1:9
    for bb = 1:9
        eval( sprintf('set(handles.pushbutton%d%d, ''BackgroundColor'', [0.3 0.75 0.93])', aa, bb) )
    end
end

% ������Ϸ��ͼ
handles.crMap = genMap(handles.crNum);

% ��ʼ��ָʾ��
set(handles.text4, 'String', '00 in 10')

% ��ʱ����ʼ��
handles.ht = timer;                                     % ���嶨ʱ��
set(handles.ht, 'ExecutionMode', 'FixedRate');          % ExecutionMode   ִ�е�ģʽ
set(handles.ht, 'Period', 1);                           % ����
set(handles.ht, 'TimerFcn', {@dispTime, handles});      % ��ʱ��ִ�к���
start(handles.ht);                                      % ������ʱ��

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mine_clearance wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% ��ʱ����ִ�к��� 
function dispTime(hObject, eventdata, handles)

set(handles.text2, 'string', datestr(now))


% --- Outputs from this function are returned to the command line.
function varargout = mine_clearance_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% ������Ϸ��ͼ
function crMap = genMap(NoC)

% NoC = 10;
crLoc = randi(81, 1, NoC);

crNum = length(unique(crLoc));
while crNum < NoC
   crLoc = [crLoc, randi(81, 1, 10 - crNum)]; 
   crNum = length(unique(crLoc));
end

crMap = zeros(9);
crMap(crLoc) = -1;
mapPadding = zeros(11);
mapPadding(2:10, 2:10) = crMap;

[crX, crY] = find(mapPadding);

xLoc = bsxfun(@plus, crX, [-1, -1, -1, 0, 0, 1, 1, 1]);
yLoc = bsxfun(@plus, crY, [1, 0, -1, 1, -1, 1, 0, -1]);

for aa = 1:8*NoC
    if mapPadding(xLoc(aa), yLoc(aa)) > -1
        mapPadding(xLoc(aa), yLoc(aa)) = mapPadding(xLoc(aa), yLoc(aa)) + 1;
    end
end

crMap = mapPadding(2:10, 2:10);


% ���������ʱ�򿪵ĵ�ͼ����
function finded = dragShow(crMap, selectLoc)

mapPadding = -ones(11);
mapPadding(2:10, 2:10) = crMap;

crX = selectLoc(1) + 1;
crY = selectLoc(2) + 1;

areaMap = mapPadding;
areaNum = 2;

unfind = [crX(1), crY(1)];
finded = [crX(1), crY(1)];

% ��δ����ջ��Ϊ��, ���ҵ�ͼѡ�����0ʱ
while size(unfind, 1) > 0 && crMap(selectLoc(1),selectLoc(2)) == 0
    
    loc = unfind(end,:);
    unfind(end,:) = [];
    areaMap(loc(1),loc(2)) = -areaNum;
    
    % ����
    finded = [finded; [loc(1)-1, loc(2)+1]];
    if areaMap(loc(1)-1,loc(2)+1) == 0
        unfind = [unfind; [loc(1)-1, loc(2)+1]];
    end
    areaMap(loc(1)-1,loc(2)+1) = -areaNum;
    
    % ��
    finded = [finded; [loc(1)-1, loc(2)]];
    if areaMap(loc(1)-1,loc(2)) == 0
        unfind = [unfind; [loc(1)-1, loc(2)]];
    end
    areaMap(loc(1)-1,loc(2)) = -areaNum;
    
    % ����
    finded = [finded; [loc(1)-1, loc(2)-1]];
    if areaMap(loc(1)-1,loc(2)-1) == 0
        unfind = [unfind; [loc(1)-1, loc(2)-1]];
    end
    areaMap(loc(1)-1,loc(2)-1) = -areaNum;
    
    % ��
    finded = [finded; [loc(1), loc(2)+1]];
    if areaMap(loc(1),loc(2)+1) == 0
        unfind = [unfind; [loc(1), loc(2)+1]];
    end
    areaMap(loc(1),loc(2)+1) = -areaNum;
    
    % ��
    finded = [finded; [loc(1), loc(2)-1]];
    if areaMap(loc(1),loc(2)-1) == 0
        unfind = [unfind; [loc(1), loc(2)-1]];
    end
    areaMap(loc(1),loc(2)-1) = -areaNum;
    
    % ����
    finded = [finded; [loc(1)+1, loc(2)+1]];
    if areaMap(loc(1)+1,loc(2)+1) == 0
        unfind = [unfind; [loc(1)+1, loc(2)+1]];
    end
    areaMap(loc(1)+1,loc(2)+1) = -areaNum;
    
    % ��
    finded = [finded; [loc(1)+1, loc(2)]];
    if areaMap(loc(1)+1,loc(2)) == 0
        unfind = [unfind; [loc(1)+1, loc(2)]];
    end
    areaMap(loc(1)+1,loc(2)) = -areaNum;
    
    % ����
    finded = [finded; [loc(1)+1, loc(2)-1]];
    if areaMap(loc(1)+1,loc(2)-1) == 0
        unfind = [unfind; [loc(1)+1, loc(2)-1]];
    end
    areaMap(loc(1)+1,loc(2)-1) = -areaNum;
    
end

finded = unique(finded - 1, 'rows');
finded(any(finded < 1, 2),:) = [];
finded(any(finded > 9, 2),:) = [];
 
 
% --- Executes on button press in pushbuttonFlag.
function pushbuttonFlag_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ��ȡѡ�е�ַ
loc = handles.selectLoc;

% δѡ������, ������Ӧ
if handles.selectLoc == [0 0]
    return
end

% ��ȡ����
getStr = eval(sprintf('get(handles.pushbutton%d%d, ''String'')', loc(1), loc(2)));

if getStr == 'P'
    eval(sprintf('set(handles.pushbutton%d%d, ''String'', '''')', loc(1), loc(2)))
    handles.flagNum = handles.flagNum - 1;
else
    eval(sprintf('set(handles.pushbutton%d%d, ''String'', ''P'')', loc(1), loc(2)))
    handles.flagNum = handles.flagNum + 1;
end

% �ı�ָʾ��
set(handles.text4, 'String', sprintf('%02d in 10', handles.flagNum))

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbuttonDrag.
function pushbuttonDrag_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDrag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ʧ�ܱ�־
failFlag = 0;

% δѡ������, ������Ӧ
if handles.selectLoc == [0 0]
    return
end

% ��ȡ��Ҫ�򿪵�����
finded = dragShow(handles.crMap, handles.selectLoc);

% ��ȡ��ͼ
crMap = handles.crMap;

% �ı���ɫ
for aa = 1:size(finded, 1)
    
    eval(sprintf('set(handles.pushbutton%d%d, ''BackgroundColor'', [0.94 0.94 0.94])', finded(aa,1), finded(aa,2)))
    eval(sprintf('set(handles.pushbutton%d%d, ''Enable'', ''inactive'')', finded(aa,1), finded(aa,2)))
    handles.mapMark(finded(aa,1), finded(aa,2)) = 1;
    
    mapTip = crMap(finded(aa,1),finded(aa,2));
    if mapTip > 0
        eval(sprintf('set(handles.pushbutton%d%d, ''String'', ''%d'')', finded(aa,1), finded(aa,2), mapTip))
    elseif mapTip == -1
        eval(sprintf('set(handles.pushbutton%d%d, ''String'', ''*'')', finded(aa,1), finded(aa,2)))
        eval(sprintf('set(handles.pushbutton%d%d, ''BackgroundColor'', [1 0 0])', finded(aa,1), finded(aa,2)))
        hlt = msgbox('');
        texth = findall(hlt, 'Type', 'Text');
        set(texth, 'FontSize', 16, 'HorizontalAlignment', 'center', 'String', '���')
        set(texth, 'Position', [62.5 26 125])
        pushbuttonh =  findall(hlt, 'Style', 'pushbutton');
        set(pushbuttonh, 'Callback', {@pushbuttonMsgClose_Callback, handles, hlt})
        failFlag = 1;
    end
    
end

if sum(sum(handles.mapMark)) == 81 - handles.crNum && failFlag == 0
    hlt = msgbox('');
    texth = findall(hlt, 'Type', 'Text');
    set(texth, 'FontSize', 16, 'HorizontalAlignment', 'center', 'String', '�����r(�s���t)�q')
    set(texth, 'Position', [62.5 26 125])
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbuttonRestart.
function pushbuttonRestart_Callback(hObject, eventdata, handles)

% % ���������������
% rng(handles.RNG(1));
% try
%     handles.RNG(1) = [];
% catch
%     handles.RNG = randi(999, 1, 99);
% end

% �Ѿ���ǵķ�������
handles.mapMark = zeros(9);

% �����ʼ��
handles.selectLoc = [0, 0];

% ��ʼ����������
handles.flagNum = 0;

% ��ɫ��ʼ��
for aa = 1:9
    for bb = 1:9
        eval( sprintf('set(handles.pushbutton%d%d, ''BackgroundColor'', [0.3 0.75 0.93])', aa, bb) )
        eval(sprintf('set(handles.pushbutton%d%d, ''String'', '''')', aa, bb))
        eval(sprintf('set(handles.pushbutton%d%d, ''Enable'', ''on'')', aa, bb))
    end
end

% ������Ϸ��ͼ
handles.crMap = genMap(handles.crNum);

% ��ʼ��ָʾ��
set(handles.text4, 'String', '00 in 10')

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbuttonMsgClose.
function pushbuttonMsgClose_Callback(hObject, eventdata, handles, hlt)

% ������Ϸ
pushbuttonRestart_Callback(handles.pushbuttonRestart, eventdata, handles)

% �ر���Ϣ����
close(hlt)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [1, 1];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [1, 2];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [1, 3];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [1, 4];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [1, 5];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [1, 6];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [1, 7];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [1, 8];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [1, 9];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [2, 1];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [2, 2];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [2, 3];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [2, 4];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [2, 5];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [2, 6];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [2, 7];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [2, 8];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [2, 9];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [3, 1];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [3, 2];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [3, 3];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [3, 4];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [3, 5];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [3, 6];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [3, 7];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [3, 8];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [3, 9];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [4, 1];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [4, 2];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton43.
function pushbutton43_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [4, 3];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton44.
function pushbutton44_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [4, 4];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton45.
function pushbutton45_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [4, 5];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton46.
function pushbutton46_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [4, 6];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [4, 7];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton48.
function pushbutton48_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [4, 8];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton49.
function pushbutton49_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [4, 9];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [5, 1];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton52.
function pushbutton52_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [5, 2];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton53.
function pushbutton53_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [5, 3];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton54.
function pushbutton54_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [5, 4];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton55.
function pushbutton55_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [5, 5];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton56.
function pushbutton56_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [5, 6];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton57.
function pushbutton57_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [5, 7];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton58.
function pushbutton58_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [5, 8];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton59.
function pushbutton59_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [5, 9];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton61.
function pushbutton61_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [6, 1];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton62.
function pushbutton62_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [6, 2];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton63.
function pushbutton63_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [6, 3];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton64.
function pushbutton64_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [6, 4];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton65.
function pushbutton65_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [6, 5];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton66.
function pushbutton66_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [6, 6];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton67.
function pushbutton67_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [6, 7];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton68.
function pushbutton68_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [6, 8];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton69.
function pushbutton69_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [6, 9];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton71.
function pushbutton71_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [7, 1];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton72.
function pushbutton72_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [7, 2];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton73.
function pushbutton73_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [7, 3];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton74.
function pushbutton74_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [7, 4];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton75.
function pushbutton75_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [7, 5];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton76.
function pushbutton76_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [7, 6];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton77.
function pushbutton77_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [7, 7];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton78.
function pushbutton78_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [7, 8];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton79.
function pushbutton79_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [7, 9];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton81.
function pushbutton81_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [8, 1];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton82.
function pushbutton82_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [8, 2];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton83.
function pushbutton83_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [8, 3];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton84.
function pushbutton84_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [8, 4];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton85.
function pushbutton85_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [8, 5];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton86.
function pushbutton86_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [8, 6];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton87.
function pushbutton87_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [8, 7];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton88.
function pushbutton88_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [8, 8];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton89.
function pushbutton89_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [8, 9];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton91.
function pushbutton91_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [9, 1];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton92.
function pushbutton92_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [9, 2];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton93.
function pushbutton93_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [9, 3];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton94.
function pushbutton94_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [9, 4];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton95.
function pushbutton95_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [9, 5];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton96.
function pushbutton96_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [9, 6];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton97.
function pushbutton97_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [9, 7];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton98.
function pushbutton98_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [9, 8];

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton99.
function pushbutton99_Callback(hObject, eventdata, handles)

% ѡ������
handles.selectLoc = [9, 9];

% Update handles structure
guidata(hObject, handles);

