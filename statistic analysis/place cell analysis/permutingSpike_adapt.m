function [place_cells,Tinfo,infoScoreThresh,h,hv,infoScore] = permutingSpike_adapt(sectionIndex,neuron,behavpos,behavtime,behavROI,thresh,deltaTall,occThresh,nboot,binsize,infoScoreThreshold,i,temp,time_lag_period,Fs,conditionfolder1)
if ~exist('sectionIndex','var') || isempty(sectionIndex)
    sectionIndex = 1;
end

if ~exist('deltaTall','var') || isempty(deltaTall)
    deltaTall = randi([10,max(neuron.time)/1000-10],nboot,1)*1000;
end
if ~exist('occThresh','var') || isempty(occThresh)
    occThresh = 1;
end
if ~exist('nboot','var') || isempty(nboot)
    nboot = 100;
end
if ~exist('binsize','var') || isempty(binsize)
    binsize=15;
end

[firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuron,behavpos,behavtime,behavROI,binsize,1:size(neuron.S,1),[],temp,[],[],[0 10000]);  
% [firingrateAll,countAll,countTime] = calculatingCellSpatialForSingleData_adapted(neuron,behavpos,behavtime,behavROI,binsize,1:size(neuron.trace,1),[],temp,[],[],[0,10]);  %%%bin size suggests to be 15
% [firingrateAll,countAll,countTime] = calculatingCellSpatialLinearTrackForSingleData(neuron,behav,1:size(neuron.trace,1),thresh);
infoPerSecondnull = zeros(length(firingrateAll),1);infoPerSpikenull = infoPerSecondnull;
for j = 1:length(firingrateAll)
    if isempty(firingrateAll{j})
        firingrateAll{j}=nan(size(countTime,1),size(countTime,2));
    end
    MeanFiringRateAll= sum(sum(countAll{1,j}))/sum(sum(countTime));
    [infoPerSecondnull(j), infoPerSpikenull(j)] = Doug_spatialInfo(firingrateAll{j},MeanFiringRateAll, countTime,occThresh);
end

% deltaTall = randi([10,890],nboot,1)*1000;
% deltaTall = randi([20,880],nboot,1)*1000;
infoPerSecondboot = zeros(length(firingrateAll),nboot);
infoPerSpikeboot = infoPerSecondboot;


% load('neuronIndividuals_new.mat');
tic;
for nE = 1:nboot
    deltaT = deltaTall(nE);
%     neuron1 = neuronIndividuals_new{sectionIndex}.copy;  
    load('neuronIndividuals_new.mat');
    neuron=neuronIndividuals_new{sectionIndex};
    downsampling = length(neuron.time)/size(neuron.C,2);
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
%     SS=neuronboot.S;
%     CC=neuronboot.C;
%     if time_lag_period(3)==0
%         time_lag=Fs*randi([time_lag_period(1) time_lag_period(2)],size(CC,2),1);% sample rate: 15Hz, 10s: 150 points, interval:1/15s
%     else
%         tlag=randi([time_lag_period(1) time_lag_period(2)]);
%         time_lag=Fs*randi([tlag tlag],size(CC,2),1);% sample rate: 15Hz, 10s: 150 points, interval:1/15s
%     end
%     SS1=time_lag_rotation(SS,time_lag);
%     CC1=time_lag_rotation(CC,time_lag);
%     neuronboot.S=SS1;
%     neuronboot.C=CC1;
    [firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuronboot,behavpos,behavtime,behavROI,binsize,1:size(neuron.S,1),[],temp,[],[],[0 10000]);  
