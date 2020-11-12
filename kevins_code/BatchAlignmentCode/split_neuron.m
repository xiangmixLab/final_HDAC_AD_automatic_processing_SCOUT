function [neuron_A,neuron_B]=split_neuron(neuron)
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


neuron_A.corr_scores=neuron.corr_scores(:,1:floor(neuron.num_batches/2));
neuron_A.corr_prc=neuron.corr_prc(:,1:floor(neuron.num_batches/2));
neuron_A.dist=neuron.dist(:,1:floor(neuron.num_batches/2));
neuron_A.dist_prc=neuron.dist_prc(:,1:floor(neuron.num_batches/2));

neuron_B.corr_scores=neuron.corr_scores(:,floor(neuron.num_batches/2)+1:end);
neuron_B.corr_prc=neuron.corr_prc(:,floor(neuron.num_batches/2)+1:end);
neuron_B.dist=neuron.dist(:,floor(neuron.num_batches/2)+1:end);
neuron_B.dist_prc=neuron.dist_prc(:,floor(neuron.num_batches/2)+1:end);
