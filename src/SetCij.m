function SetCij(handles, Cij)
for i = 1:6
    for j = 1:6
        h_cij = ['c', num2str(i), num2str(j)];
        Cij_i = num2str(Cij(i, j));
        eval(['set(handles.', h_cij, ', ''String'',', Cij_i, ')']);
    end
end
end