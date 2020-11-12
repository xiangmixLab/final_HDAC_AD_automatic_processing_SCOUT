function place_cells=place_cells_determine_linearTrack(neuron,behavpos,behavtime,maxbehavROI,binsize,infosign,partsign)

xspan=max(behavpos(:,1))-min(behavpos(:,1));
yspan=max(behavpos(:,2))-min(behavpos(:,2));
if xspan>yspan
    behavpos(:,2)=ones(size(behavpos,1),1);
    maxbehavROI(4)=1;
else
    behavpos(:,1)=ones(size(behavpos,1),1);
    maxbehavROI(3)=1;
end
    
%% part 1: higher in-field rate method
if partsign(1)==1
    temp='S';
    countTimeThresh=[0 inf];
    small_velo=10;
    occThresh=0;
    trunk_num=10;

    nboot=1000;

    [firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuron,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron.C,1),0.1*max(neuron.C,[],2),temp,[],[],countTimeThresh,small_velo);

    for j = 1:length(firingrateAll)
        MeanFiringRateAll= sum(sum(countAll{j}))/sum(sum(countTime));
        if isempty(firingrateAll{j})
            continue;
        end
        [infoPerSecondnull(j), infoPerSpikenull(j)] = Doug_spatialInfo(firingrateAll{j},MeanFiringRateAll, countTime,occThresh);
    end

    infoPerSecondboot = zeros(length(firingrateAll),nboot);
    infoPerSpikeboot = infoPerSecondboot;

    for nE = 1:nboot

        neuronboot = neuron.copy;
        neuronboot.C=trunk_shuffle_data(neuronboot.C,trunk_num);
        neuronboot.S=trunk_shuffle_data(neuronboot.S,trunk_num);

        [firingrateAll,countAll,~,~] = calculatingCellSpatialForSingleData_Suoqin(neuronboot,behavpos,behavtime,maxbehavROI,binsize,1:size(neuronboot.C,1),0.1*max(neuron.C,[],2),temp,[],[],countTimeThresh,small_velo);

        infoPerSecondbootT = zeros(length(firingrateAll),1);infoPerSpikebootT = zeros(length(firingrateAll),1);

        for j = 1:length(firingrateAll)
            MeanFiringRateAll= sum(sum(countAll{1,j}))/sum(sum(countTime));
            if isempty(firingrateAll{j})
                continue;
            end
            [infoPerSecondbootT(j), infoPerSpikebootT(j)] = Doug_spatialInfo(firingrateAll{j},MeanFiringRateAll, countTime,occThresh);
        end
        infoPerSecondboot(:,nE) = infoPerSecondbootT; infoPerSpikeboot(:,nE) = infoPerSpikebootT;
    end

    % infoScoreSecondboot = [infoPerSecondnull,infoPerSecondboot];
    % infoScoreSpikeboot = [infoPerSpikenull,infoPerSpikeboot];

    if isequal(infosign,'sec')
        infothresh=quantile(infoPerSecondboot,0.90,2); % lower the thresh to 0.9
        place_cell_1=infoPerSecondnull>infothresh;
    end
    if isequal(infosign,'spk')
        infothresh=quantile(infoPerSpikeboot,0.90,2); % lower the thresh to 0.9
        place_cell_1=infoPerSpikenull>infothresh;
    end

else
    place_cell_1=ones(size(neuron.C,1),1);
end
%% part 2: spatial coherence

if partsign(2)==1
    [firingrateAll,countAll,~,~] = calculatingCellSpatialForSingleData_Suoqin(neuron,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron.C,1),0.1*max(neuron.C,[],2),temp,[],[],countTimeThresh,small_velo);

    sc=[];
    for j = 1:length(firingrateAll)
        if isempty(firingrateAll{j})
            sc(j)=0;
            continue;
        end
        sc(j) = spatial_coherence(firingrateAll{j});
    end

    % sc_shuffle=[];
    % for nE = 1:1000
    %  
    %     neuronboot = neuron.copy;
    %     neuronboot.C=trunk_shuffle_data(neuronboot.C,trunk_num);
    %     neuronboot.S=trunk_shuffle_data(neuronboot.S,trunk_num);
    %     
    %     [firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuronboot,behavpos,behavtime,maxbehavROI,binsize,1:size(neuronboot.C,1),thresh,temp,[],[],countTimeThresh,small_velo);
    % 
    %     for j=1:length(firingrateAll)
    %         sc_shuffle(j,nE)=spatial_coherence(firingrateAll{j});
    %     end
    % end

    place_cell_2=sc>quantile(sc,0.2); % this one may not be good to use the same method for infoscore, but not sure how to apply
    % a possible way is always choose the first 20%... however may lead to
    % small number of cells
    % or remove the last 30%
else
    place_cell_2=ones(size(neuron.C,1),1);
end

%% part 3: sparsity
if partsign(3)==1

    [firingrateAll,countAll,~,~] = calculatingCellSpatialForSingleData_Suoqin(neuron,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron.C,1),0.1*max(neuron.C,[],2),temp,[],[],countTimeThresh,small_velo);

    spr=[];
    for j = 1:length(firingrateAll)
        if isempty(firingrateAll{j})
            spr(j)=0;
            continue;
        end
        spr(j)=sparsity_place_cell(firingrateAll{j},countTime);
    end

    place_cell_3=spr<=quantile(spr,0.9); % remove the top 10%
else
    place_cell_3=ones(size(neuron.C,1),1);
end
%% final
place_cells=find(place_cell_1.*place_cell_2'.*place_cell_3'==1);
