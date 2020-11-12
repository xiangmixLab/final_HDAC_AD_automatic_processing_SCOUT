function neuron=full_demo_endoscope(filename,dshape)
% 1p neuron extraction with SCOUT
% Inputs

% filename: filepath for recording to be extracted (you can also submit the video itself)
% extraction_options: structure with following possible fields.
%indices: ([int1, int2]) specified index range for extraction (use [] for all indices)
%JS: (non-negative float) Setting to 0 gives CNMF-E, otherwise, this
%sets the spatial filter threshold.
%min_pnr: (postive float) minimum peak-to-noise ratio for neuron initialization
%gSiz: (float) maximum neuron width in image plane
%max_neurons: (int) maximum number of detected neurons
%min_corr: (float between 0 and 1) sets min correlation threshold for
%neuron initialization
%corr_noise: (bool) true or (float) <1: add noise when calculating correlation image.
%Typically requires a low min_corr parameter, but can improve initialization.
%merge_thr (3 element vector) indicate threshold for merging
%res_extract (bool) indicate whether to extract neurons from residual

%Outputs

% full_neuron: (Sources2D) extracted neural data

%%Authors: Pengcheng Zhou, Kevin Johnston


%% new CNMF VERSION, 2019
tic;
neuron = Sources2D(); 
nams = neuron.select_multiple_files({filename});  %if nam is [], then select data interactively 

%% parameters load
cnmfe_necessary_parameters;
SCOUT_spatialFilter_parameter;

%% distribute data and be ready to run source extraction 
neuron.getReady_batch(pars_envs); 
toc;
%% initialize neurons in batch mode 
neuron.initComponents_batch(K, save_initialization, use_parallel); 
toc;
%% udpate spatial components for all batches
neuron.update_spatial_batch(use_parallel); 
toc;
%% udpate temporal components for all bataches
neuron.update_temporal_batch(use_parallel); 
toc;
%% update background 
neuron.update_background_batch(use_parallel); 
toc;
%% merge neurons 
% try
%     cnmfe_quick_merge;              % run neuron merges
%     cnmfe_merge_neighbors;          % merge neurons if two neurons' peak pixels are too close
% end
toc;
%% get the correlation image and PNR image for all neurons 
neuron.correlation_pnr_batch(); 

%% concatenate temporal components 
neuron.concatenate_temporal_batch(); 
toc;

%% JS score trim A
disp('SCOUT JS score trim bad footprints');
if spatial_filter_options.JS>0   
    [neuron0,JS_score]=spatial_filter(neuron,spatial_filter_options);
end
