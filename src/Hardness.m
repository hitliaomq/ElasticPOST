function H = Hardness(E, B, flag)
% http://doi.org/10.1016/j.ijrmhm.2012.02.021
% HV = 0.92*k^1.137*G^0.708        (k = G/B)
% k = G./B;
% Tian 2012
% H = 0.92*k.^(1.137).*G.^(0.708);
% Chen 2011
% H = 2*(G.*k.^2).^0.585 - 3;
% Myself
% H = 0.786835118497608*G.^(0.7343).*k.^1.01993441066304;
% B AND E
switch nargin
    case 3
        flag = lower(flag);
        G = 1./(1./E - 1./(9*B))/3;
        k = G./B;
        switch flag
            case 'c'
                H = 2*(G.*k.^2).^0.585 - 3;
            case 't'
                H = 0.92*k.^(1.137).*G.^(0.708);
        end
    otherwise
        H = 0.130548175274347*E.^(2.2484942942017).*B.^(-1.51675853808829);
end
end