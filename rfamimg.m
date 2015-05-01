function [ img ] = rfamimg( record )
imgdir = getImgDir(1);
img = getimg(record, 'FamImgList', imgdir, 2, 0);
end

