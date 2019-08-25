function flag = StableofMechanical(C)
%mechanical stability criteria 
[m, n] = size(C);
if m ~= n
    flag = 0;
    disp('This is not a effective CIJ, the row and column of CIJ must be EQUAL.')
    return 
elseif n == 6
    C_tmp = C(3:5, 3:5);
    if C_tmp == 0
        C = C([1, 2, 6], [1, 2, 6]);
    end
elseif n ~= 3
    flag = 0;
    disp('This is not a effective CIJ, The row and column must be 3 or 6');
    return
end
stable = eig(C);
if stable > 0
    flag = 1;
%     disp('The structure is STABLE.');
else
%     disp('The structure is UNSTABLE');
    flag = 0;
end
end