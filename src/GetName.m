function Name = GetName(handles)
PlotType = get(handles.Plot3D, 'Value');
if PlotType == 1
    Name1 = '3D-';
else
    Name1 = '2D-';
end
ProperStr = get(handles.Propertyi, 'String');
ProperVal = get(handles.Propertyi, 'Value');
ProperName = [cell2mat(ProperStr(ProperVal)), '-'];
PlaneEn = get(handles.Planei, 'Enable');
if strcmp(PlaneEn, 'on')
    PlaneStr = get(handles.Planei, 'String');
    PlaneVal = get(handles.Planei, 'Value');
    PlaneName = [cell2mat(PlaneStr(PlaneVal)), '-'];
else
    PlaneName = '';
end
Name = [Name1, ProperName, PlaneName];
end