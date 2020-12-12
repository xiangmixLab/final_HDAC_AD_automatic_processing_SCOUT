
function [place_cells,all_infoScore] = permutingSpike_adapt_112020(neuron,behavpos,behavtime,temp,occThresh,binsize,small_velo,infosign)

if ~exist('occThresh','var') || isempty(occThresh)
%     occThresh = 0.2; %061219 adjust code
      occThresh = 0.1;
end

if ~exist('temp','var') || isempty(temp)
    temp = 'S';
end

if ~exist('binsize','var') || isempty(binsize)
    binsize=15;
end

% trim low fr neurons, they tend to have high infoscore but that doesn't
% necessarily mean they are place cells...

nboot = 100;
countTimeThresh = [0.1 inf]; 

maxbehavROI=[0 0 max(behavpos(:,1)),max(behavpos(:,2))];

neuron.S=C_to_peakS(neuron.C);
thresh=0.1*max(neuron.C,[],2);

[firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuron,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron.C,1),thresh,temp,[],[],countTimeThresh,small_velo);

infoPerSecondnull = zeros(length(firingrateAll),1);
infoPerSpikenull = infoPerSecondnull;

% h=fspecial('gaussian',[3 3],1);

for j = 1:length(firingrateAll)
    MeanFiringRateAll= sum(sum(countAll{j}))/sum(sum(countTime));
    if isempty(firingrateAll{j})
        continue;
    end
    
    frt=firingrateAll{j};
    frt=filter2DMatrices(firingrateAll{j},1);
%     frt=imgaussfilt(firingrateAll{j},1);
    [infoPerSecondnull(j), infoPerSpikenull(j)] = Doug_spatialInfo(frt,MeanFiringRateAll, countTime,occThresh);
end

S0 = neuron.S;
C0 = neuron.C;
time0 = neuron.time;

infoPerSecondboot = zeros(length(firingrateAll),nboot);
infoPerSpikeboot = infoPerSecondboot;

rng default % for reproduction
% rotate_leng=floor(size(S0,2)/(nboot+1));
C_dat=trunk_split_data(C0,100,'col');
S_dat=trunk_split_data(S0,100,'col');
for nE = 1:nboot
%     neuronboot=neuron.copy;
%     C1=trunk_shuffle_data_pre_split(C_dat);
%     S1=trunk_shuffle_data_pre_split(S_dat);
%     neuronboot.S = S1;
%     neuronboot.C = C1;
    neuronboot=trunk_shuffle_data_neuron_simple(C_dat,S_dat,time0);
%     neuronboot=trunk_rotate_data_neuron_simple(C0,S0,time0,nE*(size(S0,2)/15-100)/nboot);

    [firingrateAllt,countAllt,~,countTimet] = calculatingCellSpatialForSingleData_Suoqin(neuronboot,behavpos,behavtime,maxbehavROI,binsize,1:size(neuronboot.C,1),thresh,temp,[],[],countTimeThresh,small_velo);

    infoPerSecondbootT = zeros(length(firingrateAllt),1);infoPerSpikebootT = zeros(length(firingrateAllt),1);

    for j = 1:length(firingrateAllt)
        MeanFiringRateAll= sum(sum(countAllt{1,j}))/sum(sum(countTimet));
        frt=firingrateAllt{j};
        frt=filter2DMatrices(firingrateAllt{j},1);
%         frt=imgaussfilt(firingrateAll{j},1);
        [infoPerSecondbootT(j), infoPerSpikebootT(j)] = Doug_spatialInfo(frt,MeanFiringRateAll, countTimet,occThresh);
    end

    infoPerSecondboot(:,nE) = infoPerSecondbootT; 
    infoPerSpikeboot(:,nE) = infoPerSpikebootT;
end

infoScoreSecondboot = [infoPerSecondnull,infoPerSecondboot];

infoScoreSpikeboot = [infoPerSpikenull,infoPerSpikeboot];

if isequal(infosign,'sec')
    infoScore = infoScoreSecondboot;    
%     infoScore(neuron_lowFR,:) = [];
%     infoScoreThresh = quantile(infoScore(:),0.95);
    infoScoreThresh = quantile(infoScore,0.95,2);
%     infoScoreThresh = quantile(infoScore,0.99,2);% change to 0.99 061219
    TinfoPerSecond = table([1:length(infoPerSecondnull)]',infoPerSecondnull,infoScoreThresh,'VariableNames',{'neuron','infoScore','thresh'});
%     TinfoPerSecond(neuron_lowFR,:) = [];
    TinfoPerSecond2 = sortrows(TinfoPerSecond,{'infoScore'},{'descend'});
    place_cells = TinfoPerSecond2.neuron(TinfoPerSecond2.infoScore > TinfoPerSecond2.thresh);
end
if isequal(infosign,'spk')
    infoScore = infoScoreSpikeboot;    
%     infoScore(neuron_lowFR,:) = [];
%     infoScoreThresh = quantile(infoScore(:),0.95);
    infoScoreThresh = quantile(infoScore,0.95,2);
%     infoScoreThresh = quantile(infoScore,0.99,2);% change to 0.99 061219
    TinfoPerSecond = table([1:length(infoPerSpikenull)]',infoPerSpikenull,infoScoreThresh,'VariableNames',{'neuron','infoScore','thresh'});
%     TinfoPerSecond(neuron_lowFR,:) = [];
    TinfoPerSecond2 = sortrows(TinfoPerSecond,{'infoScore'},{'descend'});
    place_cells = TinfoPerSecond2.neuron(TinfoPerSecond2.infoScore > TinfoPerSecond2.thresh);
end
if isequal(infosign,'all')
    infoScore1 = infoScoreSecondboot;      
    infoScore2 = infoScoreSpikeboot; 
%     infoScore(neuron_lowFR,:) = [];
%     infoScoreThresh = quantile(infoScore(:),0.95);
    infoScoreThresh1 = quantile(infoScore1,0.95,2);
    infoScoreThresh2 = quantile(infoScore2,0.95,2);
%     infoScoreThresh = quantile(infoScore,0.99,2);% change to 0.99 061219
    
    place_cells = {find(infoPerSecondnull>infoScoreThresh1),find(infoPerSpikenull>infoScoreThresh2)};
end


all_infoScore=[infoPerSecondnull,infoPerSpikenull];