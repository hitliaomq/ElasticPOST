function handles = ElasticPlot_2D_GUI(handles, S, n, flag, flag_plane, flag_save, Name)
warning off
% flag means B, E, G, v, H
%   Note: it need be cell type
% flag_plane means xy, xz, yz, all
%   Note: it need be cell type
Axes = handles.Axes;
for i = 1:length(flag)
    flagi = cell2mat(flag(i));
    handles = ElasticPlot_2D_flag(handles, S, n, flagi, flag_plane);
    axis(Axes, 'equal', 'off')
    if flag_save
        savename = [Name, '-', flagi '-2D.jpg'];
        saveas(gcf,savename);
%         close all;
    end
%     close all;
end
end

function handles = ElasticPlot_2D_flag(handles, S, n, flag_type, flag_plane)
Title = handles.PlotTitle;
Axes = handles.Axes;
t = 0:2*pi/n:2*pi;
X = cos(t);
Y = sin(t);
flag_newfigure = 1;
if ismember('all', flag_plane)
%     figure;
    flag_newfigure = 0;
    flag_plane = {'xy', 'xz', 'yz'};
end
count = 1;
% flag_line = {'r--', 'b-.', 'g:'};
for i = 1:length(flag_plane)
    flag_planei = cell2mat(flag_plane(i));
    Fig_legend = {['$', flag_type, '-', flag_planei, '$']};
%     if flag_newfigure
%         figure;
%     end
    [theta, phi] = ElasticPlot_2D_plane(flag_planei, t);
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
            Fig_legend = {['$', flag_type, '_{ave}-', flag_planei, '$']};
            V_Max = max(Vmax);
            titlestr = 'Shear Modulus(GPa)';
        case 'v'
            [Vmin, V, Vmax] = Poisson_3D(S, theta, phi);
            Fig_legend = {['$', flag_type, '_{ave}-', flag_planei, '$']};
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
    handles.X = X; handles.Y = Y; handles.V = V;
%     flag_linei = cell2mat(flag_line(count));
    p = plot(Axes, V.*X, V.*Y, 'r', 'LineWidth',2);
    
    if flag_type == 'v' || flag_type == 'G'
        hold on
        pmin = plot(Axes, Vmin.*X, Vmin.*Y, 'g--', 'LineWidth',2);
        pmax = plot(Axes, Vmax.*X, Vmax.*Y, 'b:', 'LineWidth',2);
        hold off
        Fig_legend(2) = {['$', flag_type, '_{min}-', flag_planei, '$']};
        Fig_legend(3) = {['$', flag_type, '_{max}-', flag_planei, '$']};
        p = [p, pmin, pmax];        
    end  
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
    r = get(gca, 'XTick');    
    r = r(ceil(length(r)/2):end);
    Alim = max(r);
    if V_Max > Alim
        dr = r(2) - r(1);
        Alim = ceil(V_Max/dr)*dr;
        r = 0:dr:Alim;
    end
    set(gca, 'XLim', 1.03*Alim*[-1, 1])
    set(gca, 'YLim', 1.03*Alim*[-1, 1])
    
    plotcircle(Axes, n, r);
    plotlines(Axes, 12, Alim);
    
    count = count + 1;
    if ~flag_newfigure
        hold on
    end
end
% if flag_type == 'v' || flag_type == 'G'
%     legend(Axes, p, Fig_legend, Fig_legend1, Fig_legend2, 'Interpreter', 'LaTex');
% else
handles.PlotLegendStr = Fig_legend;
LegendOn = handles.PlotLegend;
if strcmp(LegendOn, 'on')
    legend(Axes, Fig_legend, 'Interpreter', 'LaTex', 'Location', 'best');
    legend('boxoff');
else
    hLegend = findobj(handles.Axes, 'Type', 'legend');
    delete(hLegend);
end
% end
% legend(p, Fig_legend, 'Interpreter', 'LaTex');
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

function plotcircle(Axes, n, r)
t = 0:2*pi/n:2*pi;
X = cos(t);
Y = sin(t);
t_txt = 80/180*pi;
x_txt = 0.97*r*cos(t_txt);
y_txt = 0.97*r*sin(t_txt);
n_circle = length(r);
hold on
for i = 1:n_circle
    if i == n_circle
        plot(Axes, r(i).*X, r(i).*Y, 'k', 'LineWidth', 0.5);
        text(x_txt(i), y_txt(i), num2str(r(i)), 'FontSize', 10);
    else
        plot(Axes, r(i).*X, r(i).*Y, 'k:', 'LineWidth', 0.5);
        text(x_txt(i), y_txt(i), num2str(r(i)), 'FontSize', 10);
    end
    hold on
end
hold off
end

function plotlines(Axes, n, r)
t = 0:2*pi/n:2*pi;
t_d = t/pi*180;
X = r*cos(t);
Y = r*sin(t);
coef = 1.03;
hold on
for i = 1:n
    plot(Axes, [0, X(i)], [0, Y(i)], 'k:', 'LineWidth', 0.5);
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