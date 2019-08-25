function [theta, phi] = Direction2Ang(x, y, z)
% direction
theta = acos(z./sqrt(x.^2 + y.^2 + z.^2));
phi = acos(x./sqrt(x.^2 + y.^2));
phi(y < 0) = 2*pi - phi(y < 0);
phi(x == 0 & y == 0) = 0;
% [m, n] = size(phi);
% % phi = zeros(m, n);
% for i = 1:m
%     for j = 1:n
%         if x(i, j) < 1e-13 && y(i, j) < 1e-13
%             phi(i, j) = 0;
%         else
%             phi(i, j) = acos(x(i, j)/sqrt(x(i, j).^2 + y(i, j).^2));
%         end
%         if y(i, j) < 0
%             phi(i, j) = 2*pi - phi(i, j);
%         end
%     end
% end
end