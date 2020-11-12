function [group,CMf,Zf]=cluster_determine_by_suoqin_eigenV(neuron0,N)
cophList=[];
tic;
% parfor k=1:maxKguess
%     CM = consensusKmeans_adapted_rep1(neuron0,3*std(neuron0.S(:)),k,N,[],[]); % return the simimarity matrix between paired neurons
%     [~,~,~,coph] = nmforderconsensus0(CM,k);
%     cophList(k)=coph;
%     disp(['got ',num2str(k)]);
% end
% CM=squareform(1-pdist(neuron0.C,'correlation'));
CM = consensusKmeans_adapted(neuron0,3*std(neuron0.S(:)),30,N,[],[]); % return the simimarity matrix between paired neurons
[eigenvalues,numCluster0,optimalK] = determineNumClusters(CM);
toc;

% cophList_adjusted= smoothdata(cophList,'SmoothingFactor',0.5);
% cophList_adjusted=0;
% [~,ploc]=findpeaks(cophList);
% KList=[1:maxKguess];
% optimalK=KList(min(ploc));

CMf = consensusKmeans_adapted(neuron0,3*std(neuron0.S(:)),optimalK,N,[],[]);
Zf = linkage(CMf,'complete');
group=cluster(Zf,'maxclust',optimalK);
