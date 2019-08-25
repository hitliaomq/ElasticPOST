function Cij3 = D3toD2(Cij6)
n = size(Cij6, 1);
if n == 6
    Cij3 = Cij6([1, 2, 6], [1, 2, 6]);
end
end