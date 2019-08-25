function Cij6 = D2toD3(Cij3)
[m, ~] = size(Cij3);
Cij6 = zeros(2*m, 6);
for i = 1:floor(m/3)
    Cij6((i-1)*6+[1, 2, 6], [1, 2, 6]) = Cij3((i-1)*3+[1, 2, 3], 1:3);
end
end