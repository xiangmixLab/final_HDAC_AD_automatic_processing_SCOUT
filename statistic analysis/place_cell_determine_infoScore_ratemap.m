function place_cells=place_cell_determine_combine(neuron,behavpos,behavtime,maxbehavROI,binsize,infosign,partsign)

%% part 1: infoscore determine
if partsign(1)==1
    temp='S';
    countTimeThresh=[0 inf];
    small_velo=10;
    occThresh=0;
    trunk_num=10;

    nboot=100;

    [firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuron,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron.C,1),0.1*max(neuron.C,[],2),temp,[],[],countTimeThresh,small_velo);

    % % see if it will be better if we use uniform occupancy
    % countTime_u=(countTime./countTime)/sum(sum(countTime));
    % countTime=countTime_u;

    infoPerSecondnull = zeros(length(firingrateAll),1);
    infoPerSpikenull = infoPerSecondnull;

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

    place_cell_2=sc>quantile(sc,0.3); % this one may not be good to use the same method for infoscore, but not sure how to apply
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

    place_cell_3=spr<=0.25; % occupation smaller than 0.25 of box is potential place cell
else
    place_cell_3=ones(size(neuron.C,1),1);
end
%% final
place_cells=find(place_cell_1.*place_cell_2'.*place_cell_3'==1);
