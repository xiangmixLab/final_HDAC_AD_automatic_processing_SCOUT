function neuron=Combine_Full_Experiment(shift_val,batch_dir,data_shape)
%shift_val: integer representing index shift between batches. vids_per_batch-overlap_per_batch
%batch_dir: directory containing the combined extractions from each batch. Extractions should be saved as neuroni.mat where i is the batch number, with the variable neuron inside the file containing the 
%sources2D extraction
%data_shape: [height,width] of spatial footprint image. First two elements of Ysiz for the associated video file.



load(batch_dir)

load('neuron1');

neuron1=neuron;

neuron1.corr_scores=[];
neuron1.scores=[];
if isempty(neuron1.scores)
    neuron1.scores=zeros(size(neuron1.C,1),1);
end
if isempty(neuron1.combined)
    neuron1.combined=ones(size(neuron1.C,1),1);
end


i=2;
j=shift_val+1;
data_shape_curr=data_shape;
while j<=length(batches)-1;
i
j
load(['neuron',num2str(i)]);
neuron2=neuron;

neuron2.corr_scores=[];
neuron2.scores=[];
if isempty(neuron2.scores)
    neuron2.scores=zeros(size(neuron2.C,1),1);
end
if isempty(neuron2.combined)
    neuron2.combined=ones(size(neuron2.C,2),1);
end
[neuron1.A,neuron2.A,data_shape_curr]=align_spatial_footprints(neuron1.C(:,end-sum(batches(j:j+1))+1:end),neuron2.C(:,1:sum(batches(j:j+1))),neuron1.A,neuron2.A,data_shape_curr,data_shape);
neuron1.imageSize=data_shape_curr;
neuron2.imageSize=data_shape_curr;
neuron1=combined_over_overlap(neuron1,neuron2,sum(batches(j:j+1)),neuron1.imageSize);
%scores=neuron1.scores;
%neuron1.scores=neuron1.scores(:,end);
%quickMerge(neuron1,[.3,.7,0]);
indices=neuron1.combined(:,end)==0;
%scores(indices,:)=[];
neuron1.scores(indices,:)=[];
neuron1.overlap_corr(indices,:)=[];
neuron1.overlap_dist(indices,:)=[];
neuron1.combined(indices,:)=[];
save(['neuron1_',num2str(i)],'neuron1','-v7.3')
neuron1

j=j+shift_val;
i=i+1;



end
neuron=neuron1;
