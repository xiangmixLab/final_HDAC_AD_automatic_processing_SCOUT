function neuron=combine_neurons_after_extraction(neuron1,neuron2,dist_thresh,corr_thresh,data_shape,initial)
%neuron1 and neuron2 are 2 neurons we desire to combine. Neither can be outputs of BatchEndoscopeWrapperFull
%dist_thresh is the desired distance threshold to use. If using centroid distance, try 10, if using overlap, try .5
%corr_thresh is the desired correlation threshold we require for similarity on overlap. Try .5-.7. 
%data_shape is a vector representing the shape of the spatial footprint, [height,width] (same as first two elements of Ysiz)
%initial is a boolean that indicates whether neuron1 is the initial output of the extraction, or if it is the result of combining previously extracted neurons.




neuron1=neuron1.copy();
neuron2=neuron2.copy();
if ~exist('initial','var')
    initial=false;
end
if initial==true
minim1=min(neuron1.corr_scores,[],2);
maxim1=max(neuron1.dist,[],2);
include1=find(minim1>corr_thresh&maxim1<dist_thresh);

neuron1.C=neuron1.C(include1,:);
neuron1.S=neuron1.S(include1,:);
neuron1.C_raw=neuron1.C_raw(include1,:);
neuron1.A=neuron1.A(:,include1);
neuron1.centroid=neuron1.centroid(include1,:);
 neuron1.corr_scores=neuron1.corr_scores(include1,:);
neuron1.dist=neuron1.dist(include1,:);
%neuron1.scores=neuron1.scores(include1);
if isempty(neuron1.combined);
    neuron1.combined=ones(size(neuron1.C,1),1);
end
end
minim2=min(neuron2.corr_scores,[],2);
maxim2=max(neuron2.dist,[],2);
include2=find(minim2>corr_thresh&maxim2<dist_thresh);

neuron2.C=neuron2.C(include2,:);
neuron2.S=neuron2.S(include2,:);
neuron2.C_raw=neuron2.C_raw(include2,:);
neuron2.A=neuron2.A(:,include2);
neuron2.centroid=neuron2.centroid(include2,:);
neuron2.corr_scores=neuron2.corr_scores(include2,:);
neuron2.dist=neuron2.dist(include2,:);
%neuron2.scores=neuron2.scores(include2);
if isempty(neuron2.combined)
    neuron2.combined=ones(size(neuron2.C,1),1);
end


neuron=neuron1.copy();
neuron.C=vertcat(neuron.C,neuron2.C);
neuron.S=vertcat(neuron.S,neuron2.S);
neuron.C_raw=vertcat(neuron.C_raw,neuron2.C_raw);
neuron.centroid=vertcat(neuron.centroid,neuron2.centroid);
neuron.A=horzcat(neuron.A,neuron2.A);
neuron.scores=vertcat(neuron.scores,neuron2.scores);
neuron.combined=vertcat(neuron.combined,neuron2.combined);

neuron=thresholdNeuron(neuron,.35);


quickMerge(neuron,[.2,.6,0]);

%neuron=Eliminate_Misshapen(neuron,.15,data_shape);
neuron.centroid=[];
for i=1:size(neuron.A,2)
    neuron.centroid=vertcat(neuron.centroid,calculateCentroid(neuron.A(:,i),data_shape(1),data_shape(2)));
end
neuron.dist=[];
neuron.corr_scores=[];
neuron.corr_prc=[];
neuron.dist_prc=[];

