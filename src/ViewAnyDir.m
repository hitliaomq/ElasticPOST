function handles = ViewAnyDir(handles, direction)
view(handles.Axes, direction);
delete(handles.Light);
Light = light(handles.Axes, 'Position', direction);
handles.Light = Light;
end