function output = ElasticVRH3D(C)
% VRH
% 10.1088/0370-1298/65/5/307

% Marmier A, Lethbridge ZAD, Walton RI, Smith CW, Parker SC, Evans KE. (2010). 
% COMPUTER PHYSICS COMMUNICATIONS, 
% http://doi.org/10.1016/j.cpc.2010.08.033
% 
% XY X means properties, B, G, E, H, v, B/G
%    Y means approximation, V Viogt, R Reuss, H Hill, A for anisotropy
flag = StableofMechanical(C);
output = zeros(8, 6);
if ~flag
    return
end
S = inv(C);
Ca = (C(1,1) + C(2,2) + C(3,3))/3;
Cb = (C(1,2) + C(2,3) + C(1,3))/3;
Cc = (C(4,4) + C(5,5) + C(6,6))/3;
Sa = (S(1,1) + S(2,2) + S(3,3))/3;
Sb = (S(1,2) + S(2,3) + S(1,3))/3;
Sc = (S(4,4) + S(5,5) + S(6,6))/3;

% for Voigt
BV = (Ca + 2*Cb)/3;
GV = (Ca - Cb + 3*Cc)/5;

% for Reuss
BR = 1./(3*Sa + 6*Sb);
GR = 5./(4*Sa - 4*Sb + 3*Sc);

% for Hill
BH = (BV + BR)/2;
GH = (GV + GR)/2;

% for Young's modulus and Pooisson's ratio
EV = Young(GV, BV);
ER = Young(GR, BR);
EH = Young(GH, BH);
vV = Poisson(GV, BV);
vR = Poisson(GR, BR);
vH = Poisson(GH, BH);

%for B2G
B2GV = BV./GV;
B2GR = BR./GR;
B2GH = BH./GH;

% for anisotropy
% http://doi.org/10.1063/1.368733
BA = abs((BV - BR)./(BV + BR));
GA = abs((GV - GR)./(GV + GR));
EA = abs((EV - ER)./(EV + ER));
vA = abs((vV - vR)./(vV + vR));
B2GA = abs((B2GV - B2GR)./(B2GV + B2GR));

%for Hardness
% http://doi.org/10.1016/j.ijrmhm.2012.02.021
% HV = 0.92*k^1.137*G^0.708
HV = Hardness(EV, BV);
HR = Hardness(ER, BR);
HH = Hardness(EH, BH);
HA = (HV - HR)./(HV + HR);

HCV = Hardness(EV, BV, 'c');
HCR = Hardness(ER, BR, 'c');
HCH = Hardness(EH, BH, 'c');
HCA = (HCV - HCR)./(HCV + HCR);

HTV = Hardness(EV, BV, 't');
HTR = Hardness(ER, BR, 't');
HTH = Hardness(EH, BH, 't');
HTA = (HTV - HTR)./(HTV + HTR);

AU = AnisotropyU(BV, BR, GV, GR);
AL = AnisotropyL(BV, BR, GV, GR);

output = [BV, BR, BH, BA, AU, AL; GV, GR, GH, GA, AU, AL; EV, ER, EH, EA, AU, AL;...
    HV, HR, HH, HA, AU, AL; HCV, HCR, HCH, HCA, AU, AL; HTV, HTR, HTH, HTA, AU, AL;...
    vV, vR, vH, vA, AU, AL; B2GV, B2GR, B2GH, B2GA, AU, AL];

end

function E = Young(G, B)
E = 1./(1./(3*G) + 1./(9*B));
end

function v = Poisson(G, B)
v = 0.5*(1 - 3*G./(3*B + G));
end

function AU = AnisotropyU(BV, BR, GV, GR)
% 10.1103/PhysRevLett.101.055504
AU = 5*GV./GR + BV./BR - 6;
end

function AL = AnisotropyL(BV, BR, GV, GR)
% https://doi.org/10.1063/1.4962996
AL = sqrt((log(BV./BR)).^2 + 5*(log(GV./GR)).^2);
end
