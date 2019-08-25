function ElasticPlot_2D_polar(Axes, S, n, flag, flag_plane, flag_save, Name)
% flag means B, E, G, v, H
%   Note: it need be cell type
% flag_plane means xy, xz, yz, all
%   Note: it need be cell type
t = 0:2*pi/n:2*pi;
for i = 1:length(flag)
    flagi = cell2mat(flag(i));
    ElasticPlot_2D_flag(Axes, S, t, flagi, flag_plane);
    axis equal
    if flag_save
        savename = [Name, '-', flagi '-2D.jpg'];
        saveas(gcf,savename);
%         close all;
    end
%     close all;
end
end

function ElasticPlot_2D_flag(Axes, S, t, flag_type, flag_plane)
flag_newfigure = 1;
if ismember('all', flag_plane)
    figure;
    flag_newfigure = 0;
    flag_plane = {'xy', 'xz', 'yz'};
end
count = 1;
flag_line = {'r--', 'b-.', 'g:'};
for i = 1:length(flag_plane)
    flag_planei = cell2mat(flag_plane(i));
    if flag_newfigure
        figure;
    end
    [theta, phi] = ElasticPlot_2D_plane(flag_planei, t);
    switch flag_type
        case 'B'
            V = Bulk_3D(S, theta, phi);
            title_fig = 'Bulk Modulus(GPa)';
        case 'E'
            V = Young_3D(S, theta, phi);
            title_fig = 'Young Modulus(GPa)';
        case 'G'
            [Vmin, V, Vmax] = Shear_3D(S, theta, phi);
            title_fig = 'Shear Modulus(GPa)';
        case 'v'
            [Vmin, V, Vmax] = Poisson_3D(S, theta, phi);
            title_fig = 'Poisson ratio';
        case 'H'
            V = Hardness_3D(S, theta, phi);
            title_fig = 'Hardness(GPa)';
        otherwise
    end
    flag_linei = cell2mat(flag_line(count));
    polarplot(t, V, flag_linei, 'LineWidth', 2);
    %     plot(V.*X, V.*Y, flag_linei, 'LineWidth',2);
    if flag_type == 'v' || flag_type == 'G'
        hold on
        polarplot(Axes, t, Vmin, flag_linei, 'LineWidth',2);
        polarplot(Axes, t, Vmax, flag_linei, 'LineWidth',2);
        hold off
    end
    title(title_fig);
    axis equal;
    count = count + 1;
    if ~flag_newfigure
        hold on
    end
end
legend(flag_plane)
end

function [theta, phi] = ElasticPlot_2D_plane(plane, t)
% plane = cell2mat(plane);
switch plane
    case 'xy'
        theta = pi/2*ones(size(t));
        phi = t;
    case 'yz'
        theta = t;
        phi = pi/2*ones(size(t));
    case 'xz'
        theta = t;
        phi = zeros(size(t));
end
end