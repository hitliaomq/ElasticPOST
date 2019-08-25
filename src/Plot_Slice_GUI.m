function handles = Plot_Slice_GUI(handles, S, n, flag, slice_plane, flag_save, Name)
warning off
% flag means B, E, G, v, H
%   Note: it need be cell type
% flag_plane means xy, xz, yz, all
%   Note: it need be cell type
Axes = handles.Axes;
for i = 1:length(flag)
    flagi = cell2mat(flag(i));
    handles = ElasticPlot_2D_flag(handles, S, n, flagi, slice_plane);
    axis(Axes, 'equal', 'off')
    ViewAnyDir(handles, slice_plane);
    if flag_save
        savename = [Name, '-', flagi '-2D.jpg'];
        saveas(gcf,savename);
%         close all;
    end
%     close all;
end
end

function handles = ElasticPlot_2D_flag(handles, S, n, flag_type, slice_plane)
Title = handles.PlotTitle;
Axes = handles.Axes;
t = 0:2*pi/n:2*pi;

[X, Y, Z] = SlicePlane(t, slice_plane);

[theta, phi] = Direction2Ang(X, Y, Z);

PS_vpa = roundn(slice_plane, -2);  %plane_slice_vpa
% flag_line = {'r--', 'b-.', 'g:'};
Fig_legend = {['$', flag_type, '-[', num2str(PS_vpa(1)), '\ ', ...
    num2str(PS_vpa(2)), '\ ', num2str(PS_vpa(3)), ']$']};
%     if flag_newfigure
%         figure;
%     end
switch flag_type
    case 'B'
        V = Bulk_3D(S, theta, phi);
        V_Max = max(V);
        titlestr = 'Bulk Modulus(GPa)';
    case 'E'
        V = Young_3D(S, theta, phi);
        V_Max = max(V);
        titlestr = 'Young Modulus(GPa)';
    case 'G'
        [Vmin, V, Vmax] = Shear_3D(S, theta, phi);
        Fig_legend = {['$', flag_type, '_{ave}-[', num2str(PS_vpa(1)), '\ ', ...
    num2str(PS_vpa(2)), '\ ', num2str(PS_vpa(3)), ']$']};
        V_Max = max(Vmax);
        titlestr = 'Shear Modulus(GPa)';
    case 'v'
        [Vmin, V, Vmax] = Poisson_3D(S, theta, phi);
        Fig_legend = {['$', flag_type, '_{ave}-[', num2str(PS_vpa(1)), '\ ', ...
    num2str(PS_vpa(2)), '\ ', num2str(PS_vpa(3)), ']$']};
        V_Max = max(Vmax);
        V_Min = min(V);
        titlestr = 'Poisson ratio';
    case 'H'
        V = Hardness_3D(S, theta, phi);
        V_Max = max(V);
        titlestr = 'Hardness(GPa)';
    otherwise
end
handles.PlotTitleStr = titlestr;
handles.XS = X; handles.YS = Y; handles.ZS = Z; handles.VS = V;
%     flag_linei = cell2mat(flag_line(count));
% hold on
p = plot3(Axes, V.*X, V.*Y, V.*Z, 'r', 'LineWidth',2);
% hold off
if flag_type == 'v' || flag_type == 'G'
    hold on
    pmin = plot3(Axes, Vmin.*X, Vmin.*Y, Vmin.*Z, 'g--', 'LineWidth',2);
    pmax = plot3(Axes, Vmax.*X, Vmax.*Y, Vmax.*Z, 'b:', 'LineWidth',2);
    hold off
    Fig_legend(2) = {['$', flag_type, '_{min}-[', num2str(PS_vpa(1)), '\ ', ...
    num2str(PS_vpa(2)), '\ ', num2str(PS_vpa(3)), ']$']};
    Fig_legend(3) = {['$', flag_type, '_{max}-[', num2str(PS_vpa(1)), '\ ', ...
    num2str(PS_vpa(2)), '\ ', num2str(PS_vpa(3)), ']$']};
    p = [p, pmin, pmax];
end
% titlestr = [{titlestr}, {['[', num2str(PS_vpa(1)), ' ', ...
%     num2str(PS_vpa(2)), ' ', num2str(PS_vpa(3)), ']']}];
titlestr = [titlestr, '-[', num2str(PS_vpa(1)), ' ', ...
    num2str(PS_vpa(2)), ' ', num2str(PS_vpa(3)), ']'];
