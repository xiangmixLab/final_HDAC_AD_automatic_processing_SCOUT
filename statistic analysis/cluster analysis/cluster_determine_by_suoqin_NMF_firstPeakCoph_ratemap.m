function [group,CMf,Zf,cophList,cophList_adjusted]=cluster_determine_by_suoqin_NMF_firstPeakCoph_ratemap(dat,N,maxKguess,clustNum)
cophList=[];
tic;

neuron0.C=dat;

if isempty(clustNum)||~exist('clustNum','var')
    parfor k=2:maxKguess
        CM = consensusKmeans_adapted(neuron0,zeros(size(dat,1),1),k,N,[],[]); % return the simimarity matrix between paired neurons
        [~,~,~,coph] = nmforderconsensus0(CM,k);
        cophList(k-1)=coph;
        disp(['got ',num2str(k)]);
    end
    toc;

    % cophList_adjusted= smoothdata(cophList,'SmoothingFactor',0.5);
    cophList_adjusted=0;
    [~,ploc]=findpeaks(cophList);
    KList=[2:maxKguess];
    if ~isempty(ploc)
        optimalK=KList(min(ploc));
    else
        cophList_dif=diff(cophList);
        optimalK=KList(find(cophList_dif==min(cophList_dif)));
    end
    CMf = consensusKmeans_adapted(neuron0,zeros(size(dat,1),1),optimalK,N,[],[]);
    Zf = linkage(CMf,'complete');
    group=cluster(Zf,'maxclust',optimalK);
else
    optimalK=clustNum;
    CMf = consensusKmeans_adapted(neuron0,zeros(size(dat,1),1),optimalK,N,[],[]);
    Zf = linkage(CMf,'complete');
    group=cluster(Zf,'maxclust',optimalK);

    cophList_adjusted=[];
end
