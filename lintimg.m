function [ img ] = lintimg( record )
imgdir = getImgDir(2);
img = getimg(record, 'IntImgList', imgdir, 1, 0);
end

