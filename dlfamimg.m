function [ img ] = dlfamimg( record )
imgdir = getImgDir(1);
img = getimg(record, 'FamImgList', imgdir, 1, 1);
end

