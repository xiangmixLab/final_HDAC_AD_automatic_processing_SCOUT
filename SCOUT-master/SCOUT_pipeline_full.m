function []=SCOUT_pipeline_full(fname,num2read,data_shape)

%Global cell tracking parameters
[pathh]=fileparts(fname{1});
cd(pathh);

%% single trial tracking
neurons={};
for i=1:length(fname)
    [~,fnamee]=fileparts(fname{i});
    extraction_options.JS=.11; %(spatial constraint parameter, this is too low for in vivo data, it should be at least 0.1)

    tic
    neuron=full_demo_endoscope([fnamee,'.mat'],extraction_options);
    toc
    
    neuron.MergeNeighbors([2,15]);    
end

save(['all_neurons.mat'],'neurons','-v7.3')

%% cross trial tracking
cell_tracking_options.chain_prob=.5; %(Chain probability threshold)
cell_tracking_options.min_prob=.5; %(individual identification probability threshold)
cell_tracking_options.overlap=0; %(Overlap size on each recording, 1/2 the length of the connecting recording, 0 represents no overlap thus footprint alignment dominates?)
cell_tracking_options.weights=[0,0,5,5,0,0]; %Ensemble weights
cell_tracking_options.probability_assignment_method='Kmeans'; %(Probabilistic method for assigning identification probabilities)
cell_tracking_options.max_gap=0; %(Number of allowed gaps for cell tracking, set to 0 to only extract neurons through full recording set)
cell_tracking_options.max_dist=40; %(maximum distance between neurons, larger values preferred, this value is corrected, so don't worry about making it too big)
cell_tracking_options.links=[]; %Defaults to no connecting recordings. If activity has been extracted for connecting recordings, this should be a cell array of Sources2D objects
cell_tracking_options.register_sessions=false;

%neurons is a cell array of Sources2D objects containing extracted data
%from recordings. Specify path to variable here, or just load the variable
%and name it neurons. Assumes base folder is SCOUT/Demos


neuron=cellTracking_SCOUT(neurons,'cell_tracking_options',cell_tracking_options);

%% save
neuron.num2read=num2read;
neuron.imageSize=data_shape;

Cn=neuron.Cn;
[neuron.Coor,json_file,centroid] = plot_contours(neuron.A, Cn, 0.8, 0, [], [], 2);

saveas(gcf,[[pwd,'\','contours.tif']],'tif')
saveas(gcf,[[pwd,'\','contours.eps']],'epsc')
saveas(gcf,[[pwd,'\','contours.fig']],'fig')
close

neuron.centroid=centroid;

save([pwd,'\','further_processed_neuron_extraction_final_result.mat'],'neuron','-v7.3')


