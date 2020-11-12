function [group,CMf,Zf,cophList,cophList_adjusted]=cluster_determine_by_suoqin_NMF_firstPeakCoph(neuron0,N,maxKguess,optimalK_preDefine)
cophList=[];
cophList_adjusted=0;
tic;

if isempty(optimalK_preDefine)
    parfor k=2:maxKguess
        CM = consensusKmeans_adapted(neuron0,mean(3*std(neuron0.S,[],2)),k,N,[],[]); % return the simimarity matrix between paired neurons
        [~,~,~,coph] = nmforderconsensus0(CM,k);
        cophList(k-1)=coph;
        disp(['got ',num2str(k)]);
    end
    toc;

    % cophList_adjusted= smoothdata(cophList,'SmoothingFactor',0.5);

    [~,ploc]=findpeaks(cophList);
    KList=[2:maxKguess];
    if ~isempty(ploc)
        optimalK=KList(min(ploc));
    else
        cophList_dif=diff(cophList);
        optimalK=KList(find(cophList_dif==min(cophList_dif)));
    end

else
    optimalK=optimalK_preDefine;
end
    
CMf = consensusKmeans_adapted(neuron0,mean(3*std(neuron0.S,[],2)),optimalK,N,[],[]);
Zf = linkage(CMf,'complete');
group=cluster(Zf,'maxclust',optimalK);
