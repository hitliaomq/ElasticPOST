function [Cij, ComName, State] = Elastic_Read(filename)
% filename = 'Cij.xlsx';
[~, FileName, FileExt] = fileparts(filename);
if strcmp(FileExt, '.xlsx') || strcmp(FileExt, '.xls')
    [Cij, ComName, State] = Elastic_ReadExcel(filename, FileName);
elseif strcmp(FileExt, '.dat') || strcmp(FileExt, '.txt')
    [Cij, ComName, State] = Elastic_ReadTxt(filename, FileName);
elseif strcmp(FileExt, '.mat')
    [Cij, ComName, State] = Elastic_ReadMat(filename, FileName);
else
    [Cij, ComName, State] = Elastic_ReadTxt(filename, FileName);
end
[~, col_Cij, num_Cij] = size(Cij);
% col_Cij = size(Cij, 2);
if col_Cij == 3
    Cij_tmp = zeros(6, 6, num_Cij);
    for i = 1:num_Cij
        Cij_tmp(:,:,i) = D2toD3(Cij(:,:,i));
    end
    Cij = Cij_tmp;
end
end
%% sub functions

%% Read mat file
function [Cij, ComName, State] = Elastic_ReadMat(filename, FileName)
% filename: The full filename for the file(With path).
% FileName: The filename without path.
% Cij: The elastic stiffness, 6x6xnum or 3x3xnum(num means the numbers of CIJ)
% ComName: The filename for output
% State: The state of reading.
data = load(filename);
FieldName = fieldnames(data);
N_Field = length(FieldName);
if N_Field == 0
    [Cij, ComName, State] = NoDataErr();
    return
end
Cij_tmp = [];
ComName = {''};
N_Cij = 0;
count_name = 0;
count_cij = 0;
for i = 1:N_Field
    eval(['Fieldi = data.', cell2mat(FieldName(i)), ';']);
    Pro_Field = whos('Fieldi');
    if strcmp(Pro_Field.class, 'cell')
        if count_name == 0
            ComName = Fieldi;
            count_name = 1;
        else
            disp('Only ONE var can be used as Name.');
        end
    elseif strcmp(Pro_Field.class, 'double')
        count_cij = count_cij + 1;        
        n = size(Fieldi, 2);
        if n ~= 6 && n ~= 3
            [Cij, ComName, State] = NoEffectiveDataErr();
            return
        end
        
        Tot_lines = size(Fieldi, 1);
        Extra_lines = mod(Tot_lines, n);
        N_Fieldi = Tot_lines/n;
        if Extra_lines
            N_Fieldi = floor(N_Fieldi);
            State = ExtraDataWarn(Extra_lines, n);
        else
            State = 'OK';
        end
        if N_Fieldi == 0
            [Cij, ComName, State] = NoDataErr();
            return
        end
        Cij_tmp = [Cij_tmp; Fieldi(1:n*N_Fieldi, :)];
        N_Cij(count_cij) = N_Fieldi;
    else
        [Cij, ComName, State] = NoDataErr();
        return
    end
