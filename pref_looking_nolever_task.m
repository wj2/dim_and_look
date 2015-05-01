% pref_looking task
% monkey must hold through image and release the bar when it dims
editable('look_reward_duration', 'look_num_rewards','look_fix_window_radius');
% assigning names to TaskObjects
fix = 1;
left_image = 2;
right_image = 3;

% gen switch rns
im_order = rand(3, 1);

% define event markers
left_img_on = 191;
left_img_off = 192;
dim_left_on = 193;
dim_left_off = 194;

right_img_on = 195;
right_img_off = 196;
dim_right_on = 197;
dim_right_off = 198;

fix_on = 35;
fix_off = 36;

reward_given = 48;
acquired_fixation = 8;
broke_fixation = 49;
depressed_lever = 7;
released_lever = 4;

% trialerror codes
no_touch = 1;
early_lever = 5;
late_lever = 2;

no_fix = 4;
break_fix = 3;

correct = 0;

% defining time intervals
wait_for_touch = 10000;
look_reward_duration = 120;
look_num_rewards = 1;
fix_time = 500;
look_fix_window_radius = 2.5;
view_window_radius = 99;
max_view_time = 5000;
wait_for_fix = 10000;

pause(.06); % added additional pause of ~60ms to ensure that enough eye 
            % data is collected for drift routine


toggleobject(fix, 'eventmarker', fix_on); %fixation spot on

[ontarget, rt] = eyejoytrack('acquirefix', [1], [look_fix_window_radius], wait_for_fix);

if ~ontarget(1)
    trialerror(no_fix); %no fixation
    rt=NaN;
    toggleobject(fix, 'eventmarker', fix_off); % turn off fixation spot
    return
end
eventmarker(acquired_fixation); %fixation occurs

[ontarget, rt] = eyejoytrack('holdfix', [1], [look_fix_window_radius], fix_time);

if ~ontarget(1)
    trialerror(break_fix); %break fixation
    eventmarker(broke_fixation); %broke fixation
    rt=NaN;
    toggleobject(fix ,'eventmarker', fix_off); % turn off fixation spot
    return
end

if im_order(1) > .5
    toggleobject(left_image,'eventmarker', left_img_on); 
    toggleobject(right_image,'eventmarker', right_img_on); 
else
    toggleobject(right_image,'eventmarker', right_img_on); 
    toggleobject(left_image,'eventmarker', left_img_on); 
end
toggleobject(fix,'eventmarker',fix_off); %turns fixation off


[ontarget, rt] = eyejoytrack('holdfix', [1], [view_window_radius], max_view_time);

if ~ontarget(1),
    trialerror(correct); %early release
    eventmarker(break_fix); %bar up (release)
    rt = NaN;
    if im_order(2) > .5
        toggleobject(left_image,'eventmarker', left_img_off); 
        toggleobject(right_image,'eventmarker', right_img_off); 
    else
        toggleobject(right_image,'eventmarker', right_img_off);
        toggleobject(left_image,'eventmarker', left_img_off);
    end
    return
end

if ontarget(1)
    trialerror(correct); %correct
    eventmarker(break_fix); %bar up (release)
    if im_order(2) > .5
        toggleobject(left_image,'eventmarker', left_img_off);
        toggleobject(right_image,'eventmarker',right_img_off);
    else
        toggleobject(right_image,'eventmarker', right_img_off); 
        toggleobject(left_image,'eventmarker', left_img_off); 
    end
end
goodmonkey('user');
eventmarker(reward_given); % reward given
