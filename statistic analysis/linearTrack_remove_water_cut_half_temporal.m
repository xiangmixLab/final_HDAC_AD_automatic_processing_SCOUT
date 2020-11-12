function [nnew_half_temp,behavpos_new_half_temp,behavtime_new_half_temp]=linearTrack_remove_water_cut_half_temporal(neuron,behavpos,behavtime)

%% get the maximal position of x and y axis, to determine how the track is oriented
max_behavpos_x=max(behavpos(:,1));
max_behavpos_y=max(behavpos(:,2));

% horizontal track
if max_behavpos_x>max_behavpos_y
    % define 10% of the track length as water size
    water_size=(max(behavpos(:,1))-min(behavpos(:,1)))*0.1;
    % water area is defined as end+/-water size
    min_pos=min(behavpos(:,1))+water_size;
    max_pos=max(behavpos(:,1))-water_size;
    
    % get the position index that between the two water region
    idx=logical((behavpos(:,1)>=min_pos).*(behavpos(:,1)<=max_pos));
    behavpos_new=behavpos(idx,:);
    behavtime_new=behavtime(idx);
        
    nnew=neuron.copy;
    ntime = double(nnew.time);
    ntime = ntime(1:2:end);
    ntime = resample(ntime,size(nnew.C,2),length(ntime));
    
    idx_resample=interp1(behavtime,double(idx),ntime,'nearest');
    idx_resample1=interp1(behavtime,double(idx),nnew.time,'nearest');
    
    idx_resample(isnan(idx_resample))=0;
    idx_resample1(isnan(idx_resample1))=0;
    
    idx_resample=logical(idx_resample);
    idx_resample1=logical(idx_resample1);
    
    nnew.C=nnew.C(:,idx_resample);
    nnew.S=nnew.S(:,idx_resample);
    nnew.time=nnew.time(idx_resample1);
    
    behavpos_new_half_temp{1}=behavpos_new(1:round(size(behavpos_new,1)/2),:);
    behavpos_new_half_temp{2}=behavpos_new(round(size(behavpos_new,1)/2):end,:);
    behavtime_new_half_temp{1}=behavtime_new(1:round(size(behavpos_new,1)/2),:);
    behavtime_new_half_temp{2}=behavtime_new(round(size(behavpos_new,1)/2):end,:);
    
    nnew_half_temp{1}.C=nnew.C(:,1:round(size(nnew.C,2)/2));
    nnew_half_temp{1}.S=nnew.S(:,1:round(size(nnew.C,2)/2));
    nnew_half_temp{1}.time=nnew.time(1:round(length(nnew.time)/2));
    
    nnew_half_temp{2}.C=nnew.C(:,round(size(nnew.C,2)/2):end);
    nnew_half_temp{2}.S=nnew.S(:,round(size(nnew.C,2)/2):end);
    nnew_half_temp{2}.time=nnew.time(round(length(nnew.time)/2):end);
else
    %vertical track
    water_size=(max(behavpos(:,2))-min(behavpos(:,2)))*0.1;
    min_pos=min(behavpos(:,2))+water_size;
    max_pos=max(behavpos(:,2))-water_size;
    
    idx=logical((behavpos(:,2)>=min_pos).*(behavpos(:,2)<=max_pos));
    behavpos_new=behavpos(idx,:);
    behavtime_new=behavtime(idx);
    
    nnew=neuron.copy;
    ntime = double(nnew.time);
    ntime = ntime(1:2:end);
    ntime = resample(ntime,size(nnew.C,2),length(ntime));
    
    idx_resample=interp1(behavtime,double(idx),ntime,'nearest');
    idx_resample1=interp1(behavtime,double(idx),nnew.time,'nearest');
    
    idx_resample(isnan(idx_resample))=0;
    idx_resample1(isnan(idx_resample1))=0;
    
    idx_resample=logical(idx_resample);
    idx_resample1=logical(idx_resample1);  
    
    nnew.C=nnew.C(:,idx_resample);
    nnew.S=nnew.S(:,idx_resample);
    nnew.time=nnew.time(idx_resample1);
    
    behavpos_new_half_temp{1}=behavpos_new(1:round(size(behavpos_new,1)/2),:);
    behavpos_new_half_temp{2}=behavpos_new(round(size(behavpos_new,1)/2):end,:);
    behavtime_new_half_temp{1}=behavtime_new(1:round(size(behavpos_new,1)/2),:);
    behavtime_new_half_temp{2}=behavtime_new(round(size(behavpos_new,1)/2):end,:);
    
    nnew_half_temp{1}.C=nnew.C(:,1:round(size(nnew.C,2)/2));
    nnew_half_temp{1}.S=nnew.S(:,1:round(size(nnew.C,2)/2));
    nnew_half_temp{1}.time=nnew.time(1:round(length(nnew.time)/2));
    
    nnew_half_temp{2}.C=nnew.C(:,round(size(nnew.C,2)/2):end);
    nnew_half_temp{2}.S=nnew.S(:,round(size(nnew.C,2)/2):end);
    nnew_half_temp{2}.time=nnew.time(round(length(nnew.time)/2):end);
end