function SetAPNOff(handles)
% set CIJApply, Next, Previous and Propertyi off
set(handles.Propertyi, 'Enable', 'off');
set(handles.Next, 'Enable', 'off');
set(handles.Previous, 'Enable', 'off');
set(handles.CIJApply, 'Enable', 'off');
set(handles.Planei, 'Enable', 'off');
end