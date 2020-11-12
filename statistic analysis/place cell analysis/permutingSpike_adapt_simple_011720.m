
function [place_cells,infoScoreThresh,infoScoreSecondboot, infoScoreSpikeboot,infoPerSecondnull, infoPerSpikenull,TinfoPerSecond,fr_final] = permutingSpike_adapt_simple_011720(nS,ntime,behavpos,behavtime,ROI,thresh,occThresh,nboot,binsize,infosign,small_velo)

if ~exist('occThresh','var') || isempty(occThresh)
%     occThresh = 0.2; %061219 adjust code
      occThresh = 0.1;
end

if ~exist('nboot','var') || isempty(nboot)
    nboot = 500;
end

if ~exist('binsize','var') || isempty(binsize)
    binsize=15;
end

if ~exist('infosign','var') || isempty(infosign)
    infosign = 'sec';
end

countTimeThresh = [0 inf];

tic;
[firingrateAll,countAll,~,countTime]=calculatingCellSpatialForSingleData_Suoqin_simplified(nS,ntime,behavpos,behavtime,ROI,binsize,thresh,countTimeThresh,small_velo);
toc;

infoPerSecondnull = zeros(length(firingrateAll),1);
infoPerSpikenull = infoPerSecondnull;

for j = 1:length(firingrateAll)
%     firingrateAll{j}=filter2DMatrices(firingrateAll{j},1);
    MeanFiringRateAll= sum(sum(countAll{j}))/sum(sum(countTime));
    if isempty(firingrateAll{j})
        continue;
    end
    [infoPerSecondnull(j), infoPerSpikenull(j)] = Doug_spatialInfo(firingrateAll{j},MeanFiringRateAll, countTime,occThresh);
end

infoPerSecondboot = zeros(length(firingrateAll),nboot);
infoPerSpikeboot = infoPerSecondboot;

tic;
fr_collection={};

deltaTall = randi([10,round(max(ntime)/1000)-10],nboot,1)*1000;

for nE = 1:nboot
    
%    nS_shuffle=trunk_shuffle_data(nS,10);
   nS_shuffle=suoqin_shuffle_data(nS,ntime,nE,thresh,deltaTall);
   [firingrateAll,countAll,~,countTime]=calculatingCellSpatialForSingleData_Suoqin_simplified(nS_shuffle,ntime,behavpos,behavtime,ROI,binsize,thresh,countTimeThresh,small_velo);
   
   infoPerSecondbootT = zeros(length(firingrateAll),1);
   infoPerSpikebootT = zeros(length(firingrateAll),1);
   for j = 1:length(firingrateAll)
%        firingrateAll{j}=filter2DMatrices(firingrateAll{j},1);
       MeanFiringRateAll= sum(sum(countAll{1,j}))/sum(sum(countTime));
       [infoPerSecondbootT(j), infoPerSpikebootT(j)] = Doug_spatialInfo(firingrateAll{j},MeanFiringRateAll, countTime,occThresh);
   end
   infoPerSecondboot(:,nE) = infoPerSecondbootT; 
   infoPerSpikeboot(:,nE) = infoPerSpikebootT;
   fr_collection{nE}=firingrateAll;
end
toc;

infoScoreSecondboot = [infoPerSecondnull,infoPerSecondboot];

infoScoreSpikeboot = [infoPerSpikenull,infoPerSpikeboot];
fr_final={};
if isequal(infosign,'sec')
    infoScore = infoPerSecondboot;    
    infoScoreThresh = quantile(infoScore,0.95,2);
    TinfoPerSecond = table([1:length(infoPerSecondnull)]',infoPerSecondnull,infoScoreThresh,'VariableNames',{'neuron','infoScore','thresh'});
    TinfoPerSecond2 = sortrows(TinfoPerSecond,{'infoScore'},{'descend'});
    place_cells = TinfoPerSecond2.neuron(TinfoPerSecond2.infoScore > TinfoPerSecond2.thresh);
end
if isequal(infosign,'spk')
    infoScore = infoPerSpikeboot;    
    infoScoreThresh = quantile(infoScore,0.95,2);
    TinfoPerSecond = table([1:length(infoPerSpikenull)]',infoPerSpikenull,infoScoreThresh,'VariableNames',{'neuron','infoScore','thresh'});
    TinfoPerSecond2 = sortrows(TinfoPerSecond,{'infoScore'},{'descend'});
    place_cells = TinfoPerSecond2.neuron(TinfoPerSecond2.infoScore > TinfoPerSecond2.thresh);
%     for i=1:size(infoPerSpikeboot,1)
%         infoPerSpikeboot_max_idx=find(infoPerSpikeboot(i,:)==max(infoPerSpikeboot(i,:)));
%         fr_final{i}=fr_collection{infoPerSpikeboot_max_idx}{i};
%     end
end

 
