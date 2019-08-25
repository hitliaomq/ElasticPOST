function [CIJ, ComName] = Crytype(hObject, eventdata, handles)
% function:
%    Get initial CIJ from handles, and set CIJ to GUI
%    And get the CIJ for single and workspace
n = 6;
ctype = get(handles.CrystalType, 'Value');
Datamode = get(handles.DataMode, 'Value');
MalType = get(handles.MType, 'Value');
SetCijEnableOff(handles);
switch Datamode
    case 1
        ComName = {get(handles.NameInfo, 'String')};
        SetCij(handles, zeros(n, n));
        if MalType == 1  %3D
            InitialData = handles.InitialData.Initial3D;
            InitialCIJ = InitialData(ctype).Cij;            
        else
            InitialData = handles.InitialData.Initial2D;
            InitialCIJ = InitialData(ctype).Cij;
            InitialCIJ = D2toD3(InitialCIJ);
        end        
        InitialName = cell2mat(InitialData(ctype).Name);
        InitialID = cell2mat(InitialData(ctype).Id);
        InitialCryTyp = cell2mat(InitialData(ctype).CrystalType);
        %         clear InitialData
        InfoStr = [InitialName, ', ID=', InitialID, ', CrystalType=', InitialCryTyp];
        SetCij(handles, InitialCIJ);
        % Set the dependence CIJ text on
        if MalType == 1            
            switch ctype
                case 1    %cubic
                    DepenCIJ = {'c11', 'c12', 'c44'};
                case 2    %Tetragonal_1
                    DepenCIJ = {'c11', 'c12', 'c13', 'c33', 'c44', 'c66'};
                case 3    %Tetragonal_2
                    DepenCIJ = {'c11', 'c12', 'c13', 'c16', 'c33', 'c44', 'c66'};
                case 4    %Orthorhombic
                    DepenCIJ = {'c11', 'c12', 'c13', 'c22', 'c23', 'c33',...
                        'c44', 'c55', 'c66'};
                case 5    %Hexagonal
                    DepenCIJ = {'c11', 'c12', 'c13', 'c33', 'c44'};
                case 6    %Trigonal_1
                    DepenCIJ = {'c11', 'c12', 'c13', 'c14', 'c33', 'c44', 'c66'};
                case 7    %Trigonal_2
                    DepenCIJ = {'c11', 'c12', 'c13', 'c14', 'c15', 'c33', 'c44', 'c66'};
                case 8    %Monoclinic
                    DepenCIJ = {'c11', 'c12', 'c13', 'c15', 'c22', 'c23', 'c25',...
                        'c33', 'c35', 'c44', 'c46', 'c55', 'c66'};
                case 9    %Triclinic
                    DepenCIJ = {'c11', 'c12', 'c13', 'c14', 'c15', 'c16',...
                        'c22', 'c23', 'c24', 'c25', 'c26', 'c33', 'c34',...
                        'c35', 'c36', 'c44', 'c45', 'c46', 'c55', 'c56', 'c66'};
            end
        else
            switch ctype
                case 1    %hex
                    DepenCIJ = {'c11', 'c12'};
                case 2    %qua
                    DepenCIJ = {'c11', 'c12', 'c66'};
                case 3    %reg
                    DepenCIJ = {'c11', 'c12','c22', 'c66'};
                case 4    %obl
                    DepenCIJ = {'c11', 'c12', 'c16', 'c22', 'c26', 'c66'};                
            end
        end
        SetDepenCijOn(handles, DepenCIJ);
        % Get the CIJ
        CIJ(:, :, 1) = GetCij(handles);
        SetAPNOn(handles);
        set(handles.MsgTxt, 'String', 'OK');
    case 2
        InfoStr = 'Untitled';
        ComName = {'Untitled'};
        CIJ = zeros(n, n, 1);
        set(handles.MsgTxt, 'String', 'OK');
    case 3
        % Initial the CIJ to zeros
