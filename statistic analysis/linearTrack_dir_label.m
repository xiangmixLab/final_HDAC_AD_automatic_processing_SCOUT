function [laps_idx,dir_idx]=linearTrack_dir_label(behavpos)

max_behavpos_x=max(behavpos(:,1));
max_behavpos_y=max(behavpos(:,2));

% horizontal track
if max_behavpos_x>max_behavpos_y
   
    %take x position
    trackpos=behavpos(:,1);
    
    %get dir of movement
    move_dir=diff(trackpos)./abs(diff(trackpos));
    
    % label laps
    laps_bound_train=abs([0;diff(move_dir)]);
    laps_bound=find(laps_bound_train>0);
    laps_idx=[];
    dir_idx=[];
    ctt1=1;
    ctt2=1;
    for i=1:length(trackpos)-1
        laps_idx(i)=ctt1;
        dir_idx(i)=ctt2;
        if ismember(i+1,laps_bound)
            ctt1=ctt1+1;
            ctt2=-ctt2;
        end
    end
    laps_idx=[laps_idx ctt1];
    dir_idx=[dir_idx ctt2];
else
     %take Y position
    trackpos=behavpos(:,2);
    
    %get dir of movement
    move_dir=diff(trackpos)./abs(diff(trackpos));
    
    % label laps
    laps_bound_train=abs([0;diff(move_dir)]);
    laps_bound=find(laps_bound_train>0);
    laps_idx=[];
    dir_idx=[];
    ctt1=1;
    ctt2=1;
    for i=1:length(trackpos)-1
        laps_idx(i)=ctt1;
        dir_idx(i)=ctt2;
        if ismember(i+1,laps_bound)
            ctt1=ctt1+1;
            ctt2=-ctt2;
        end
    end
    laps_idx=[laps_idx ctt1];
    dir_idx=[dir_idx ctt2];
end