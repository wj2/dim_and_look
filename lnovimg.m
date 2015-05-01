function [ img ] = lnovimg( record )
imgdir = getImgDir(0);
img = getimg(record, 'NovImgList', imgdir, 1, 0);
end

