function ElasticPlot_3D(S, n, flag, flag_amm, flag_save, Name)
% flag means B, E, G, v, H
% flag_amm ave or max or min
% Note: it need be cell type

[theta,phi] = meshgrid(0:pi/n:pi, -pi:2*pi/n:pi);
for i = 1:length(flag)
    figure;
    flagi = cell2mat(flag(i));
    %     lighting none
    ElasticPlot_3D_flag(S, theta, phi, flagi, flag_amm);
    
    colormap jet;
    colorbar
%     caxis([210, 250]);
    box on
    axis equal
    axis off
    light('Position', [-1, -1, 1]);
    material shiny

    if flag_save
        savename = [Name, '-', flagi '-3D.jpg'];
        saveas(gcf,savename);
        %         close all;
    end
    %     close all;
end
end

function ElasticPlot_3D_flag(S, theta, phi, flag_type, flag_amm)
X = sin(theta).*cos(phi);
Y = sin(theta).*sin(phi);
Z = cos(theta);
[row_x, col_x] = size(X);
% figure;
switch flag_type
    case 'B'
        V = Bulk_3D(S, theta, phi);
        titlestr = 'Bulk Modulus(GPa)';
    case 'E'
        V = Young_3D(S, theta, phi);
        titlestr = 'Young Modulus(GPa)';
    case 'G'
        [Vmin, Vave, Vmax] = Shear_3D(S, theta, phi);
        if strcmpi(flag_amm, 'Ave')
            V = Vave;
        elseif strcmpi(flag_amm, 'Min')
            V = Vmin;
        elseif strcmpi(flag_amm, 'Max')
            V = Vmax;   
        elseif strcmpi(flag_amm, 'All')
            V = zeros(row_x, col_x, 3);
            V(:, :, 1) = Vmin;
            V(:, :, 2) = Vave;
            V(:, :, 3) = Vmax;
        end
        titlestr = 'Shear Modulus(GPa)';
    case 'v'
        [Vmin, Vave, Vmax] = Poisson_3D(S, theta, phi);
        if strcmpi(flag_amm, 'Ave')
            V = Vave;
        elseif strcmpi(flag_amm, 'Min')
            V = Vmin;
        elseif strcmpi(flag_amm, 'Max')
            V = Vmax;  
        elseif strcmpi(flag_amm, 'All')
            V = zeros(row_x, col_x, 3);
            V(:, :, 1) = Vmin;
            V(:, :, 2) = Vave;
            V(:, :, 3) = Vmax;
        end
        titlestr = 'Poisson ratio';
    case 'H'
        V = Hardness_3D(S, theta, phi);
        titlestr = 'Hardness(GPa)';
    otherwise
end
handles.PlotTitleStr = titlestr;
handles.X = X; handles.Y = Y;
handles.Z = Z; handles.V = V;

n_V = size(V, 3);
Transport = [1, 0.7, 0.4];
for i = 1:n_V
    Vtmp = V(:, :, i);
    if i > 1
        hold on
    end
    surf(Vtmp.*X, Vtmp.*Y, Vtmp.*Z, Vtmp, ...
        'MeshStyle','none', 'FaceColor', 'interp', 'FaceAlpha', Transport(i));
end
title(titlestr);
hold off
end