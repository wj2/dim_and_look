function [cnum] = select_condition(TrialRecord)

dimOrLook = .8;
pdim=0.13;  
opposeOrSame = .2;

specialProb = 1.01;

prefSwitch = rand(1);
if prefSwitch < dimOrLook
    sameopp = rand(1);
    if sameopp < opposeOrSame
        cnum = randsample([8, 9], 1);
        ptrial = dimOrLook*opposeOrSame;
    else
        if specialProb > rand(1)
            % cnum  = 9;
			% cnum = randsample([9, 12, 13], 1);
			cnum = randsample([7, 10], 1);
            ptrial = specialProb*dimOrLook*(1 - opposeOrSame);
        else
            cnum = randsample([11, 12, 13, 14, 15], 1);
            ptrial = (1 - specialProb)*dimOrLook*(1 - opposeOrSame);
        end
    end
else
    ptrial = rand(1,5);
    dnum = find(ptrial<pdim);
    if length(dnum) > 1
        [~,cnum_ind] = min(ptrial(dnum));
        cnum = dnum(cnum_ind);
    elseif isempty(dnum)
        cnum=6;
    else cnum=dnum;
    end
end
TrialRecord.ProbTrial = ptrial;
end
