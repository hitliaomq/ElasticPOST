function SetAPNOn(handles)
% set CIJApply, Next, Previous and Propertyi on
set(handles.Next, 'Enable', 'on');
set(handles.Previous, 'Enable', 'on');
set(handles.CIJApply, 'Enable', 'on');
set(handles.Propertyi, 'Enable', 'on');
Propertyi = get(handles.Propertyi, 'Value');
if (Propertyi == 3) || (Propertyi == 4)
    set(handles.Planei, 'Enable', 'on');
else
    set(handles.Planei, 'Enable', 'off');
end
end