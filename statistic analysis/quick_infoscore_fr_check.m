function [infoPerSecondnull,firingrateAll]=quick_infoscore_fr_check(neuron,behavpos,behavtime)

nboot = 500;
countTimeThresh = [0 inf];

binsize=10;
occThresh=0.1;
small_velo=10;
temp='S';
maxbehavROI=[0 0 max(behavpos(:,1)),max(behavpos(:,2))];
neuron.S=C_to_peakS(neuron.C);
% thresh=3*std(neuron.S,[],2);
thresh=0.1*max(neuron.S,[],2);

[firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuron,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron.C,1),thresh,temp,[],[],countTimeThresh,small_velo);

infoPerSecondnull = zeros(length(firingrateAll),1);
infoPerSpikenull = infoPerSecondnull;

for j = 1:length(firingrateAll)
%     MeanFiringRateAll= sum(sum(countAll{j}))/sum(sum(countTime));
    MeanFiringRateAll= sum(neuron.S(j,:)>0)/(size(neuron.S,2)/15); % suppose frame rate is 15f/sec
    if isempty(firingrateAll{j})
        continue;
    end
    [infoPerSecondnull(j), infoPerSpikenull(j)] = Doug_spatialInfo(firingrateAll{j},MeanFiringRateAll, countTime,occThresh);
end