%         ComName = {'Untitled'};
        SetCij(handles, zeros(n, n));
        % Get the value from workspace
        TypeStr = get(handles.CrystalType, 'String');
        Info_TypeStr = whos('TypeStr');
        class_TypeStr = Info_TypeStr.class;
        % if the var is exsit, There are only two type of data, char(No Var) or cell
        if strcmp(class_TypeStr, 'char')
            CIJ = zeros(n, n, 1);
        else
            TypeStri = cell2mat(TypeStr(ctype));
            TypeStri = strsplit(TypeStri, ',');
            VarName = strtrim(cell2mat(TypeStri(1)));
            Cij = evalin('base', VarName);
            Info_Cij = whos('Cij');
            class_Cij = Info_Cij.class;
            % if is numeric data
            if strcmp(class_Cij, 'double')
                msgtxt = 'OK';
                FontColor = [0, 0, 0];
                if size(Cij, 2) == 3
                    Mod_line = mod(size(Cij, 1), 3);
                    if Mod_line
                        msgtxt = ['The number of line is not divisible by 3,', ...
                            'The last ', num2str(mod(size(Cij, 1), 3)),...
                            ' line(s) is(are) neglected.'];
                        FontColor = [1, 0, 0];
                        Cij = Cij(1:end - Mod_line, :);
                    end
                    set(handles.MType, 'Value', 2);
                    Cij = D2toD3(Cij);
                    CIJ = reshape(Cij', n, n, []);
                elseif size(Cij, 2) == 6
                    Mod_line = mod(size(Cij, 1), 6);
                    if Mod_line
                        msgtxt = ['The number of line is not divisible by 6,', ...
                            'The last ', num2str(mod(size(Cij, 1), 6)),...
                            ' line(s) is(are) neglected.'];
                        FontColor = [1, 0, 0];
                        Cij = Cij(1:end - Mod_line, :);
                    end
                    CIJ = reshape(Cij', n, n, []);
                else
                    msgtxt = ['This is not a effective CIJ, ', ...
                        'The column of the variable must be 3 or 6.'];
%                     set(handles.MsgTxt, 'String', msgtxt, 'ForegroundColor', [1, 0, 0]);
                    FontColor = [1, 0, 0];
                    CIJ = zeros(n, n, 1);
%                     return
                end
%                 CIJ = reshape(Cij', n, n, []);
                SetAPNOn(handles);
%                 set(handles.MsgTxt, 'String', msgtxt, 'ForegroundColor', FontColor);
            else
                CIJ = zeros(n, n, 1);
                msgtxt = 'This is not numeric data';
                FontColor = [1, 0, 0];
%                 set(handles.MsgTxt, 'String', 'This is not numeric data');
                SetAPNOff(handles);
%                 return
            end
            set(handles.MsgTxt, 'String', msgtxt, 'ForegroundColor', FontColor);
        end
        num_CIJ = size(CIJ, 3);
        ComName = cell(num_CIJ, 1);
        for i_Cij = 1:num_CIJ
            ComName(i_Cij) = {[VarName, '-', num2str(i_Cij)]};
        end
        InfoStr = 'Untitled';
        SetCij(handles, CIJ(:,:,1))
end
SetInfoStr(handles, InfoStr);
end

function SetDepenCijOn(handles, DepenCIJ)
for i = 1:length(DepenCIJ)
    h_cij = cell2mat(DepenCIJ(i));
    eval(['set(handles.', h_cij, ',''Enable'',''on'')']);
end
end

function SetCijEnableOff(handles)
for i = 1:6
    for j = 1:6
        h_cij = ['c', num2str(i), num2str(j)];
        eval(['set(handles.', h_cij, ',''Enable'',''off'');']);
    end
end
end

% function SetInitialCij(handles, InitialCIJ)
% for i = 1:6
%     for j = 1:6
%         h_cij = ['c', num2str(i), num2str(j)];
%         Cij = num2str(InitialCIJ(i, j));
%         eval(['set(handles.', h_cij, ', ''String'',', Cij, ')']);
%     end
% end
% end

function SetInfoStr(handles, InfoStr)
set(handles.InfoTxt, 'String', InfoStr);
end