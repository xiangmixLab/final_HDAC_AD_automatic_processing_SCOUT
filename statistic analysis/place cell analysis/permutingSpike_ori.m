function [PlaceCells,TinfoPerSecond] = permutingSpike_ori(neuron,behav,thresh,deltaTall,occThresh,nboot)
% Pay attention if calculating by using neuron.trace or neuron.S in line 16 and line 45

% if ~exist('sessionIndex','var') || isempty(sessionIndex)
%     sectionIndex = 1;
% end
if ~exist('occThresh','var') || isempty(occThresh)
    occThresh = 1;
end
if ~exist('nboot','var') || isempty(nboot)
    nboot = 100;
end
if ~exist('deltaTall','var') || isempty(deltaTall)
    deltaTall = randi([10,max(neuron.time)/1000-10],nboot,1)*1000;
end
[firingrateAll,countAll,countTime] = calculatingCellSpatialForSingleData(neuron,behav,1:size(neuron.trace,1),thresh);
% [firingrateAll,countAll,countTime] = calculatingCellSpatialLinearTrackForSingleData2(neuron,behav,1:size(neuron.trace,1),thresh,'S');
infoPerSecondnull = zeros(length(firingrateAll),1);infoPerSpikenull = infoPerSecondnull;
for j = 1:length(firingrateAll)
    MeanFiringRateAll= sum(sum(countAll{1,j}))/sum(sum(countTime));
    [infoPerSecondnull(j), infoPerSpikenull(j)] = Doug_spatialInfo(firingrateAll{j},MeanFiringRateAll, countTime,occThresh);
end

% deltaTall = randi([10,890],nboot,1)*1000;
% deltaTall = randi([20,880],nboot,1)*1000;
infoPerSecondboot = zeros(length(firingrateAll),nboot);infoPerSpikeboot = infoPerSecondboot;

for nE = 1:nboot;
    deltaT = deltaTall(nE);
      load('Neuronf.mat'); 
      neuron = neuronf;
%       neuron = neuronIndividualsf{sessionIndex};
    downsampling = length(neuron.time)/size(neuron.trace,2);
    neuron.time = neuron.time(1:downsampling:end);
    neuronboot = neuron;
    for j = 1:size(neuron.S,1);
        threshI = thresh(j);
        idx = find(neuron.S(j,:)>threshI);
        neuronboot.time(idx) = neuron.time(idx)+deltaT;
        index = neuronboot.time > max(neuron.time);
        neuronboot.time(index) = neuronboot.time(index)-max(neuron.time);
        [neuronboot.time,index] = sort(neuronboot.time);
        neuronboot.S(j,:) = neuronboot.S(j,index);
        neuronboot.trace(j,:) = neuronboot.trace(j,index);
    end
    [firingrateAll,countAll,countTime] = calculatingCellSpatialForSingleData(neuronboot,behav,1:size(neuronboot.trace,1),thresh);
%     [firingrateAll,countAll,countTime] = calculatingCellSpatialLinearTrackForSingleData2(neuronboot,behav,1:size(neuronboot.trace,1),thresh,'S');
    for j = 1:length(firingrateAll);
        MeanFiringRateAll= sum(sum(countAll{1,j}))/sum(sum(countTime));
        [infoPerSecondboot(j,nE), infoPerSpikeboot(j,nE)] = Doug_spatialInfo(firingrateAll{j},MeanFiringRateAll, countTime,occThresh);
    end
end

infoScore = [infoPerSecondnull,infoPerSecondboot];
infoScoreThresh = quantile(infoScore(:),0.95);

figure
histogram(infoScore(:),'Normalization','probability');
hold on
ylim = get(gca,'ylim');
line([infoScoreThresh infoScoreThresh],get(gca,'ylim'),'LineStyle','--','Color','r','LineWidth',1)
xlim([min(infoScore(:)),max(infoScore(:))])
text(infoScoreThresh+0.05,range(ylim)/2,['Thresh = ',num2str(infoScoreThresh,'%.2f')],'Color','red','FontSize',8)
% place_cells = find(infoPerSecondnull > infoScoreThresh);

TinfoPerSecond = table([1:length(infoPerSecondnull)]',infoPerSecondnull,'VariableNames',{'neuron','infoPerSecond'});
TinfoPerSecond = sortrows(TinfoPerSecond,{'infoPerSecond'},{'descend'});
PlaceCells = TinfoPerSecond.neuron(TinfoPerSecond.infoPerSecond > infoScoreThresh);
