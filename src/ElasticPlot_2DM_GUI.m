function handles = ElasticPlot_2DM_GUI(handles, S, n, flag, flag_save, Name)
% S is 3x3
Axes = handles.Axes;
S = D3toD2(S);
for i = 1:length(flag)
    flagi = cell2mat(flag(i));
    handles = ElasticPlot_2D_flag(handles, S, n, flagi);
    axis(Axes, 'equal', 'off')
    if flag_save
        savename = [Name, '-', flagi '-2D.jpg'];
        saveas(gcf,savename);
%         close all;
    end
%     close all;
end
end

function handles = ElasticPlot_2D_flag(handles, S, n, flag_type)
Axes = handles.Axes;
phi = 0:2*pi/n:2*pi;
X = cos(phi);
Y = sin(phi);
% flag_line = {'r--', 'b-.', 'g:'};
    switch flag_type
        case 'E'
            V = Young_2DM(S, phi);
            V_Max = max(V);
            title_fig = 'Young Modulus(GPa)';
        case 'G'
            V = Shear_2DM(S, phi);
            V_Max = max(V);
            title_fig = 'Shear Modulus(GPa)';
        case 'v'
            V = Poisson_2DM(S, phi);
            V_Max = max(V);
            title_fig = 'Poisson ratio';
        otherwise
    end
    V_Max = max(V);
%     V_Min = min(V)
    Vneg = zeros(size(V));
    Vneg(V<0) = V(V<0);
    Vpos = V - Vneg;
    %     flag_linei = cell2mat(flag_line(count));
    if sum(Vneg) == 0
        p = plot(Axes, V.*X, V.*Y, 'r', 'LineWidth',2);
    else
        p1 = plot(Axes, Vpos.*X, Vpos.*Y, 'r', 'LineWidth', 2);
        hold on
        p2 = plot(Axes, Vneg.*X, Vneg.*Y, 'g-.', 'LineWidth', 2);
        hold off
    end
    TitleOn = handles.PlotTitle;
    handles.X = X; handles.Y = Y; handles.V = V;
    if strcmp(TitleOn, 'on')
        title(title_fig);
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
    
    Fig_legend = {['$', flag_type, '$']};
    handles.PlotTitleStr = title_fig;
    handles.PlotLegendStr = Fig_legend;
    LegendOn = handles.PlotLegend;
    if strcmp(LegendOn, 'on')
        legend(Axes, Fig_legend, 'Interpreter', 'LaTex', 'Location', 'best');
        legend('boxoff');
    else
        hLegend = findobj(handles.Axes, 'Type', 'legend');
        delete(hLegend);
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
