function [ img ] = rintimg( record )
imgdir = getImgDir(2);
img = getimg(record, 'IntImgList', imgdir, 2, 0);
end

