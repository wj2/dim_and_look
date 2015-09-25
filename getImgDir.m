function [ imgdir ] = getImgDir( type )
if type == 1
	imgdir = 'C:\anl\MonkeyLogic\Tasks\wjj\dim_and_look\famimgs\';
elseif type == 0
	imgdir = 'C:\anl\MonkeyLogic\Tasks\wjj\dim_and_look\novimgs\';
elseif type == 2
    imgdir = 'C:\anl\MonkeyLogic\Tasks\wjj\dim_and_look\intimgs\';
end
end

