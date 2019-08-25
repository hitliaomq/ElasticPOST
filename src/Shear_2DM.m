function G = Shear_2DM(S, phi)
% the size of S is 3x3 
x = cos(phi);
y = sin(phi);
S11 = S(1, 1); S12 = S(1, 2); S13 = S(1, 3);
S22 = S(2, 2); S23 = S(2, 3); S33 = S(3, 3);
G0 = (S11 + S12 - 2*S12 + S33)/8;
rG = 0.25*(0.25*(S33 + 2*S12 - S11 - S22)^2 + (S23 - S13)^2)^(1/2);
phiG = atan(2*(S13 - S23)/(S33 + 2*S12 - S11 - S22));
G = 0.25./(G0 + rG*cos(4*phi + phiG));
% G = 0.25./((S11 + S22 - 2*S12)*x.^2.*y.^2 + S33*(x.^2 - y.^2).^2/4 ...
%     + (S23 - S13)*x.*y.*(x.^2 - y.^2));
end