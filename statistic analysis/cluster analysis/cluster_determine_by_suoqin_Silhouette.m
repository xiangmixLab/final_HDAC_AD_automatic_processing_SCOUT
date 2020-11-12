function [group,CMf,Zf]=cluster_determine_by_suoqin_Silhouette(neuron0,N,maxKguess)

E = evalclusters(neuron0.C,'kmeans','Silhouette','klist',[2:maxKguess]);
optimalK=E.OptimalK;

for i=1:size(neuron0.C,1)
    t=neuron0.C(i,:);
    [pks,loc]=findpeaks(t);
    t1=t*0;
    t(loc)=pks;
    neuron0.S(i,:)=t1;
end
CMf = consensusKmeans_adapted(neuron0,mean(3*std(neuron0.S,[],2)),optimalK,N,[],[]);
Zf = linkage(CMf,'complete');
group=cluster(Zf,'maxclust',optimalK);
