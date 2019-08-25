function EPOST_UNINSTALL()
% ATTENTION:
% Please don't run this script in the src folder
p = mfilename('fullpath');
i = strfind(p, '\');
p = p(1:i(end));

rmpath(p);
rmdir(p, 's');
end