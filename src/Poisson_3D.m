function [vmin, vave, vmax] = Poisson_3D(S, theta, phi)
count = 1;
[m, n] = size(theta);
v = zeros(m, n, n);
for chi = -pi:2*pi/(n - 1):pi    
    v(:,:,count) = Poisson_4D(S, theta, phi, chi);
    count = count + 1;
end
vmin = zeros(m, n);
vmax = zeros(m, n);
vave = zeros(m,n);
for i = 1:m
    for j = 1:n
        vmin(i,j) = min(v(i,j,:));
        vmax(i,j) = max(v(i,j,:));
        vave(i,j) = sum(v(i,j,:))/n;
    end
end
end

