function [CIJ, ComName] = DataModeSelect(hObject, eventdata, handles)
% function
%     Select the DataMode, and set some corresponding CrystalType
n = 6;
Datamode = get(handles.DataMode, 'Value');
MalType = get(handles.MType, 'Value');
switch Datamode
    case 1    %Single
        set(handles.CrystalType, 'Enable', 'on');
        if MalType == 1
            SetString = {'Cubic', 'Tetragonal_1', 'Tetragonal_2', 'Orthorhombic',...
                'Hexagonal', 'Trigonal_1', 'Trigonal_2', 'Monoclinic', 'Triclinic'};
        elseif MalType == 2
            SetString = {'Hexagonal', 'Square', 'Rectangular', 'Oblique'};
        end
        set(handles.CrystalType, 'String', SetString, 'Value', 1, 'Enable', 'on');
        SetAPNOn(handles);
        [CIJ, ComName] = Crytype(hObject, eventdata, handles);
        %         CIJ = GetCijSingle(handles);
    case 2    %From File
        Crytype(hObject, eventdata, handles);
        set(handles.CrystalType, 'String', 'Unused', 'Value', 1, 'Enable', 'off');
        [FileName, PathName] = uigetfile({'*.xlsx'; '*.mat'; '*.txt'; '*.dat'},...
            'Select Elastic Stiffness File');
        %         FileOut = [PathName, FileName];
        if FileName ~= 0
            [CIJ, ComName, State] = Elastic_Read([PathName, FileName]);
            SetAPNOn(handles);
            if strcmp(State, 'OK')
                State = 'Data read finished.';
                set(handles.MsgTxt, 'ForegroundColor', [0, 0, 0]);
            else
                set(handles.MsgTxt, 'ForegroundColor', [1, 0, 0]);
            end
            set(handles.MsgTxt, 'String', State);
        else
            CIJ = zeros(n, n, 1);
            ComName = {'Untitled'};
            SetAPNOff(handles);
            set(handles.MsgTxt, 'String', 'Nothing Selected.', 'ForegroundColor', [1, 0, 0]);
        end
        SetCij(handles, CIJ(:, :, 1));
    case 3    %FromWorkSpace
        SetAPNOn(handles);
        Vars = evalin('base', 'whos');
        VarNames = char(Vars.name);
        N_var = size(VarNames, 1);
        if isempty(VarNames)
            SetString = 'No Variables in WorkSpace';
            set(handles.MsgTxt, 'String', SetString, 'ForegroundColor', [1, 0, 0]);
            SetAPNOff(handles);
%             CIJ = zeros(n, n, 1);
        else
            SetString = cell(N_var, 1);
            for i = 1:N_var
                SetString{i, :} = [VarNames(i, :), ',', num2str(Vars(i).size(1)),...
                    'X', num2str(Vars(i).size(2)), ',', Vars(i).class];
            end
            
            
%             Cij = evalin('base', VarNames(1, :));
%             Info_Cij = whos('Cij');
%             class_Cij = Info_Cij.class;
%             if strcmp(class_Cij, 'double')
%                 if size(Cij, 2) == 3
%                     set(handles.MType, 'Value', 2);
%                     Cij = D2toD3(Cij);
%                 end
%                 Num_Cij = size(Cij, 1)/n;
%                 if Num_Cij ~= floor(Num_Cij)
%                     set(handles.MsgTxt, 'String', 'There are some data is neglected');
%                 else
%                     set(handles.MsgTxt, 'String', 'OK');
%                 end
%                 n_Cij = floor(Num_Cij);
%                 CIJ = reshape(Cij(1:n_Cij*n, :)', n, n, []);
%             else
%                 set(handles.MsgTxt, 'String', 'There is NO DATA in workspace');
%                 CIJ = zeros(n, n, 1);
%             end
        end
        set(handles.CrystalType, 'String', SetString, 'Value', 1, 'Enable', 'on');
        [CIJ, ComName] = Crytype(hObject, eventdata, handles);
%         set(handles.CrystalType, 'String', SetString, 'Value', 1);
%         Crytype(hObject, handles);
        
end
end

function CIJ = GetCijSingle(handles)
CIJ = zeros(6, 6, 1);
for i = 1:6
    for j = 1:6
        h_cij = ['c', num2str(i), num2str(j)];
        eval(['CIJ(i, j) = str2num(get(handles.', h_cij, ',''String''));']);
    end
end
end
