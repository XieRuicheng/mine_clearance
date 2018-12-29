
%% 生成地雷地图
NoC = 10;
rng(0)
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
disp(crMap)


%% 重复代码
for aa = 1:9
    for bb = 1:9
        fprintf('%% --- Executes on button press in pushbutton%d%d.\n', aa, bb)
        fprintf('function pushbutton%d%d_Callback(hObject, eventdata, handles)\n\n', aa, bb)
        fprintf('%% 选中坐标\n')
        fprintf('handles.selectLoc = [%d, %d];\n\n', aa, bb)
        fprintf('%% Update handles structure\n')
        fprintf('guidata(hObject, handles);\n\n\n')
    end
end

%%

mapPadding = -ones(11);
mapPadding(2:10, 2:10) = crMap;

[crX, crY] = find(mapPadding == 0);
areaMap = mapPadding;
areaNum = 2;

unfind = [crX(2), crY(2)];
finded = [crX(2), crY(2)];

while size(unfind, 1) > 0
    
    loc = unfind(end,:);
    unfind(end,:) = [];
    areaMap(loc(1),loc(2)) = -areaNum;
    
    % 右上
    finded = [finded; [loc(1)-1, loc(2)+1]];
    if areaMap(loc(1)-1,loc(2)+1) == 0
        unfind = [unfind; [loc(1)-1, loc(2)+1]];
    end
    areaMap(loc(1)-1,loc(2)+1) = -areaNum;
    
    % 上
    finded = [finded; [loc(1)-1, loc(2)]];
    if areaMap(loc(1)-1,loc(2)) == 0
        unfind = [unfind; [loc(1)-1, loc(2)]];
    end
    areaMap(loc(1)-1,loc(2)) = -areaNum;
    
    % 左上
    finded = [finded; [loc(1)-1, loc(2)-1]];
    if areaMap(loc(1)-1,loc(2)-1) == 0
        unfind = [unfind; [loc(1)-1, loc(2)-1]];
    end
    areaMap(loc(1)-1,loc(2)-1) = -areaNum;
    
    % 右
    finded = [finded; [loc(1), loc(2)+1]];
    if areaMap(loc(1),loc(2)+1) == 0
        unfind = [unfind; [loc(1), loc(2)+1]];
    end
    areaMap(loc(1),loc(2)+1) = -areaNum;
    
    % 左
    finded = [finded; [loc(1), loc(2)-1]];
    if areaMap(loc(1),loc(2)-1) == 0
        unfind = [unfind; [loc(1), loc(2)-1]];
    end
    areaMap(loc(1),loc(2)-1) = -areaNum;
    
    % 右下
    finded = [finded; [loc(1)+1, loc(2)+1]];
    if areaMap(loc(1)+1,loc(2)+1) == 0
        unfind = [unfind; [loc(1)+1, loc(2)+1]];
    end
    areaMap(loc(1)+1,loc(2)+1) = -areaNum;
    
    % 下
    finded = [finded; [loc(1)+1, loc(2)]];
    if areaMap(loc(1)+1,loc(2)) == 0
        unfind = [unfind; [loc(1)+1, loc(2)]];
    end
    areaMap(loc(1)+1,loc(2)) = -areaNum;
    
    % 左下
    finded = [finded; [loc(1)+1, loc(2)-1]];
    if areaMap(loc(1)+1,loc(2)-1) == 0
        unfind = [unfind; [loc(1)+1, loc(2)-1]];
    end
    areaMap(loc(1)+1,loc(2)-1) = -areaNum;
    
end

disp(areaMap(2:10, 2:10))

%% 消息框

% hlt = msgbox('');
% texth = findall(hlt, 'Type', 'Text');
% set(texth, 'FontSize', 16, 'HorizontalAlignment', 'center', 'String', '真菜')
% set(texth, 'Position', [62.5 26 125])
% pushbuttonh =  findall(hlt, 'Style', 'pushbutton');
% set(pushbuttonh, 'Callback', )






