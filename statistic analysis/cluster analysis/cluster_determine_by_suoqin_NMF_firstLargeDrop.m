function [group,CMf,Zf,cophList,cophList_adjusted]=cluster_determine_by_suoqin_NMF_firstLargeDrop(neuron0,N,maxKguess)
cophList=[];
tic;
parfor k=2:maxKguess
    CM = consensusKmeans_adapted(neuron0,mean(3*std(neuron0.S,[],2)),k,N,[],[]); % return the simimarity matrix between paired neurons
    [~,~,~,coph] = nmforderconsensus0(CM,k);
    cophList(k)=coph;
    disp(['got ',num2str(k)]);
end
toc;

% cophList_adjusted= smoothdata(cophList,'SmoothingFactor',0.5);
cophList_adjusted=0;
cophList_dif=diff(cophList);
KList=[2:maxKguess];
optimalK=KList(min(cophList_dif)-1);

CMf = consensusKmeans_adapted(neuron0,mean(3*std(neuron0.S,[],2)),optimalK,N,[],[]);
Zf = linkage(CMf,'complete');
group=cluster(Zf,'maxclust',optimalK);
