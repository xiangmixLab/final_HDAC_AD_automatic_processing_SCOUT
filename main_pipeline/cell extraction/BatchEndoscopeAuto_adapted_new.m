function BatchEndoscopeAuto_adapted_new(num2read,foldernamestruct,data_shape,mrange)
close all;

% global ssub tsub;
% ssub=3;
% tsub=2;
% num2read=[29100,8995,1728, 8912, 4499, 3104, 1862];% adapted 092118
tic
for i=mrange
% filename=[foldernamestruct{i},'\final concatenate stack.tif']; %Input filenames for experiment;
[filepath,name,ext] = fileparts(foldernamestruct{i}) ;
cd(filepath);
filename=[foldernamestruct{i}]; %Input filenames for experiment;
dshape=data_shape{i};
% neuron=AutoNeuronExtraction(filename,dshape,[8,13,18,22],[0,0.2,0.3,0.5]);
% neuron=AutoNeuronExtraction(filename,[5 10 15],[0.3 0.6 0.8]);
neuron=AutoNeuronExtraction(filename,[10],[0.6]);
% neuron=AutoNeuronExtraction_demo_1p_large(filename,0.5);
%neuron_c and neuron are connected, as always

%% dealt with some neuron 
disp('overlap postprocessing')
[neuron,KL]=Eliminate_Misshapen_new(neuron,dshape,0.3);

Cn=neuron.Cn;
[neuron.Coor,json_file,centroid] = plot_contours(neuron.A, Cn, 0.8, 0, [], [], 2);
% 
% neuron.imageSize(3)=num2read(1);
% neuron=thresholdNeuron(neuron,0.1);
% [neuron,deleted_neurons]=Eliminate_Misshapen_adapted(neuron,0.25);
% [neuron_c,close_neurons_deleted]=further_process_neurons(neuron,0.30);


saveas(gcf,[[pwd,'\','contours.tif']],'tif')
saveas(gcf,[[pwd,'\','contours.eps']],'epsc')
saveas(gcf,[[pwd,'\','contours.fig']],'fig')
close

neuron.num2read=num2read{i};
neuron.imageSize=dshape;
neuron.centroid=centroid;
save([pwd,'\','further_processed_neuron_extraction_final_result.mat'],'neuron','-v7.3');

toc
end