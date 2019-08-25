function EPOST_INSTALL(path)
switch nargin
    case 1
        dst_dir = path;
    case 0
        dst_dir = [matlabroot, '\toolbox\ElasticPOST'];
    otherwise
        
        disp('ERROR: The number of input is not correct.');
        return
end
if ~exist(dst_dir, 'dir')
end
copyfile('./*.m', dst_dir);
copyfile('./*.fig', dst_dir);
copyfile('./*.mat', dst_dir);
copyfile('./Logo2.png', dst_dir);

addpath(dst_dir);
end