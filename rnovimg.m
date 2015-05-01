function [ img ] = rnovimg( record )
imgdir = getImgDir(0);
img = getimg(record, 'NovImgList', imgdir, 2, 0);
end

