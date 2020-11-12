function [group,CMf,Zf,cophList,cophList_adjusted]=cluster_determine_by_suoqin_NMF(neuron0,N,maxKguess)
cophList=[];
tic;
parfor k=1:maxKguess
    CM = consensusKmeans_adapted_rep1(neuron0,3*std(neuron0.S(:)),k,N,[],[]); % return the simimarity matrix between paired neurons
    [~,~,~,coph] = nmforderconsensus0(CM,k);
    cophList(k)=coph;
    disp(['got ',num2str(k)]);
end
toc;

% cophList_adjusted= smoothdata(cophList,'SmoothingFactor',0.5);
cophList_adjusted=0;
[pks,KList]=findpeaks(cophList);
[~,ploc]=findpeaks(pks);
optimalK=KList(min(ploc));

CMf = consensusKmeans_adapted(neuron0,3*std(neuron0.S(:)),optimalK,N,[],[]);
Zf = linkage(CMf,'complete');
group=cluster(Zf,'maxclust',optimalK);
