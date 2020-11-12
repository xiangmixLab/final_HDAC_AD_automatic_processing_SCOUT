function [nnew,behavpos_new,behavtime_new,idx,idx_resample,idx_resample1]=linearTrack_remove_water(neuron,behavpos,behavtime)

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
end