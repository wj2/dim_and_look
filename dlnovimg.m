function [ img ] = dlnovimg( record )
imgdir = getImgDir(0);
img = getimg(record, 'NovImgList', imgdir, 1, 1);
end

