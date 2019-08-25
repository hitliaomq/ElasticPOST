function E = Young_3D(S, theta, phi)
ax = sin(theta).*cos(phi);
ay = sin(theta).*sin(phi);
az = cos(theta);
% b = ();
E = zeros(size(ax));
for i = 1:6
    switch i
        case 1
            Etmpi = ax.*ax;
        case 2
            Etmpi = ay.*ay;
        case 3
            Etmpi = az.*az;
        case 4
            Etmpi = ay.*az;
        case 5
            Etmpi = ax.*az;
        case 6
            Etmpi = ax.*ay;
    end
    for j = 1:6
        switch j
            case 1
                Etmpij = S(i,j)*Etmpi.*ax.*ax;
            case 2
                Etmpij = S(i,j)*Etmpi.*ay.*ay;
            case 3
                Etmpij = S(i,j)*Etmpi.*az.*az;
            case 4
                Etmpij = S(i,j)*Etmpi.*ay.*az;
            case 5
                Etmpij = S(i,j)*Etmpi.*ax.*az;
            case 6
                Etmpij = S(i,j)*Etmpi.*ax.*ay;
        end
        E = E + Etmpij;
    end
end
E = 1./E;
end

