function [ img ] = drnovimg( record )
imgdir = getImgDir(0);
img = getimg(record, 'NovImgList', imgdir, 2, 1);
end

