function [aligned_neurons,corr_scores,KL_scores]=align_using_linkage(neurons,links,overlap,height,width)
[aligned_neurons,corr_scores,KL_scores]=align_neurons_across_batches_via_links(neurons,links,overlap,height,width);
num_linked=sum(aligned_neurons>0,2);
linked_indices=find(num_linked>=length(neurons)/2);
aligned_neurons=aligned_neurons(linked_indices,:);
corr_scores=corr_scores(linked_indices,:);
KL_scores=KL_scores(linked_indices,:);
[aligned_neurons,corr_scores,KL_scores]=optimize_neuron_linkage(aligned_neurons,corr_scores,KL_scores);


[aligned_neurons,removed_indices]=remove_duplicates_adj(aligned_neurons,corr_scores);
keep_indices=setdiff(1:size(corr_scores,1),removed_indices);
corr_scores=corr_scores(keep_indices,:);
KL_scores=KL_scores(keep_indices,:);