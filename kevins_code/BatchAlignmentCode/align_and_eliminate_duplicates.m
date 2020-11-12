function [aligned_neurons,corr_scores,dist,corr_prc,dist_prc]=align_and_eliminate_duplicates(neurons,corr_thresh,dist_thresh,overlap,data_shape,corr_type,dist_meas)
% Overview
% Fixed Overlap Method: after neurons have been extracted from each batch,
% this code creates the alignment matrix for the neurons, and eliminates
% any cases in which two neurons request the same index in a batch when
% aligning neurons.

% input
% neurons: cell containing for element i, the extraction for batch i
% threshold: KL threshold for distance, 



aligned_neurons=align_neurons_subbatch(neurons,corr_thresh,dist_thresh,overlap,data_shape,corr_type,dist_meas);
for i=1:length(aligned_neurons)
    indices=sum(aligned_neurons{i}>0,2)<ceil(length(neurons)/2);
    aligned_neurons{i}(indices,:)=[];
end
    

for i=1:ceil(length(neurons)/2)
    
    [corr_scores{i},dist{i},corr_prc{i},dist_prc{i}]=score_aligned_matrix(neurons(i:end),aligned_neurons{i}(:,i:end),i,overlap,data_shape,corr_type,dist_meas);
end
aligned_neurons=vertcat(aligned_neurons{:});

corr_scores=vertcat(corr_scores{:});
corr_prc=vertcat(corr_prc{:});
dist=vertcat(dist{:});
dist_prc=vertcat(dist_prc{:});

indices=remove_duplicates(aligned_neurons,corr_scores);
aligned_neurons=aligned_neurons(indices,:);
corr_scores=corr_scores(indices,:);
dist=dist(indices,:);
corr_prc=corr_prc(indices,:);
dist_prc=dist_prc(indices,:);
