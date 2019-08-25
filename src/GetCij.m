function CIJ = GetCij(handles)
n = 6;
CIJ = zeros(n, n, 1);
for i = 1:6
    for j = 1:6
        h_cij = ['c', num2str(i), num2str(j)];
        eval(['CIJ(i, j) = str2num(get(handles.', h_cij, ',''String''));']);
    end
end
end