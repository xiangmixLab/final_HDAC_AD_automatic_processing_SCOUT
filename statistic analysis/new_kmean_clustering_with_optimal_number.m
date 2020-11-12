function [idx]=new_kmean_clustering_with_optimal_number(neuron)

nC=neuron.C;

eva = evalclusters(nC','kmeans','CalinskiHarabasz','KList',[2:10]);

K=eva.optimalK;

[idx,C] = kmeans(nC',K,'Distance','correlation','Replicates',100,'Options',opts,'UseParallel',1);