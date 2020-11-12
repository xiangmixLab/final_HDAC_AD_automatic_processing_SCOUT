function full_pipeline_infoscore(folderName)

behavname={
    'Circle1_behav.mat';
    'Square1_behav.mat';
    'Square2_behav.mat';
    'Circle2_behav.mat';
    'Circle3_behav.mat';
    'Square3_behav.mat';
    'Square4_behav.mat';
    'Circle4_behav.mat';
    }

load([folderName,'/','neuronIndividuals_new.mat']);

all_pc={};
all_infoscore={};
all_keep_idx={};

for j=1:length(behavname)
    load([folderName,'/',behavname{j}]);
    
    rate_thresh=0.02; % 12 times per 10 min
    [neuron0,keep_idx]=low_fr_delete_neurons(neuronIndividuals_new{j},rate_thresh,15);
        
    tic;
    [place_cells,infoScore] = permutingSpike_adapt_091420(neuron0,behav.position,behav.time,'S',0.1,10,10,'spk');  
    toc;
    all_pc{1,j}=place_cells;
    all_infoscore{1,j}=infoScore;
    all_keep_idx{1,j}=keep_idx;
end

save([folderName,'/','infoscore_pc.mat'],'all_pc','all_infoscore','all_keep_idx');