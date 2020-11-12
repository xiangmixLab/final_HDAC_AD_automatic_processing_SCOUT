function [nnew,behavpos_new,behavtime_new]=linearTrack_remove_water_cut_half(neuron,behavpos,behavtime)

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
    idxw=logical((behavpos(:,1)>=min_pos).*(behavpos(:,1)<=max_pos));
    
    % half track
    half_pos=(max_pos+min_pos)/2;
    idx_half={logical((behavpos(:,1)<=half_pos)),logical((behavpos(:,1)>half_pos))};
    
    for h=1:2
        idx=logical(idxw.*idx_half{h}); %1: left; 2:right
        behavpos_new{h}=behavpos(idx,:);
        behavtime_new{h}=behavtime(idx);

        nnew{h}=neuron.copy;
        ntime = double(nnew{h}.time);
        ntime = ntime(1:2:end);
        ntime = resample(ntime,size(nnew{h}.C,2),length(ntime));

        idx_resample=interp1(behavtime,double(idx),ntime,'nearest');
        idx_resample1=interp1(behavtime,double(idx),nnew{h}.time,'nearest');

        idx_resample(isnan(idx_resample))=0;
        idx_resample1(isnan(idx_resample1))=0;

        idx_resample=logical(idx_resample);
        idx_resample1=logical(idx_resample1);

        nnew{h}.C=nnew{h}.C(:,idx_resample);
        nnew{h}.S=nnew{h}.S(:,idx_resample);
        nnew{h}.time=nnew{h}.time(idx_resample1);
    end
else
    %vertical track
    water_size=(max(behavpos(:,2))-min(behavpos(:,2)))*0.1;
    min_pos=min(behavpos(:,2))+water_size;
    max_pos=max(behavpos(:,2))-water_size;
    
    % get the position index that between the two water region
    idxw=logical((behavpos(:,1)>=min_pos).*(behavpos(:,1)<=max_pos));
    
    % half track
    half_pos=(max_pos+min_pos)/2;
    idx_half={logical((behavpos(:,1)<=half_pos)),logical((behavpos(:,1)>half_pos))};
    
    for h=1:2
        idx=idxw.*idx_half{h}; %1: left; 2:right
        behavpos_new{h}=behavpos(idx,:);
        behavtime_new{h}=behavtime(idx);

        nnew{h}=neuron.copy;
        ntime = double(nnew{h}.time);
        ntime = ntime(1:2:end);
        ntime = resample(ntime,size(nnew{h}.C,2),length(ntime));

        idx_resample=interp1(behavtime,double(idx),ntime,'nearest');
        idx_resample1=interp1(behavtime,double(idx),nnew{h}.time,'nearest');

        idx_resample(isnan(idx_resample))=0;
        idx_resample1(isnan(idx_resample1))=0;

        idx_resample=logical(idx_resample);
        idx_resample1=logical(idx_resample1);

        nnew{h}.C=nnew{h}.C(:,idx_resample);
        nnew{h}.S=nnew{h}.S(:,idx_resample);
        nnew{h}.time=nnew{h}.time(idx_resample1);
    end
end