end
Cij = reshape(Cij_tmp', n, n, []); 
Num_Cij = size(Cij, 3);
if count_name == 0
    ComName = cell(Num_Cij, 1);
    countnamei = 0;
    for i = 1:N_Field
        FieldNamei = FieldName(i);
        for j = 1:N_Cij(i)
            countnamei = countnamei + 1;
            ComName(countnamei) = {[FileName, '-', cell2mat(FieldNamei), '-', num2str(j)]};
        end
    end
end
disp(['There are ', num2str(Num_Cij), ' CIJs.']);
disp('  ');
end

%%
% Read tex of dat or ascii file
function [Cij, ComName, State] = Elastic_ReadTxt(filename, FileName)
% filename: The full filename for the file(With path).
% FileName: The filename without path.
% Cij: The elastic stiffness, 6x6xnum or 3x3xnum(num means the numbers of CIJ)
% ComName: The filename for output
% State: The state of reading.

%% Reading the file, and keep the words and save the numerical data into a tmp file
tmp_file = 'NumData.tmp';
fid = fopen(filename, 'r');
fid_num = fopen(tmp_file, 'w');
count_txt = 0;
while feof(fid) ~= 1
    fline = fgetl(fid);
    if sum(isspace(fline)) ~= length(fline)
        flag = 1;
        l_fline = length(fline);
        for i = 1:l_fline
            N_asc = abs(fline(i));
            if (N_asc>=65 && N_asc<=90) || (N_asc>=97 && N_asc<=122)
                flag = 0;
                break
            end
        end
        if flag == 1
            fprintf(fid_num, '%s\n', fline);
        elseif flag == 0
            count_txt = count_txt + 1;
            ComName(count_txt, 1) = {strtrim(fline)};
        end
    end
end
fclose(fid); fclose(fid_num);
%% judge the effectivity of the data
Cij_tmp = load(tmp_file);
delete(tmp_file);
if isempty(Cij_tmp)
    [Cij, ComName, State] = NoDataErr();
    return
end
n = size(Cij_tmp, 2);
if n ~= 6 && n ~= 3
    [Cij, ComName, State] = NoEffectiveDataErr();
    return
end
%% handles the data
Tot_lines = size(Cij_tmp, 1);
Extra_lines = mod(Tot_lines, n);
N_Cij = Tot_lines/n;
if Extra_lines
    N_Cij = floor(N_Cij);
    State = ExtraDataWarn(Extra_lines, n);
else
    State = 'OK';
end
if N_Cij == 0
    [Cij, ComName, State] = NoDataErr();
    return
end

Cij = zeros(n, n, N_Cij);
for j = 1:N_Cij
    row_start = n*(j - 1) + 1;
    row_end = n*j;
    Cij(:, :, j) = Cij_tmp(row_start:row_end, :);
end
ComName = cell(N_Cij, 1);
if count_txt == 0
    for i = 1:N_Cij
        ComName(i, 1) = {[FileName, '-', num2str(i)]};
    end
end
disp(['There are ', num2str(N_Cij), ' CIJs.']);
disp(' ');
end

%%
% Read xls or xlsx file
function [Cij, ComName, State] = Elastic_ReadExcel(filename, FileName)
% filename: The full filename for the file(With path).
% FileName: The filename without path.
% Cij: The elastic stiffness, 6x6xnum or 3x3xnum(num means the numbers of CIJ)
% ComName: The filename for output
% State: The state of reading.
count = 0;
[~, sheets] = xlsfinfo(filename);
n_sheets = length(sheets);
disp(['There are(is)', num2str(n_sheets), ' n_sheets.']);
for i = 1:n_sheets
    disp(['Reading the ', num2str(i), 'th sheet.']);
    sheeti = cell2mat(sheets(i));
    [num, txt] = xlsread(filename, sheeti);    
    %% judge effective
    if isempty(num)
        [Cij, ComName, State] = NoDataErr();
        return
    end
    n = size(num, 2);
    if n ~= 6 && n ~= 3
        [Cij, ComName, State] = NoEffectiveDataErr();
        return
    end
    %% 
    num(isnan(num)) = [];
    num = reshape(num, [], n); 
    Tot_lines = size(num, 1);
    Extra_lines = mod(Tot_lines, n);
    N_Cij = Tot_lines/n;
    if Extra_lines
        N_Cij = floor(N_Cij);
        State = ExtraDataWarn(Extra_lines, n);       
    else
        State = 'OK';
    end 
    if N_Cij == 0
        [Cij, ComName, State] = NoDataErr();
        return
    end
    disp(['There are ', num2str(N_Cij), ' CIJs.']);
    
    ComNametmp = cell(N_Cij, 1);
    if isempty(txt)  %No NAME in the input
        for k = 1:N_Cij
            ComNametmp(k) = {[FileName, '-', cell2mat(sheets(i)), '-', num2str(k)]};
        end
    else    %Read the Name from input, the first column
        ComNametmp = txt(:,1);
        Empty_index = zeros(1, length(ComNametmp));
        for k = 1:length(ComNametmp)
            if isempty(cell2mat(ComNametmp(k)))
                Empty_index(k) = k;
            end
        end
        Empty_index(Empty_index == 0) = [];
        ComNametmp(Empty_index) = [];
        ComName = ComNametmp(1:N_Cij);
    end
    
    for j = 1:N_Cij
        count = count + 1;
        row_start = n*(j - 1) + 1;
        row_end = n*j;
        Cij(:, :, count) = num(row_start:row_end, :);
        ComName(count, 1) = ComNametmp(j);
    end
    disp(' ');
%     disp(['End of reading the ', num2str(i), 'th sheet.']);
end
disp(['There are ', num2str(count), ' CIJs in this file.']);
disp(' ');
end

%%
% Error or warning sub subfunctions
function TipsForWarning()
disp('The format should be:');
disp('CIJ1Name(Optional)');
disp('CIJ1(6x6 or 3x3)');
disp('CIJ2Name(Optional)');
disp('CIJ2(The size is the same as CIJ1)');
disp('......');
disp('  ');
end

function [Cij, ComName, State] = NoDataErr()
n = 6;
State = 'There is NO DATA in this file.';
disp(State);
TipsForWarning();
Cij = zeros(n, n, 1);
ComName = {' '};
end

function [Cij, ComName, State] = NoEffectiveDataErr()
n = 6;
State = 'There is NO EFFECTIVE CIJ data in this file.';
disp(State);
TipsForWarning();
Cij = zeros(n, n, 1);
ComName = {' '};
end

function State = ExtraDataWarn(Extra_lines, n)
State = ['The row of data is not dividable by ', num2str(n), ...
    '. The last ', num2str(Extra_lines), ' lines are negnected.'];
disp(State);
TipsForWarning();
end