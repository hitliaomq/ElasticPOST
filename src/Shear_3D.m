function [Gmin, Gave, Gmax] = Shear_3D(S, theta, phi)
count = 1;
[m, n] = size(theta);
G = zeros(m, n, n);
for chi = -pi:2*pi/(n - 1):pi    
    G(:,:,count) = Shear_4D(S, theta, phi, chi);
    count = count + 1;
end
Gmin = zeros(m,n);
Gmax = zeros(m,n);
Gave = zeros(m,n);
for i = 1:m
    for j = 1:n
        Gmin(i,j) = min(G(i,j,:));
        Gmax(i,j) = max(G(i,j,:));
        Gave(i,j) = sum(G(i,j,:))/n;
    end
end
end

