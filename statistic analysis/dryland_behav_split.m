function [behav_before,behav_after]=dryland_behav_split(behav)

behavpos=behav.position;
behavtime=behav.time;
object=[behav.object(:,1),behav.ROI(4)+behav.ROI(2)-behav.object(:,2)];

exclude_range_start=1; % 1 sec
exclude_range_obj=15+12.5; % 27.5cm

% start range
behavpos_resample=behavpos;
idx_start_ex=zeros(size(behavpos_resample,1),1);
idx_start_ex(1:exclude_range_start*15)=1;

% obj range
idx_object_ex=zeros(size(behavpos_resample,1),1);
for i=1:size(behavpos_resample,1)
    if sum(abs(behavpos_resample(i,:)-object).^2)^0.5<exclude_range_obj
        idx_object_ex(i)=1;
    end
end

idx_start_ex=logical(idx_start_ex);
idx_object_ex=logical(idx_object_ex);
 
idx_rem=logical(idx_start_ex+idx_object_ex);

idx_first_encounter=min(find(idx_object_ex==1));

idx_before_obj=[1:idx_first_encounter];
idx_after_obj=[idx_first_encounter+15:length(idx_object_ex)]; %first encounter and other 1 sec

behav_before=behav;
behav_before.position=behav.position(idx_before_obj,:);
behav_after.position=behav.position(idx_after_obj,:);
behav_before.positionblue=behav.positionblue(idx_before_obj,:);
behav_after.positionblue=behav.positionblue(idx_after_obj,:);
behav_before.time=behav.time(idx_before_obj,:);
behav_after.time=behav.time(idx_after_obj,:);