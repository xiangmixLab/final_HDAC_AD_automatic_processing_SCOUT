
function [place_cells,infoScoreThresh,infoScoreSecondboot, infoScoreSpikeboot,infoPerSecondnull, infoPerSpikenull,TinfoPerSecond] = permutingSpike_adapt_051719(file_neuronIndividuals,sectionIndex,neuron,behavpos,behavtime,maxbehavROI,thresh,temp,deltaTall,occThresh,nboot,binsize,session,neuron_lowFR,infosign,conditionfolder1,small_velo,varname)

if ~exist('sectionIndex','var') || isempty(sectionIndex)
    sectionIndex = 1;
end

if ~exist('occThresh','var') || isempty(occThresh)
%     occThresh = 0.2; %061219 adjust code
      occThresh = 0.1;
end

if ~exist('nboot','var') || isempty(nboot)
    nboot = 100;
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

if ~exist('session','var') || isempty(session)
    session = ' ';
end

if ~exist('neuron_lowFR','var') || isempty(neuron_lowFR)
    neuron_lowFR = [];
end

if ~exist('infosign','var') || isempty(infosign)
    infosign = 'sec';
end

countTimeThresh = [0 inf];
behav.position=behavpos;
behav.time=behavtime;
% [firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData(neuron,behav,binsize,1:size(neuron.C,1),thresh,temp,[],[],countTimeThresh);
[firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuron,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron.C,1),thresh,temp,[],[],countTimeThresh,small_velo);
% [firingrateAll,countAll,countTime] = calculate_firing_ratemap(neuron,behav,thresh,binsize);    

%061019 after smoothing we can get something like place field
% for tk=1:length(firingrateAll)
%     if ~isempty(firingrateAll{tk})
%         firingrateAll{tk}=filter2DMatrices(firingrateAll{tk}, 1);
%     end
% end

infoPerSecondnull = zeros(length(firingrateAll),1);
infoPerSpikenull = infoPerSecondnull;

for j = 1:length(firingrateAll)
    MeanFiringRateAll= sum(sum(countAll{j}))/sum(sum(countTime));
    if isempty(firingrateAll{j})
        continue;
    end
    [infoPerSecondnull(j), infoPerSpikenull(j)] = Doug_spatialInfo(firingrateAll{j},MeanFiringRateAll, countTime,occThresh);
end

load(file_neuronIndividuals,varname);
% load(file_neuronIndividuals,'neuronIndividualsf')
% neuronIndividuals_new = neuronIndividualsf;
np=eval(varname);
neuron = np{sectionIndex}.copy;

downsampling = length(neuron.time)/size(neuron.C,2);

neuron.time = neuron.time(1:downsampling:end);

time0 = neuron.time;

S0 = neuron.S;

trace0 = neuron.trace;

C0 = neuron.C;

infoPerSecondboot = zeros(length(firingrateAll),nboot);
infoPerSpikeboot = infoPerSecondboot;
    
tic;
parfor nE = 1:nboot
    deltaT = deltaTall(nE);
  
    neuronboot=neuron_shuffle_yj(neuron,time0,S0,trace0,C0,thresh,deltaT);
    [firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuronboot,behavpos,behavtime,maxbehavROI,binsize,1:size(neuronboot.C,1),thresh,temp,[],[],countTimeThresh,small_velo);

%     [firingrateAll,countAll,countTime] = calculate_firing_ratemap(neuronboot,behav,thresh,binsize);    
    [infoPerSecondbootT, infoPerSpikebootT]=Doug_spatialInfo_parellel(firingrateAll,countTime,occThresh,countAll);
    infoPerSecondboot(:,nE) = infoPerSecondbootT; infoPerSpikeboot(:,nE) = infoPerSpikebootT;
    disp(['fin',num2str(nE)]);
end
toc;

infoScoreSecondboot = [infoPerSecondnull,infoPerSecondboot];

infoScoreSpikeboot = [infoPerSpikenull,infoPerSpikeboot];

if isequal(infosign,'sec')
    infoScore = infoPerSecondboot;    
    infoScore(neuron_lowFR,:) = [];
%     infoScoreThresh = repmat(quantile(infoScore(:),0.95),size(infoScore,1),1);
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
%     infoScoreThresh = repmat(quantile(infoScore(:),0.95),size(infoScore,1),1);
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
    save([conditionfolder1{sectionIndex},'/','place_cells_info_',conditionfolder1{sectionIndex}(1:end-16),'_binsize',num2str(binsize),'_',temp,'_',infosign,'.mat'], 'place_cells', 'TinfoPerSecond', 'infoScore','infoScoreThresh','firingrateAll_pc');
    saveas(gcf,[conditionfolder1{sectionIndex},'/','neuron placement cells distribution_binsize',num2str(binsize),'_',temp,'_',infosign,'.fig'],'fig');
    saveas(gcf,[conditionfolder1{sectionIndex},'/','neuron placement cells distribution_binsize',num2str(binsize),'_',temp,'_',infosign,'.tif'],'tif');
    saveas(gcf,[conditionfolder1{sectionIndex},'/','neuron placement cells distribution_binsize',num2str(binsize),'_',temp,'_',infosign,'.eps'],'epsc');
end
