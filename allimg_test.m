function [out,TrialRecord] = allimg_test(TrialRecord)
global nimg allimgorder rep img_c 
%%
% nreps=100;

if isempty(allimgorder)
     if isempty(nimg)
        nreps=100;
        allimgorder = cell(nreps,1);
        for nr=1:nreps
            allimgorder{nr}=randperm(125);
        end
        nimg=1; rep=1; img_c = 1;              
        r = allimgorder{rep}(nimg);
        nimg=nimg+1;img_c = img_c+1;
    else
        r=allimgorder{rep}(nimg);
        nimg=nimg+1;img_c = img_c+1;
    end
else
%     allimgorder = TrialRecord.allimgorder;
    r = allimgorder{rep}(nimg);
    if r == allimgorder{rep}(end);
        rep=rep+1;nimg=1;img_c=img_c+1;  
        
    else
        nimg=nimg+1;img_c=img_c+1;
    end
end
  
% imgdir = 'C:\Anl\MonkeyLogic\tasks\Krithika_TEST\fam_images';
% imgdir = 'C:\Users\freedmanlab\Desktop\New folder\IF7';
imgdir = 'C:\anl\MonkeyLogic\Tasks\wjj\dim_and_look\images_30Apr2015';


startdir = cd;
cd(imgdir);
imgfiles = dir('*.jpg');
file = imgfiles(r);
img = imread(file.name);        
out=img;
cd(startdir);
