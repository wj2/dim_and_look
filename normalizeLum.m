function [ imgpaths ] = normalizeLum( imgpaths, target )

for i = 1:length(imgpaths)
    p = imgpaths{i};
    img = imread(p);
    hsvimg = rgb2hsv(img);
    meanV = mean2(hsvimg(:, :, 3));
    meanV
    factor = target ./ meanV;
    hsvimg(:, :, 3) = hsvimg(:, :, 3) * factor;
    mean2(hsvimg(:, :, 3))
    rgbimg = hsv2rgb(hsvimg);
    
    filepieces = textscan(p, '%s', 'delimiter', '.');
    if length(filepieces{1}) > 2
        newfile = strcat(filepieces{1}{1:end-1, 1});
    else
        newfile = filepieces{1}{1, 1};
    end
    imwrite(rgbimg, strcat(newfile, '_lumnorm.png'), 'png');
end
end

