function [ img ] = getimg( record, listname, listdir, side, dim )
global famInd novInd famList novList intList intInd famRep intRep novBin novLib novReps;

trialnum = record.CurrentTrialNumber;
condnum = record.CurrentCondition;

novbins = 5;

listdir
if strcmp(listname, 'NovImgList')
	list = novList;
	ind = novInd + 1;
    disp('novlist');
    length(list)
    size(list)
    if ind > length(list)
        novBin = novBin + 1;
        novReps = novReps + 1;
        if novBin <= novbins
            novReps = [novReps, zeros(size(novLib(:, novBin)))'];
            list = [list, novLib(:, novBin)'];
        end
        neword = randperm(length(list));
        list = list(neword);
        novReps = novReps(neword);
        novList = list;
        ind = 1;
    end
	novInd = ind;
    rep = novReps(ind);
elseif strcmp(listname, 'FamImgList')
	list = famList;
	ind = famInd + 1;
    rep = famRep;
	if isempty(rep)
		rep = 0;
	end
	if ind > length(list)
		list = [];
		ind = [];
        rep = rep + 1;
	end
	famInd = ind;
    famRep = rep;
elseif strcmp(listname, 'IntImgList')
    list = intList;
    ind = intInd + 1;
    rep = intRep;
	if isempty(rep)
		rep = 0;
	end
    if ind > length(list)
        list = [];
        ind = [];
        rep = rep + 1;
    end
    intInd = ind;
    intRep = rep;
else
	disp('no list error');
end

imtypedir = strcat(listdir, '*.jpg');
fileList = dir(imtypedir);

if isempty(list)
	disp('doing new list');
	ind = 1;
    % numtrials = floor(length(fileList) / 2);
	numtrials = length(fileList);
    disp(numtrials)
    disp(fileList)
    disp(listdir)
    % samp = randsample(length(fileList), 2*numtrials);
    % list = reshape(samp, numtrials, 2);
	list = randperm(length(fileList));
    if strcmp(listname, 'NovImgList')
        novLib = reshape(list, [], novbins);
        novBin = 1;
		novList = novLib(:, novBin)';
        size(novList)
		novInd = ind;
        novReps = zeros(size(novList));
        rep = novReps(ind);
	elseif strcmp(listname, 'FamImgList')
		famList = list;
		famInd = ind;
    elseif strcmp(listname, 'IntImgList')
        intList = list;
        intInd = ind;
	else
		disp('no list error');
	end
end


disp(size(list));
disp(list);
ind
side
% list(ind, side);
list(ind)
% f = fileList(list(ind, side));
f = fileList(list(ind));
f
img = imread(strcat(listdir, f.name));

if dim
    img = img(:, :, :) - 100;
end

% record this
filepieces = textscan(record.DataFile, '%s', 'delimiter', '.');
if length(filepieces{1}) > 2
	imglogname = strcat(filepieces{1}{1:end-1, 1});
else
	imglogname = filepieces{1}{1, 1};
end
imglogfile = strcat(imglogname, '_imglog.txt');
imglogfile
log = fopen(imglogfile, 'a');
fprintf(log, '%d\t%d\t%d\t%d\t%d\t%s\t%s', trialnum, side, ...
    dim, condnum, rep, listname, f.name);
fprintf(log,'\r\n');
fclose(log);
end

