function test_slice()
n = 100;
slice_plane = [1, 2, 5];
t = 0:2*pi/n:2*pi;

a = slice_plane(1);
b = slice_plane(2);
c = slice_plane(3);

X = c/sqrt(a^2+c^2)*cos(t) - a*b/sqrt((a^2+c^2)*(a^2+b^2+c^2))*sin(t);
Y = sqrt((a^2+c^2)/(a^2+b^2+c^2))*sin(t);
Z = -a/sqrt(a^2+c^2)*cos(t) - b*c/sqrt((a^2+c^2)*(a^2+b^2+c^2))*sin(t);
[theta, phi] = Direction2Ang(X, Y, Z);
r = X.^2 + Y.^2 + Z.^2;
plot3(X, Y, Z)
axis(gca, 'equal')
view(gca, slice_plane);
end