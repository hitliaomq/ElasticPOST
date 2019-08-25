function [x, y, z] = Ang2Direction(theta, phi)
x = sin(theta).*cos(phi);
y = sin(theta).*sin(phi);
z = cos(theta);
end