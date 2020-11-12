function neuron=combine_neurons_after_extraction_full(neuron1,neuron2,data_shape)
%neuron1: sources2D, result of combining neurons from BatchEndoscopeWrapper, BatchEndoscopeWrapperDouble, BatchEndoscopeWrapperTriple
%neuron2: sources2D, result of BatchEndoscopeWrapperFull
%data_shape: vector, shape of spatial footprint, first two elements of Ysiz for the vid file the neuron is extracted from.



neuron2=neuron2.copy();
if size(neuron2.combined,1)~=size(neuron2.C,1)
    neuron2.combined=ones(size(neuron2.C,1),1);
end
%Eliminate_Misshapen(neuron2,.9,data_shape);
neuron=neuron1.copy();
neuron.C=vertcat(neuron.C,neuron2.C);
neuron.S=vertcat(neuron.S,neuron2.S);
neuron.C_raw=vertcat(neuron.C_raw,neuron2.C_raw);

neuron.A=horzcat(neuron.A,neuron2.A);

neuron.combined=vertcat(neuron.combined,neuron2.combined);
neuron.scores=vertcat(neuron.scores,neuron2.scores);
try
    neuron.overlap_corr=vertcat(neuron.overlap_corr,neuron2.overlap_corr);
    neuron.overlap_KL=vertcat(neuron.overlap_KL,neuron2.overlap_KL);
catch
    neuron.overlap_corr(end+1:size(neuron.C,1),1:size(neuron.overlap_corr,2))=0;
    neuron.overlap_KL(end+1:size(neuron.C,1),1:size(neuron.overlap_KL,2))=0;
end

neuron=thresholdNeuron(neuron,.35);
quickMerge(neuron,[.5,.6,0]);
%indices=find(neuron.combined(:,end)==0);
%neuron.combined(indices,:)=[];

%neuron.scores(indices,:)=[];
try
    neuron.overlap_corr(indices,:)=[];
    neuron.overlap_KL(indices,:)=[];
catch 
    'no error';
end


%neuron=thresholdNeuron(neuron,.7);
quickMerge(neuron,[.6,.5,0]);
%indices=find(neuron.combined(:,end)==0);
%neuron.combined(indices,:)=[];

%neuron.scores(indices,:)=[];

%neuron=thresholdNeuron(neuron,.35);
try
    neuron.overlap_corr(indices,:)=[];
    neuron.overlap_KL(indices,:)=[];
catch 
    'no error';
end

%neuron=Eliminate_Misshapen(neuron,.9,data_shape);
neuron.centroid=[];
for i=1:size(neuron.A,2)
    neuron.centroid=vertcat(neuron.centroid,calculateCentroid(neuron.A(:,i),data_shape(1),data_shape(2)));
end
%neuron.scores(end+1:size(neuron.C,1),:)=0;
neuron.dist=[];
neuron.corr_scores=[];
