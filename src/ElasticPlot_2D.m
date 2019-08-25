function ElasticPlot_2D(S, n, flag, flag_plane, flag_save, Name)
warning off
% flag means B, E, G, v, H
%   Note: it need be cell type
% flag_plane means xy, xz, yz, all
%   Note: it need be cell type
for i = 1:length(flag)
    figure
    flagi = cell2mat(flag(i));
    ElasticPlot_2D_flag(S, n, flagi, flag_plane);
    axis equal
    axis off
    if flag_save
        savename = [Name, '-', flagi '-2D.jpg'];
        saveas(gcf,savename);
%         close all;
    end
%     close all;
end
end

function ElasticPlot_2D_flag(S, n, flag_type, flag_plane)
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
%     figure
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
%     flag_linei = cell2mat(flag_line(count));
    p = plot(V.*X, V.*Y, 'r', 'LineWidth',2);
    
    if flag_type == 'v' || flag_type == 'G'
        hold on
        pmin = plot(Vmin.*X, Vmin.*Y, 'g--', 'LineWidth',2);
        pmax = plot(Vmax.*X, Vmax.*Y, 'b:', 'LineWidth',2);
        hold off
        Fig_legend(2) = {['$', flag_type, '_{min}-', flag_planei, '$']};
        Fig_legend(3) = {['$', flag_type, '_{max}-', flag_planei, '$']};
        p = [p, pmin, pmax];        
    end  
    title(titlestr);
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
    
    plotcircle(n, r);
    plotlines(12, Alim);
    
    count = count + 1;
    if ~flag_newfigure
        hold on
    end
end
% if flag_type == 'v' || flag_type == 'G'
%     legend(Axes, p, Fig_legend, Fig_legend1, Fig_legend2, 'Interpreter', 'LaTex');
% else

legend(Fig_legend, 'Interpreter', 'LaTex', 'Location', 'northeastoutside');
legend('boxoff');
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

function plotcircle(n, r)
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
        plot(r(i).*X, r(i).*Y, 'k', 'LineWidth', 0.5);
        text(x_txt(i), y_txt(i), num2str(r(i)), 'FontSize', 10);
    else
        plot(r(i).*X, r(i).*Y, 'k:', 'LineWidth', 0.5);
        text(x_txt(i), y_txt(i), num2str(r(i)), 'FontSize', 10);
    end
    hold on
end
hold off
end

function plotlines(n, r)
t = 0:2*pi/n:2*pi;
t_d = t/pi*180;
X = r*cos(t);
Y = r*sin(t);
coef = 1.03;
hold on
for i = 1:n
    plot([0, X(i)], [0, Y(i)], 'k:', 'LineWidth', 0.5);
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