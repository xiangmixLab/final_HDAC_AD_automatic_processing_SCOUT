function [neuron_A,neuron_B]=split_neuron_adj(neuron)
neuron_A=Sources2D;
neuron_B=Sources2D;
neuron_A.C=neuron.C(:,1:size(neuron.C,2)/2);
neuron_B.C=neuron.C(:,size(neuron.C,2)/2+1:end);
neuron_A.C_raw=neuron.C(:,1:size(neuron.C,2)/2);
neuron_B.C_raw=neuron.C(:,size(neuron.C,2)/2+1:end);
neuron_A.S=neuron.S(:,1:size(neuron.C,2)/2);
neuron_B.S=neuron.S(:,size(neuron.C,2)/2+1:end);
neuron_A.A_per_batch=neuron.A_per_batch(1:ceil(length(neuron.A_per_batch)/2));
neuron_B.A_per_batch=neuron.A_per_batch(floor(length(neuron.A_per_batch)/2)+1:end);
neuron_A.centroids_per_batch=neuron.centroids_per_batch(1:ceil(length(neuron.A_per_batch)/2));
neuron_B.centroids_per_batch=neuron.centroids_per_batch(floor(length(neuron.A_per_batch)/2)+1:end);
neuron_A.corr_scores=neuron.corr_scores(:,1:length(neuron.A_per_batch)/2);
neuron_B.corr_scores=neuron.corr_scores(:,length(neuron.A_per_batch)/2+1:end);

neuron_A.KL_scores=neuron.KL_scores(:,1:length(neuron.A_per_batch)/2);
neuron_B.KL_scores=neuron.KL_scores(:,length(neuron.A_per_batch)/2+1:end);
