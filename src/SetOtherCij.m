function SetOtherCij(handles, Tag)
ctype = get(handles.CrystalType, 'Value');
CIJ = GetCij(handles);
SetSymmetry(handles, Tag, CIJ);
EqualCIJ = {};
MalType = get(handles.MType, 'Value');
if MalType == 1
    switch ctype
        case 1
            switch Tag
                case 'c11'
                    EqualCIJ = {'c11', 'c22', 'c33'};
                case 'c12'
                    EqualCIJ = {'c12', 'c13', 'c23', 'c31', 'c32'};
                case 'c44'
                    EqualCIJ = {'c44', 'c55', 'c66'};
            end
        case 2
            switch Tag
                case 'c11'
                    EqualCIJ = {'c11', 'c22'};
                case 'c13'
                    EqualCIJ = {'c13', 'c23', 'c32'};
                case 'c44'
                    EqualCIJ = {'c44', 'c55'};
            end
        case 3
            switch Tag
                case 'c11'
                    EqualCIJ = {'c11', 'c22'};
                case 'c13'
                    EqualCIJ = {'c13', 'c23', 'c32'};
                case 'c44'
                    EqualCIJ = {'c44', 'c55'};
                case 'c16'
                    NewC16 = str2double(get(handles.c16, 'String'));
                    set(handles.c26, 'String', num2str(-NewC16));
                    set(handles.c62, 'String', num2str(-NewC16));
            end
        case 4      %Orth, no other than symmtry
        case 5      %Hex
            switch Tag
                case 'c11'
                    EqualCIJ = {'c11', 'c22'};
                    NewC11 = str2double(get(handles.c11, 'String'));
                    set(handles.c66, 'String', num2str((NewC11-CIJ(1, 2))/2));
                case 'c12'
                    NewC12 = str2double(get(handles.c12, 'String'));
                    set(handles.c66, 'String', num2str((CIJ(1, 1) - NewC12)/2));
                case 'c13'
                    EqualCIJ = {'c13', 'c23', 'c32'};
                case 'c44'
                    EqualCIJ = {'c44', 'c55'};
            end
        case 6
            switch Tag
                case 'c11'
                    EqualCIJ = {'c11', 'c22'};
                case 'c13'
                    EqualCIJ = {'c13', 'c23', 'c32'};
                case 'c14'
                    EqualCIJ = {'c14', 'c56', 'c65'};
                    NewC14 = str2double(get(handles.c14, 'String'));
                    set(handles.c24, 'String', num2str(-NewC14));
                    set(handles.c42, 'String', num2str(-NewC14));
                case 'c44'
                    EqualCIJ = {'c44', 'c55'};
            end
        case 7
            switch Tag
                case 'c11'
                    EqualCIJ = {'c11', 'c22'};
                case 'c13'
                    EqualCIJ = {'c13', 'c23', 'c32'};
                case 'c14'
                    EqualCIJ = {'c14', 'c56', 'c65'};
                    NewC14 = str2double(get(handles.c14, 'String'));
                    set(handles.c24, 'String', num2str(-NewC14));
                    set(handles.c42, 'String', num2str(-NewC14));
                case 'c15'
                    NewC15 = str2double(get(handles.c15, 'String'));
                    set(handles.c25, 'String', num2str(-NewC15));
                    set(handles.c52, 'String', num2str(-NewC15));
                    set(handles.c46, 'String', num2str(-NewC15));
                    set(handles.c64, 'String', num2str(-NewC15));
                case 'c44'
                    EqualCIJ = {'c44', 'c55'};
            end
        case 8      %Mono no other than symmtry
        case 9      %triclinic no other than symmtry
    end
elseif MalType == 2
    switch ctype
        case 1
            switch Tag
                case 'c11'
                    EqualCIJ = {'c11', 'c22'};
                    NewC11 = str2double(get(handles.c11, 'String'));
                    set(handles.c66, 'String', num2str((NewC11-CIJ(1, 2))/2));
                case 'c12'
                    NewC12 = str2double(get(handles.c12, 'String'));
                    set(handles.c66, 'String', num2str((CIJ(1, 1) - NewC12)/2));
            end
        case 2
            switch Tag
                case 'c11'
                    EqualCIJ = {'c11', 'c22'};
            end
        case 3
        case 4
    end
end
n_EqualCIJ = length(EqualCIJ);
if n_EqualCIJ > 0
    SetEqualCIJ(handles, EqualCIJ, CIJ);
end
end

function SetEqualCIJ(handles, EqualCIJ, CIJ)
n = length(EqualCIJ);
Tag = cell2mat(EqualCIJ(1));
[i, j] = SepTag(Tag);
NewString = num2str(CIJ(i,j));
for i_tag = 2:n
    eval(['set(handles.', cell2mat(EqualCIJ(i_tag)), ',''String'',', NewString, ');']);
end
end


function SetSymmetry(handles, Tag, CIJ)
[i, j] = SepTag(Tag);
eval(['set(handles.c', num2str(j), num2str(i), ',''String'',', ...
    num2str(CIJ(i, j)), ')']);
end

function [i, j] = SepTag(Tag)
Tag2 = num2cell(Tag);
i = str2double(cell2mat(Tag2(2)));
j = str2double(cell2mat(Tag2(3)));
end