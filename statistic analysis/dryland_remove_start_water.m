function [neuron0,neuron0_before,neuron0_after]=dryland_remove_start_water(neuron,behav)

behavpos=behav.position;
behavtime=behav.time;
object=[behav.object(:,1),behav.ROI(4)+behav.ROI(2)-behav.object(:,2)];

exclude_range_start=1; % 1 sec
exclude_range_obj=15+12.5; % 27.5cm

% start range
behavpos_resample=align_neuron_behav(neuron,behavtime,behavpos);
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
 
% check
% plot(behavpos_resample(:,1),behavpos_resample(:,2));
% hold on;
% plot(behavpos_resample(idx_start_ex,1),behavpos_resample(idx_start_ex,2),'.','color','r','MarkerSize',5)
% plot(behavpos_resample(idx_object_ex,1),behavpos_resample(idx_object_ex,2),'.','color','b','MarkerSize',5)

idx_rem=logical(idx_start_ex+idx_object_ex);

idx_first_encounter=min(find(idx_object_ex==1));

idx_before_obj=[1:idx_first_encounter];
idx_after_obj=[idx_first_encounter+15:length(idx_object_ex)]; %first encounter and other 1 sec

neuron0_before=neuron.copy;
neuron0_before.C(:,idx_after_obj)=[];
neuron0_before.S(:,idx_after_obj)=[];
neuron0_before.time(idx_after_obj)=[];

neuron0_after=neuron.copy;
neuron0_after.C(:,idx_before_obj)=[];
neuron0_after.S(:,idx_before_obj)=[];
neuron0_after.time(idx_before_obj)=[];

neuron0=neuron.copy;
neuron0.C(:,idx_rem)=[];
neuron0.S(:,idx_rem)=[];
neuron0.time(idx_rem)=[];