function [ img ] = drfamimg( record )
imgdir = getImgDir(1);
img = getimg(record, 'FamImgList', imgdir, 2, 1);
end

