function [group_aic,group_bic]=cluster_determine_by_suoqin_NMF_firstPeakCoph_aicbic(neuron0,N,maxKguess,clustNum)
intra_all_list=[];
intra_pair_num=[];
tic;

if isempty(clustNum)||~exist('clustNum','var')
    parfor k=2:maxKguess
        CM = consensusKmeans_adapted(neuron0,mean(3*std(neuron0.S,[],2)),k,N,[],[]); % return the simimarity matrix between paired neurons
        %[~,~,~,coph] = nmforderconsensus0(CM,k);
        Zf = linkage(CM,'complete');
        group=cluster(Zf,'maxclust',k);
        [intra_all,inter_all,~,~,intra_shuffle_all,~]=intra_inter_cluster_corr_dis({neuron0},group,1,'corr');
        intra_all_list(k-1)=log(mean(intra_all)/mean(inter_all));
        intra_pair_num(k-1)=length(intra_all);
        disp(['got ',num2str(k)]);
    end
    toc;

    % cophList_adjusted= smoothdata(cophList,'SmoothingFactor',0.5);
    [aic,bic]=aicbic(intra_all_list,[2:10],intra_pair_num);
    optimalK=find(aic==min(aic))+1;
    optimalK1=find(aic==min(aic))+1;
    CMf = consensusKmeans_adapted(neuron0,mean(3*std(neuron0.S,[],2)),optimalK,N,[],[]);
    Zf = linkage(CMf,'complete');
    group_aic=cluster(Zf,'maxclust',optimalK);
    CMf1 = consensusKmeans_adapted(neuron0,mean(3*std(neuron0.S,[],2)),optimalK1,N,[],[]);
    Zf1 = linkage(CMf1,'complete');
    group_bic=cluster(Zf1,'maxclust',optimalK1);
else
    optimalK=clustNum;
    CMf = consensusKmeans_adapted(neuron0,mean(3*std(neuron0.S,[],2)),optimalK,N,[],[]);
    Zf = linkage(CMf,'complete');
    group_aic=cluster(Zf,'maxclust',optimalK);
    group_bic=group_aic;
end