%     [firingrateAll,countAll,countTime] = calculatingCellSpatialForSingleData_adapted(neuronboot,behavpos,behavtime,behavROI,binsize,1:size(neuronboot.trace,1),[],temp,[],[],[0 10]);
    for j = 1:length(firingrateAll)
        MeanFiringRateAll= sum(sum(countAll{1,j}))/sum(sum(countTime));
        if isempty(firingrateAll{j})
            firingrateAll{j}=nan(size(countTime,1),size(countTime,2));
        end
        [infoPerSecondboot(j,nE), infoPerSpikeboot(j,nE)] = Doug_spatialInfo(firingrateAll{j},MeanFiringRateAll, countTime,occThresh);
    end
end
toc;

infoScore = [infoPerSecondnull,infoPerSecondboot];
% infoScore = [infoPerSpikenull,infoPerSpikeboot];
% infoScore=mean([infoPerSecondnull,infoPerSecondboot],2);
% infoScore_z=infoScore*0;
% infoScore_mean=zeros(size(infoScore,1),1);
% infoScore_std=zeros(size(infoScore,1),1);
% for i=1:size(infoScore,1)
%     infoScore_z(i,:)=zscore(infoScore(i,:));% skaggs 1994 et al.
%     infoScore_mean(i,1)=mean(infoScore(i,:));
%     infoScore_std(i,1)=std(infoScore(i,:));
% end
infoScoreThresh = quantile(infoScore(:),0.95);
% infoScoreThresh = quantile(infoScore_z(:),0.99);% skaggs 1994 et al.

% if i>1
%     infoScoreThresh=infoScoreThreshold;
% end
% infoScoreThresh =0.4513;

figure
% h=histogram(infoScore_z(:),'Normalization','probability');
% hv=h.Values*length(infoScore_z(:));
h=histogram(infoScore(:),'Normalization','probability');
hv=h.Values*length(infoScore(:));

hold on
ylim = get(gca,'ylim');
line([infoScoreThresh infoScoreThresh],get(gca,'ylim'),'LineStyle','--','Color','r','LineWidth',1)
% if min(infoScore_z(:))<max(infoScore_z(:))
% xlim([min(infoScore_z(:)),max(infoScore_z(:))])
% end
if min(infoScore(:))<max(infoScore(:))
xlim([min(infoScore(:)),max(infoScore(:))])
end

text(infoScoreThresh+0.05,range(ylim)/2,['Thresh = ',num2str(infoScoreThresh,'%.4f')],'Color','red','FontSize',8)
% place_cells = find(infoPerSecondnull > infoScoreThresh);

% TinfoPerSecond = table([1:length(infoPerSecondnull)]',infoPerSecondnull,'VariableNames',{'neuron','infoPerSecond'});
% Tinfo = table([1:length(infoPerSpikenull)]',infoPerSpikenull,infoScore_mean,infoScore_std,'VariableNames',{'neuron','infoScore','infoScore_mean','infoScore_std'});
% Tinfo = sortrows(Tinfo,{'infoScore'},{'descend'});
% place_cells = Tinfo.neuron((Tinfo.infoScore-Tinfo.infoScore_mean)./Tinfo.infoScore_std > infoScoreThresh);

Tinfo = table([1:length(infoPerSecondnull)]',infoPerSecondnull,infoScore,'VariableNames',{'neuron','infoPerSecond','infoScore'});
Tinfo = sortrows(Tinfo,{'infoPerSecond'},{'descend'});
place_cells = Tinfo.neuron(Tinfo.infoPerSecond > infoScoreThresh);

save([conditionfolder1,'/','place_cells_info_',conditionfolder1(1:end-16),'_binsize',num2str(binsize),'_',temp,'.mat'], 'place_cells', 'Tinfo', 'infoScore','infoScoreThresh');
saveas(gcf,[conditionfolder1,'/','neuron placement cells distribution_binsize',num2str(binsize),'_',temp,'.fig'],'fig');
saveas(gcf,[conditionfolder1,'/','neuron placement cells distribution_binsize',num2str(binsize),'_',temp,'.tif'],'tif');
saveas(gcf,[conditionfolder1,'/','neuron placement cells distribution_binsize',num2str(binsize),'_',temp,'.eps'],'epsc');
