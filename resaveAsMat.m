function [ newp ] = resaveAsMat( bhvpath )
filepieces = textscan(bhvpath, '%s', 'delimiter', '.');
if length(filepieces{1}) > 2
    newfile = strcat(filepieces{1}{1:end-1, 1});
else
    newfile = filepieces{1}{1, 1};
end
newp = strcat(newfile, '.mat');
bhv = bhv_read(bhvpath);
save(newp, 'bhv');
end

