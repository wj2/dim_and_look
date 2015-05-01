function [ img ] = lfamimg( record )
imgdir = getImgDir(true);
img = getimg(record, 'FamImgList', imgdir, 1, 0);
end

