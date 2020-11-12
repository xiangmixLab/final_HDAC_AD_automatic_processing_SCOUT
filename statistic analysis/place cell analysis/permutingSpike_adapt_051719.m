
function [place_cells,infoScoreThresh,infoScoreSecondboot, infoScoreSpikeboot,infoPerSecondnull, infoPerSpikenull,TinfoPerSecond] = permutingSpike_adapt_091420(neuron,behavpos,behavtime,temp,occThresh,binsize,small_velo)

if ~exist('sectionIndex','var') || isempty(sectionIndex)
    sectionIndex = 1;
end

if ~exist('occThresh','var') || isempty(occThresh)
%     occThresh = 0.2; %061219 adjust code
      occThresh = 0.1;
end

if ~exist('nboot','var') || isempty(nboot)
    nboot = 500;
end

if ~exist('deltaTall','var') || isempty(deltaTall)
    deltaTall = randi([10,round(max(neuron.time)/1000)-10],nboot,1)*1000;
end

if ~exist('temp','var') || isempty(temp)
    temp = 'S';
end

if ~exist('binsize','var') || isempty(binsize)
    binsize=15;
end


countTimeThresh = [0 inf];

maxbehavROI=[0 0 max(behavpos(:,1)),max(behavpos(:,2))];
thresh=0.1*max(neuron.S,[],2);

[firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuron,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron.C,1),thresh,temp,[],[],countTimeThresh,small_velo);

infoPerSecondnull = zeros(length(firingrateAll),1);
infoPerSpikenull = infoPerSecondnull;

for j = 1:length(firingrateAll)
    MeanFiringRateAll= sum(sum(countAll{j}))/sum(sum(countTime));
    if isempty(firingrateAll{j})
        continue;
    end
    [infoPerSecondnull(j), infoPerSpikenull(j)] = Doug_spatialInfo(firingrateAll{j},MeanFiringRateAll, countTime,occThresh);
end

time0 = neuron.time;
S0 = neuron.S;
C0 = neuron.C;

infoPerSecondboot = zeros(length(firingrateAll),nboot);
infoPerSpikeboot = infoPerSecondboot;

for nE = 1:nboot

    neuron.time = time0; 
    neuron.S = S0; 
    neuron.C = C0;
 
    S1=trunk_shuffle_data(S0,100); % shuffle neuron time series, shuffle its correspondance with behavpos
    C1=trunk_shuffle_data(C0,100);
    
    neuronboot.time = timeboot;
    neuronboot.S = neuronboot.S(:,index);
    neuronboot.C = neuronboot.C(:,index);

    [firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuronboot,behavpos,behavtime,maxbehavROI,binsize,1:size(neuronboot.C,1),thresh,temp,[],[],countTimeThresh,small_velo);
    %061019 after smoothing we can get something like place field
%     for tk=1:length(firingrateAll)
%         if ~isempty(firingrateAll{tk})
%             firingrateAll{tk}=filter2DMatrices(firingrateAll{tk}, 1);
%         end
%     end
    infoPerSecondbootT = zeros(length(firingrateAll),1);infoPerSpikebootT = zeros(length(firingrateAll),1);

    for j = 1:length(firingrateAll)
        MeanFiringRateAll= sum(sum(countAll{1,j}))/sum(sum(countTime));
        [infoPerSecondbootT(j), infoPerSpikebootT(j)] = Doug_spatialInfo(firingrateAll{j},MeanFiringRateAll, countTime,occThresh);
    end
    infoPerSecondboot(:,nE) = infoPerSecondbootT; infoPerSpikeboot(:,nE) = infoPerSpikebootT;
end

infoScoreSecondboot = [infoPerSecondnull,infoPerSecondboot];

infoScoreSpikeboot = [infoPerSpikenull,infoPerSpikeboot];

if isequal(infosign,'sec')
    infoScore = infoPerSecondboot;    
    infoScore(neuron_lowFR,:) = [];
%     infoScoreThresh = quantile(infoScore(:),0.95);
    infoScoreThresh = quantile(infoScore,0.95,2);
%     infoScoreThresh = quantile(infoScore,0.99,2);% change to 0.99 061219
    TinfoPerSecond = table([1:length(infoPerSecondnull)]',infoPerSecondnull,infoScoreThresh,'VariableNames',{'neuron','infoScore','thresh'});
    TinfoPerSecond(neuron_lowFR,:) = [];
    TinfoPerSecond2 = sortrows(TinfoPerSecond,{'infoScore'},{'descend'});
    place_cells = TinfoPerSecond2.neuron(TinfoPerSecond2.infoScore > TinfoPerSecond2.thresh);
end
if isequal(infosign,'spk')
    infoScore = infoPerSpikeboot;    
    infoScore(neuron_lowFR,:) = [];
%     infoScoreThresh = quantile(infoScore(:),0.95);
    infoScoreThresh = quantile(infoScore,0.95,2);
%     infoScoreThresh = quantile(infoScore,0.99,2);% change to 0.99 061219
    TinfoPerSecond = table([1:length(infoPerSpikenull)]',infoPerSpikenull,infoScoreThresh,'VariableNames',{'neuron','infoScore','thresh'});
    TinfoPerSecond(neuron_lowFR,:) = [];
    TinfoPerSecond2 = sortrows(TinfoPerSecond,{'infoScore'},{'descend'});
    place_cells = TinfoPerSecond2.neuron(TinfoPerSecond2.infoScore > TinfoPerSecond2.thresh);
end

 
figure('position', [200, 200, 220,220]);
histogram(infoScore(:),'Normalization','probability');
hold on
infoScoreThresh1 = mean(infoScoreThresh);
ylim = get(gca,'ylim');
line([infoScoreThresh1 infoScoreThresh1],get(gca,'ylim'),'LineStyle','--','Color','r','LineWidth',1)
xlim([min(infoScore(:)),max(infoScore(:))])
text(infoScoreThresh1+0.05,range(ylim)/2,['Thresh = ',num2str(infoScoreThresh1,'%.4f')],'Color','red','FontSize',8)
xlabel('Spatial info score','FontSize',10)
ylabel('Frequency','FontSize',10)
title([session,': n=',num2str(length(infoPerSecondnull)),', ', '#place cell: ', num2str(length(place_cells))],'FontSize',10)

firingrateAll_pc=firingrateAll(place_cells);% place field use special thresholds, hence firing rate is different 061219

if ~isempty(conditionfolder1)
    save([conditionfolder1{sectionIndex},'/','place_cells_info_',conditionfolder1{sectionIndex}(1:end-16),'_binsize',num2str(binsize),'_',temp,'.mat'], 'place_cells', 'TinfoPerSecond', 'infoScore','infoScoreThresh','firingrateAll_pc');
    saveas(gcf,[conditionfolder1{sectionIndex},'/','neuron placement cells distribution_binsize',num2str(binsize),'_',temp,'.fig'],'fig');
    saveas(gcf,[conditionfolder1{sectionIndex},'/','neuron placement cells distribution_binsize',num2str(binsize),'_',temp,'.tif'],'tif');
    saveas(gcf,[conditionfolder1{sectionIndex},'/','neuron placement cells distribution_binsize',num2str(binsize),'_',temp,'.eps'],'epsc');
end
