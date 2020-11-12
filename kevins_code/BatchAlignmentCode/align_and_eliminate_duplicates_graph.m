function [aligned_neurons,corr_scores,dist,corr_prc,dist_prc]=align_and_eliminate_duplicates_graph(neurons,score_thresh,corr_thresh,dist_thresh,overlap,data_shape,corr_type,dist_meas)

[aligned_neurons,Distance]=align_subbatch_graph_search(neurons,score_thresh,overlap,data_shape,corr_type,dist_meas);

for i=1:ceil(length(neurons)/2)
    
    [corr_scores{i},dist{i},corr_prc{i},dist_prc{i}]=score_aligned_matrix(neurons(i:end),aligned_neurons{i}(:,i:end),i,overlap,data_shape,corr_type,dist_meas);
end
aligned_neurons=vertcat(aligned_neurons{:});

corr_scores=vertcat(corr_scores{:});
corr_prc=vertcat(corr_prc{:});
dist=vertcat(dist{:});
dist_prc=vertcat(dist_prc{:});
temp_corr=corr_scores;
temp_corr(temp_corr==0)=1;
indices=min(temp_corr,[],2)<corr_thresh|max(dist,[],2)>dist_thresh;

corr_scores(indices,:)=[];
dist(indices,:)=[];
corr_prc(indices,:)=[];
dist_prc(indices,:)=[];
aligned_neurons(indices,:)=[];

indices=remove_duplicates(aligned_neurons,corr_scores);
aligned_neurons=aligned_neurons(indices,:);
corr_scores=corr_scores(indices,:);
dist=dist(indices,:);
corr_prc=corr_prc(indices,:);
dist_prc=dist_prc(indices,:);
