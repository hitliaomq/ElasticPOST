function setup_ElasticPOST()
% matlabroot
MATLABROOT = matlabroot;
RelPath = '\toolbox\user\ElasticPOST';
fullpath = [MATLABROOT, RelPath];
if ~exist(fullpath, 'dir')
    mkdir(fullpath);
end
% copy files and folders

% set path
% addpath
% genpath
% rmpath
end