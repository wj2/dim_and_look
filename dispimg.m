function [out,TrialRecord] = dispimg(TrialRecord)
global allimgorder %rep
%%
nreps=40;
for tp=1:length(allimgorder)
    [out,TrialRecord]=allimg(TrialRecord);
end
        