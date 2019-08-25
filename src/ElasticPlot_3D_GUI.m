function handles = ElasticPlot_3D_GUI(handles, S, n, flag, flag_amm, flag_save, Name)
% flag means B, E, G, v, H
% flag_amm ave or max or min
% Note: it need be cell type
Axes = handles.Axes;
ColorMap = handles.PlotColorMap;
View = handles.PlotView;
ColorBar = handles.PlotColorBar;
ColorBarMode = handles.PlotColarBarMode;
ColorBarCmin = handles.PlotColarBarCmin;
ColorBarCmax = handles.PlotColarBarCmax;

[theta,phi] = meshgrid(0:pi/n:pi, -pi:2*pi/n:pi);
for i = 1:length(flag)
    flagi = cell2mat(flag(i));
    %     lighting none
    handles = ElasticPlot_3D_flag(handles, S, theta, phi, flagi, flag_amm);
    colormap(Axes, ColorMap)
    if strcmpi(ColorBarMode(1), 'A')
        if strcmp(ColorBar, 'on')
            colorbar(Axes, 'Location','eastoutside');
        else
            hColorBar = findobj(handles.Axes, 'Type', 'colorbar');
            delete(hColorBar);
        end
        caxis auto
    elseif strcmpi(ColorBarMode(1), 'M')
        caxis([ColorBarCmin, ColorBarCmax])
    end    
%     if strcmp(ColorBar, 'on')
%         colorbar(Axes, 'Location','eastoutside');
% %         caxis([210, 250]);
%     else
%         hColorBar = findobj(handles.Axes, 'Type', 'colorbar');
%         delete(hColorBar);
%     end
    box(Axes, 'on');
    axis(Axes, 'equal', 'off')
    view(Axes, View);
    %     axis off
    %     camlight; lighting phong;
    Light = light(Axes, 'Position', View);
    material shiny
    if flag_save
        savename = [Name, '-', flagi '-3D.jpg'];
        saveas(gcf,savename);
        %         close all;
    end
    handles.Light = Light;
    %     close all;
end
end

function handles = ElasticPlot_3D_flag(handles, S, theta, phi, flag_type, flag_amm)
Title = handles.PlotTitle;
Axes = handles.Axes;
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
        if strcmp(flag_amm, 'Ave')
            V = Vave;
        elseif strcmp(flag_amm, 'Min')
            V = Vmin;
        elseif strcmp(flag_amm, 'Max')
            V = Vmax;   
        elseif strcmp(flag_amm, 'All')
            V = zeros(row_x, col_x, 3);
            V(:, :, 1) = Vmin;
            V(:, :, 2) = Vave;
            V(:, :, 3) = Vmax;
        end
        titlestr = 'Shear Modulus(GPa)';
    case 'v'
        [Vmin, Vave, Vmax] = Poisson_3D(S, theta, phi);
        if strcmp(flag_amm, 'Ave')
            V = Vave;
        elseif strcmp(flag_amm, 'Min')
            V = Vmin;
        elseif strcmp(flag_amm, 'Max')
            V = Vmax;  
        elseif strcmp(flag_amm, 'All')
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
    surf(Axes, Vtmp.*X, Vtmp.*Y, Vtmp.*Z, Vtmp, ...
        'MeshStyle','none', 'FaceColor', 'interp', 'FaceAlpha', Transport(i));
end
if strcmp(Title, 'on')
    title(Axes, titlestr);
else
    hTitle = findobj(Axes, 'String', titlestr);
    delete(hTitle);
end
hold off
end