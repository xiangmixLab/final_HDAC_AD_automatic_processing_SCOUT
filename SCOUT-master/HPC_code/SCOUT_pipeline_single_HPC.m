function []=SCOUT_pipeline_single_HPC(extraction_options)

%Global cell tracking parameters
% disp(fname);
% [pathh,fnamee]=fileparts(fname);
% cd(pathh);
load('final_concatenate_stack_stats.mat');
tic
neuron=full_demo_endoscope(['final_concatenate_stack.mat'],extraction_options);
toc

for i=1:length(neuron)
    neuron.MergeNeighbors([2,15]);
end

neuron.num2read=num2read;
neuron.imageSize=data_shape;
d1=data_shape(1);
d2=data_shape(2);

centroid=zeros(size(neuron.A,2),2);
for i=1:size(neuron.A,2)
    Ai=full(neuron.A(:,i));
    Ait=reshape(Ai,d1,d2);
    Ait=Ait>max(Ait(:))*0.5;
    stats=regionprops(Ait,'Centroid');
    centroid(i,:)=stats.Centroid;
end

neuron.centroid=centroid;

save(['further_processed_neuron_extraction_final_result.mat'],'neuron','-v7.3')


