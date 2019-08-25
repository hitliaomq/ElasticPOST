function v = Poisson_4D(S, theta, phi, chi)
ax = sin(theta).*cos(phi);
ay = sin(theta).*sin(phi);
az = cos(theta);
bx = cos(theta).*cos(phi).*cos(chi) - sin(phi).*sin(chi);
by = cos(theta).*sin(phi).*cos(chi) + cos(phi).*sin(chi);
bz = -sin(theta).*cos(chi);
v_f = 0;
v_d = 0;
for i = 1:6
    switch i
        case 1
            vtmpi = ax.*ax;
        case 2
            vtmpi = ay.*ay;
        case 3
            vtmpi = az.*az;
        case 4
            vtmpi = ay.*az;
        case 5
            vtmpi = ax.*az;
        case 6
            vtmpi = ax.*ay;
    end
    for j = 1:6
        switch j
            case 1
                vtmpij_f = S(i,j)*vtmpi.*bx.*bx;
                vtmpij_d = S(i,j)*vtmpi.*ax.*ax;
            case 2
                vtmpij_f = S(i,j)*vtmpi.*by.*by;
                vtmpij_d = S(i,j)*vtmpi.*ay.*ay;
            case 3
                vtmpij_f = S(i,j)*vtmpi.*bz.*bz;
                vtmpij_d = S(i,j)*vtmpi.*az.*az;
            case 4
                vtmpij_f = S(i,j)*vtmpi.*by.*bz;
                vtmpij_d = S(i,j)*vtmpi.*ay.*az;
            case 5
                vtmpij_f = S(i,j)*vtmpi.*bx.*bz;
                vtmpij_d = S(i,j)*vtmpi.*ax.*az;
            case 6
                vtmpij_f = S(i,j)*vtmpi.*bx.*by;
                vtmpij_d = S(i,j)*vtmpi.*ax.*ay;
        end
        v_f = v_f + vtmpij_f;
        v_d = v_d + vtmpij_d;
    end
end
v = -v_f./v_d;
end

