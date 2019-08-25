function v = Poisson_2DM(S, phi)
% the size of S is 3x3 
x = cos(phi);
y = sin(phi);
E = Young_2DM(S, phi);
S11 = S(1, 1); S12 = S(1, 2); S13 = S(1, 3);
S22 = S(2, 2); S23 = S(2, 3); S33 = S(3, 3);
v0 = ((S11 + S22 - S33)/2 + 3*S12)/4;
rv = sqrt((S23 - S13)^2 + (S12 - (S11 + S22 - S33)/2)^2)/4;
phiv = atan((S23 - S13)/(S12 - (S11 + S22 - S33)/2));
v = -E.*(v0 + rv*cos(4*phi + phiv));
% v = E.*((S11 + S22 - S33)*x.^2.*y.^2 + S12*(x.^4 + y.^4) + ...
%     (S13 - S23)*(x.*y.^3 - y.*x.^3));
end