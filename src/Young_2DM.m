function E = Young_2DM(S, phi)
% the size of S is 3x3 
x = cos(phi);
y = sin(phi);
S11 = S(1, 1); S12 = S(1, 2); S13 = S(1, 3);
S22 = S(2, 2); S23 = S(2, 3); S33 = S(3, 3);
E = 1./(S11*x.^4 + S22*y.^4 + (S33 + 2*S12)*x.^2.*y.^2 + 2*(S13*x.^3.*y + S23*x.*y.^3));
end