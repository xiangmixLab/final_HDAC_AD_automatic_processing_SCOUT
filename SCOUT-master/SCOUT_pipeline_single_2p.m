function [neuron]=SCOUT_pipeline_single_2p(fname,num2read,data_shape)

%Global cell tracking parameters
[pathh,fnamee]=fileparts(fname);
cd(pathh);

extraction_options.min_pnr=5;
extraction_options.gSiz=25;
extraction_options.max_neurons=400;
extraction_options.min_corr=.5;
extraction_options.corr_noise=false;
extraction_options.JS=0; %No spatial filter available yet        


tic
neuron=full_demo_endoscope_2p([fnamee,'.mat'],extraction_options);
toc

for i=1:length(neuron)
    neuron.MergeNeighbors([2,15]);
end

neuron.num2read=num2read;
neuron.imageSize=data_shape;

Cn=neuron.Cn;
[neuron.Coor,json_file,centroid] = plot_contours(neuron.A, Cn, 0.8, 0, [], [], 2);

close

neuron.centroid=centroid;



