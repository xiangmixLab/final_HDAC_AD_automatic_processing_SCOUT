function [tuning_map,tuning_map_n,occupancy_map,prob_being_active]=calcium_spatial_bayesian_decoding_william_2019(ntemp,behav_vec,behav_time,binsize,sampling_frequency)

%% preprocess data
nC=ntemp.C;
nC_res=[];
for i=1:size(nC,1)
    nC_res(i,:)=resample(nC(i,:),length(nC(i,:))*2,length(nC(i,:))); % get neuron data back to 30Hz
end

thresh=0.1*max(nC_res,[],2);
nC_res(nC_res<thresh)=0;

ca_time=ntemp.time/1000;
behav_time=behav_time/1000;

[behav_time,idx]=unique(behav_time);
behav_vec=behav_vec(idx,:);
    
for i=1:size(nC_res,1)
    ca_trace=nC_res(i,:);
    
    
    
    %% Binarize calcium trace
    z_threshold = 2; % A 2 standard-deviation threshold is usually optimal to differentiate calcium ativity from background noise
    [binarized_trace] = extract_binary(ca_trace, sampling_frequency, z_threshold);

    %% Interpolate behavior
    % In most cases, behavior data has to be interpolated to match neural temporal
    % activity assuming it has a lower sampling frequency than neural activity
    interp_behav_vec(:,1) = interpolate_behavior(behav_vec(:,1), behav_time, ca_time); % in the X dimension
    interp_behav_vec(:,2) = interpolate_behavior(behav_vec(:,2), behav_time, ca_time); % in the Y dimension
    interp_behav_vec(end,:) = interp_behav_vec(end-1,:); % Make sure to interpolate or remove every NaN so that every timepoint has a corresponding behavioral state

    %% Compute velocities
    % In this example, we will ignore moments when the mouse is immobile
    [ velocity ] = extract_velocity(interp_behav_vec, ca_time);

    %% Find periods of immobility
    % This will be usefull later to exclude immobility periods from analysis
    min_speed_threshold = 10; % 1 cm.s-1
    running_ts = velocity > min_speed_threshold;

    %% Create an inclusion vector to isolate only a specific behavior
    inclusion_vector = running_ts; % Only include periods of running

    %% Compute occupancy and joint probabilities
    % You can use 'min(behav_vec)' and 'max(behav_vec)'  to estimate the
    % boundaries of the behavior vector (in our case, location in space)
    bin_size = binsize;
    X_bin_vector = min(interp_behav_vec(:,1)):bin_size:max(interp_behav_vec(:,1))+bin_size;
    X_bin_centers_vector = X_bin_vector + bin_size/2;
    X_bin_centers_vector(end) = [];

    Y_bin_vector = min(interp_behav_vec(:,2)):bin_size:max(interp_behav_vec(:,2))+bin_size;
    Y_bin_centers_vector = Y_bin_vector + bin_size/2;
    Y_bin_centers_vector(end) = [];

    [~, ~, occupancy_map, prob_being_active{i}, tuning_map{i}, tuning_map_n{i}] = extract_2D_information(binarized_trace, interp_behav_vec, X_bin_vector, Y_bin_vector, inclusion_vector);
end