if strcmp(Title, 'on')
    title(Axes, titlestr);
else
    hTitle = findobj(Axes, 'String', titlestr);
    delete(hTitle);
end
axis equal;
%plot polar plt by hand
Xlim = get(gca, 'XLim');
%     Ylim = get(gca, 'YLim');
%     if max(Xlim) > max(Ylim)
%         r = get(gca, 'XTick');
%         Alim = max(Xlim);
%     else
%         r = get(gca, 'YTick');
%         Alim = max(Ylim);
%     end
r_x = get(gca, 'XTick');
r_y = get(gca, 'YTick');
r_z = get(gca, 'ZTick');
r_xmax = max(abs(r_x));
r_ymax = max(abs(r_y));
r_zmax = max(abs(r_z));
max_r = max([r_xmax, r_ymax, r_zmax]);
if max_r == r_xmax
    r = r_x;
elseif max_r == r_ymax
    r = r_y;
elseif max_r == r_zmax
    r = r_z;
end
r = r(ceil(length(r)/2):end);
Alim = max(r);
if V_Max > Alim
    dr = r(2) - r(1);
    Alim = ceil(V_Max/dr)*dr;
    r = 0:dr:Alim;
end
set(gca, 'XLim', 1.03*Alim*[-1, 1])
set(gca, 'YLim', 1.03*Alim*[-1, 1])

plotcircle(Axes, slice_plane, n, r);
plotlines(Axes, slice_plane, 12, Alim);

% if flag_type == 'v' || flag_type == 'G'
%     legend(Axes, p, Fig_legend, Fig_legend1, Fig_legend2, 'Interpreter', 'LaTex');
% else
% handles.PlotLegendStr = Fig_legend;
    % LegendOn = handles.PlotLegend;
    % if strcmp(LegendOn, 'on')
    %     legend(Axes, Fig_legend, 'Interpreter', 'LaTex', 'Location', 'best');
    %     legend('boxoff');
    % else
    %     hLegend = findobj(handles.Axes, 'Type', 'legend');
    %     delete(hLegend);
    % end
% end
% legend(p, Fig_legend, 'Interpreter', 'LaTex');
end

function plotcircle(Axes, slice_plane, n, r)
t = 0:2*pi/n:2*pi;

[X, Y, Z] = SlicePlane(t, slice_plane);

t_txt = 80/180*pi;
[X_txt, Y_txt, Z_txt] = SlicePlane(t_txt, slice_plane);
x_txt = 0.97*r*X_txt;
y_txt = 0.97*r*Y_txt;
z_txt = 0.97*r*Z_txt;
n_circle = length(r);
hold on
for i = 1:n_circle
    if i == n_circle
        plot3(Axes, r(i).*X, r(i).*Y, r(i).*Z, 'k', 'LineWidth', 0.5);
        text(x_txt(i), y_txt(i), z_txt(i), num2str(r(i)), 'FontSize', 10);
    else
        plot3(Axes, r(i).*X, r(i).*Y, r(i).*Z, 'k:', 'LineWidth', 0.5);
        text(x_txt(i), y_txt(i), z_txt(i), num2str(r(i)), 'FontSize', 10);
    end
    hold on
end
hold off
end

function plotlines(Axes, slice_plane, n, r)
t = 0:2*pi/n:2*pi;
t_d = t/pi*180;

[X, Y, Z] = SlicePlane(t, slice_plane);

X = r.*X;
Y = r.*Y;
Z = r.*Z;
coef = 1.03;
hold on
for i = 1:n
    plot3(Axes, [0, X(i)], [0, Y(i)], [0, Z(i)], 'k:', 'LineWidth', 0.5);
    if X(i) > 0
        Align = 'left';
    else
        Align = 'right';
    end
%     text(coef*X(i), coef*Y(i), num2str(t_d(i)), 'HorizontalAlignment', Align);
    hold on
end
hold off
end

function [X, Y, Z] = SlicePlane(t, slice_plane)
a = slice_plane(1);
b = slice_plane(2);
c = slice_plane(3);

X = c/sqrt(a^2+c^2)*cos(t) - a*b/sqrt((a^2+c^2)*(a^2+b^2+c^2))*sin(t);
Y = sqrt((a^2+c^2)/(a^2+b^2+c^2))*sin(t);
Z = -a/sqrt(a^2+c^2)*cos(t) - b*c/sqrt((a^2+c^2)*(a^2+b^2+c^2))*sin(t);
end