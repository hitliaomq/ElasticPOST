function G = Shear_4D(S, theta, phi, chi)
ax = sin(theta).*cos(phi);
ay = sin(theta).*sin(phi);
az = cos(theta);
bx = cos(theta).*cos(phi).*cos(chi) - sin(phi).*sin(chi);
by = cos(theta).*sin(phi).*cos(chi) + cos(phi).*sin(chi);
bz = -sin(theta).*cos(chi);
G = 0;
for i = 1:6
    switch i
        case 1
            Gtmpi = ax.*bx;
        case 2
            Gtmpi = ay.*by;
        case 3
            Gtmpi = az.*bz;
        case 4
            Gtmpi = 0.5*(ay.*bz + az.*by);
        case 5
            Gtmpi = 0.5*(ax.*bz + az.*bx);
        case 6
            Gtmpi = 0.5*(ax.*by + ay.*bx);
    end
    for j = 1:6
        switch j
            case 1
                Gtmpij = S(i,j)*Gtmpi.*ax.*bx;
            case 2
                Gtmpij = S(i,j)*Gtmpi.*ay.*by;
            case 3
                Gtmpij = S(i,j)*Gtmpi.*az.*bz;
            case 4
                Gtmpij = 0.5*S(i,j)*Gtmpi.*(ay.*bz + az.*by);
            case 5
                Gtmpij = 0.5*S(i,j)*Gtmpi.*(ax.*bz + az.*bx);
            case 6
                Gtmpij = 0.5*S(i,j)*Gtmpi.*(ax.*by + ay.*bx);
        end
        G = G + Gtmpij;
    end
end
G = 1./G/4;
end