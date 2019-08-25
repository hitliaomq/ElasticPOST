function B = Bulk_3D(S, theta, phi)
ax = sin(theta).*cos(phi);
ay = sin(theta).*sin(phi);
az = cos(theta);
% b = ();
B = zeros(size(ax));
for i = 1:6
    for j = 1:3
        switch i
            case 1
                Btmp = S(i,j)*ax.*ax;
            case 2
                Btmp = S(i,j)*ay.*ay;
            case 3
                Btmp = S(i,j)*az.*az;
            case 4
                Btmp = S(i,j)*ay.*az;
            case 5
                Btmp = S(i,j)*ax.*az;
            case 6
                Btmp = S(i,j)*ax.*ay;
        end
        B = B + Btmp;
    end
end
B = 1/3./B;
end