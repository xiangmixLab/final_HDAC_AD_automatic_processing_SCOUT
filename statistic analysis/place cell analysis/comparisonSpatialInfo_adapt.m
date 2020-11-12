function [infoPerSecond, infoPerSpike] = comparisonSpatialInfo_adapt(firingMap, count, countTime,occThresh,conditionfolder1,binsize)
num = length(firingMap);
% num = size(firingMap,3);
infoPerSecond = zeros(num,1);
infoPerSpike = zeros(num,1);

for i  = 1:num
    MeanFiringRateAll= nansum(nansum(count{i}))/nansum(nansum(countTime));
    if isempty(count{i})
        firingMap{i}=nan(size(count,1),size(count,2));
    end
    [infoPerSecond(i), infoPerSpike(i)] = Doug_spatialInfo(firingMap{i},MeanFiringRateAll, countTime,occThresh);
end
% save spatialFiringInfo.mat infoPerSecond infoPerSpike;

if ~isempty(conditionfolder1)
    figure
    subplot(1,2,1)
    bar(infoPerSecond)
    xlabel('Cell #','FontSize',12,'FontName','Arial')
    ylabel('infoPerSecond','FontSize',12,'FontName','Arial')
    subplot(1,2,2)
    bar(infoPerSpike)
    xlabel('Cell #','FontSize',12,'FontName','Arial')
    ylabel('infoPerSpike','FontSize',12,'FontName','Arial')

    save(['spatialInfoScore_',conditionfolder1(1:end-16),'_binsize',num2str(binsize),'.mat'],'infoPerSecond','infoPerSpike');
    saveas(gcf,[conditionfolder1,'/','neuron infoscore_binsize',num2str(binsize),'.fig'],'fig');
    saveas(gcf,[conditionfolder1,'/','neuron infoscore_binsize',num2str(binsize),'.tif'],'tif');
    saveas(gcf,[conditionfolder1,'/','neuron infoscore_binsize',num2str(binsize),'.eps'],'epsc');
end