%dimming task
%monkey must hold through image and release the bar when it dims

editable('min_hold_time', 'max_hold_time', 'reward_duration', 'num_rewards','fix_window_radius');
global nimg allimgorder rep allC img_c

nto=length(TrialRecord.CurrentConditionStimulusInfo); %finds the number of task objects in this particular condition

cc = TrialRecord.CurrentCondition;

if ~isfield(TrialRecord,'allimgorder')
    TrialRecord.allimgorder = allimgorder;
end

allC = {horzcat(allimgorder{:})};
allC = reshape(allC{:}.',[],1);

if ismember(cc,1:5)
    img_index = allC((img_c-cc):(img_c-1));
    on_codes = allC((img_c-cc):(img_c-1)) + 55;
%     off_codes = on_codes +100;
else
    img_index = allC((img_c-(cc-1)):(img_c-1));
    on_codes = allC((img_c-(cc-1)):(img_c-1)) + 55;
%     off_codes = on_codes + 100;
end

user_text(sprintf('Repetition %i',rep));
user_text(sprintf('Image counter - in rep %i',nimg));
user_text(sprintf('%d ',on_codes));
user_text(sprintf('Image counter %i',img_c));

%storing variables as bhv_variables
bhv_variable('on_codes',on_codes);
% bhv_variable('of_codes',off_codes);
bhv_variable('img_index',img_index);
bhv_variable('repetition',rep);
bhv_variable('trial_order',allimgorder{rep}(1:125));
if length(allimgorder{rep})>125 && length(allimgorder{rep})<253
    bhv_variable('trial_errororder',allimgorder{rep}(126:end));
end

%defining time intervals
wait_for_touch = 10000;
min_hold_time = 400;
max_hold_time = 450;
reward_duration = 120;
num_rewards = 1;    
fix_time = 500;
fix_window_radius = 2.5;
wait_for_fix = 5000;
pause(.06); % added additional pause of ~60ms to ensure that enough eye data is collected for drift routine

[ontarget, rt] = eyejoytrack('acquiretouch', 1, 3.0,wait_for_touch);

if ~ontarget,
    trialerror(1); %no touch
    rt=NaN;
    return
end
eventmarker(7);  % bar down (hold)

toggleobject(1,'eventmarker',35); %fixation spot on

[ontarget, rt] = eyejoytrack('holdtouch', 1, 3.0, 'acquirefix', 1, fix_window_radius, wait_for_fix);

if ~ontarget(1) % if lever break 
    trialerror(5); %lever break ->>> EARLY RESPONSE? WAS 2
    eventmarker(4); %bar up (release)
    rt=NaN;
    toggleobject(1,'eventmarker',36); % turn off fixation spot
    return
elseif ~ontarget(2) 
    trialerror(4); %no fixation
    rt=NaN;
    toggleobject(1,'eventmarker',36); % turn off fixation spot
    return
end
eventmarker(8); %fixation occurs

[ontarget, rt] = eyejoytrack('holdtouch', 1, 3.0, 'holdfix', 1, fix_window_radius, fix_time);

if ~ontarget(1)
    trialerror(5); %early ->>> EARLY RESPONSE? WAS 2
    eventmarker(4); %bar up (release)
    if ismember(cc,1:5)
        nimg_unseen = (nto-2);
    else
        nimg_unseen = (nto-1);
    end
    allimgorder{rep} = [allimgorder{rep} allC((img_c-nimg_unseen):(img_c-1))'];
    toggleobject(1,'eventmarker',36); % turn off fixation spot
    rt=NaN;
    return
elseif ~ontarget(2) 
    trialerror(3); %break fixation
    eventmarker(49); %broke fixation
    if ismember(cc,1:5)
        nimg_unseen = (nto-2);
    else
        nimg_unseen = (nto-1);
    end
    allimgorder{rep} = [allimgorder{rep} allC((img_c-nimg_unseen):(img_c-1))'];
    rt=NaN;
    toggleobject(1,'eventmarker',36); % turn off fixation spot
    return
end

if ismember(cc,1:5)
    for tobj=2:nto-1
        count=1;
        toggleobject(tobj,'eventmarker',on_codes(tobj-1)); %turns image on 
%         eventmarker(23) on_codes(tobj-1); %image turned on - not specific image
        [ontarget, rt] = eyejoytrack('holdtouch', 1, 3,'holdfix', 1, fix_window_radius, (min_hold_time));

        if ~ontarget(1),
            trialerror(5); %early release
            eventmarker(4); %bar up (release)
            nimg_unseen = (nto-2)-count;
            allimgorder{rep} = [allimgorder{rep} allC((img_c-nimg_unseen):(img_c-1))'];
%             TrialRecord.allimgorder=allimgorder;
            rt = NaN;
%             toggleobject(tobj,'eventmarker',off_codes(tobj-1)); %turns image off
            toggleobject(tobj,'eventmarker',55); %turns image off
%             eventmarker(24);off_codes(tobj-1)
            toggleobject(1,'eventmarker',36); % turn off fixation spot
        return
        elseif ~ontarget(2) 
            trialerror(2); %break fixation - but during image sequence viewing
            nimg_unseen = (nto-2)-count;
            allimgorder{rep} = [allimgorder{rep} allC((img_c-nimg_unseen):(img_c-1))'];
%             TrialRecord.allimgorder=allimgorder;
            rt=NaN;
            toggleobject(tobj,'eventmarker',55); %turns image off
%             toggleobject(tobj,'eventmarker',off_codes(tobj-1)); %turns image off
%             eventmarker(24);off_codes(tobj-1)
            toggleobject(1,'eventmarker',37); % turn off fixation spot, eventmarker 37 because fixation break within image sequence
        return
        end
%         toggleobject(tobj,'eventmarker',off_codes(tobj-1)) %turns image off
        toggleobject(tobj,'eventmarker',55); %turns image off
%         eventmarker(24);off_codes(tobj-1)
        if tobj~=(nto-1)
            idle(150);
        end
        count=count+1;
    end
    
    dim_image=nto;
    toggleobject(dim_image) %dim_image on
    eventmarker(25)

[ontarget, rt] = eyejoytrack('holdtouch', 1, 3, 'holdfix', 1, fix_window_radius, max_hold_time);

else
    for tobj=2:nto-1
        count=1;
        toggleobject(tobj,'eventmarker',on_codes(tobj-1)); %turns image on 
%         eventmarker(23) on_codes(tobj-1); %image turned on - not specific image
        [ontarget, rt] = eyejoytrack('holdtouch', 1, 3,'holdfix', 1, fix_window_radius, (min_hold_time));

        if ~ontarget(1),
            trialerror(5); %early release
            eventmarker(4); %bar up (release)
            nimg_unseen = (nto-1)-count;
            allimgorder{rep} = [allimgorder{rep} allC((img_c-nimg_unseen):(img_c-1))'];
%             TrialRecord.allimgorder=allimgorder;
            rt = NaN;
            toggleobject(tobj,'eventmarker',55); %turns image off
%             toggleobject(tobj,'eventmarker',off_codes(tobj-1)); %turns image off
%             eventmarker(24);off_codes(tobj-1)
            toggleobject(1,'eventmarker',36); % turn off fixation spot
        return
        elseif ~ontarget(2) 
            trialerror(2); %break fixation - but during image sequence viewing
            nimg_unseen = (nto-1)-count;
            allimgorder{rep} = [allimgorder{rep} allC((img_c-nimg_unseen):(img_c-1))'];
%             TrialRecord.allimgorder=allimgorder;
            rt=NaN;
            toggleobject(tobj,'eventmarker',55); %turns image off
%             toggleobject(tobj,'eventmarker',off_codes(tobj-1)); %turns image off
%             eventmarker(24);off_codes(tobj-1)
            toggleobject(1,'eventmarker',37); % turn off fixation spot, eventmarker 37 because fixation break within image sequence
        return
        end
        toggleobject(tobj,'eventmarker',55); %turns image off
%         toggleobject(tobj,'eventmarker',off_codes(tobj-1)) %turns image off
%         eventmarker(24);off_codes(tobj-1)
        idle(150);
        count=count+1;
    end
    dim_image=nto;
    toggleobject(dim_image) %dim_image on
    eventmarker(on_codes(end))

[ontarget, rt] = eyejoytrack('holdtouch', 1, 3, 'holdfix', 1, fix_window_radius, max_hold_time);
end

if TrialRecord.CurrentCondition~=6 %Not condition 6, which means dimming happens on any image, and correct response is to release on dimming
    if ontarget(1)==1, %monkey holds through
        trialerror(6); %incorrect response
        rt = NaN;
        toggleobject(dim_image); %turns dim_image off
        if ismember(cc,1:5)
            eventmarker(26)
        else
            eventmarker(24)
        end
        toggleobject(1,'eventmarker',36); % turn off fixation spot
        return
    elseif ~ontarget(2) 
        trialerror(3); %break fixation
        rt=NaN;
        toggleobject(dim_image); %turns image off
        if ismember(cc,1:5)
            eventmarker(26)
        else
            eventmarker(24)
        end
        toggleobject(1,'eventmarker',36); % turn off fixation spot
        return
    end

    if ontarget(1)==0, %monkey releases correctly
        trialerror(0); %correct
        eventmarker(4); %bar up (release)
        toggleobject(dim_image); %turns dim_image off
        if ismember(cc,1:5)
            eventmarker(26)
        else
            eventmarker(24)
        end
        toggleobject(1,'eventmarker',36); % turn off fixation spot
        goodmonkey('user');
        eventmarker(48); % reward given
    end
else %condition 6, which means no dimming happens, and correct response is to hold through
    if ontarget(1)==1, %monkey holds through
        trialerror(0); %correct
        eventmarker(4); %bar up (release)
        toggleobject(dim_image); %turns dim_image off
        if ismember(cc,1:5)
            eventmarker(26)
        else
            eventmarker(24)
        end
        toggleobject(1,'eventmarker',36); % turn off fixation spot
        goodmonkey('user');
        eventmarker(48); % reward given
    end
    
    if ontarget(1)==0; %monkey releases incorrectly
        trialerror(6); %incorrect response
        rt = NaN;
        toggleobject(dim_image); %turns dim_image off
        if ismember(cc,1:5)
            eventmarker(26)
        else
            eventmarker(24)
        end
        toggleobject(1,'eventmarker',36); % turn off fixation spot
        return
    elseif ~ontarget(2) 
        trialerror(3); %break fixation
        rt=NaN;
        toggleobject(dim_image); %turns image off
        if ismember(cc,1:5)
            eventmarker(26)
        else
            eventmarker(24)
        end
        toggleobject(1,'eventmarker',36); % turn off fixation spot
        return
    end
end

