%cluster isomap
cluster_filename_all={
    'baseline1_placement_cell_cluster\variables_clustering_0.35PC.mat';
    'baseline2_placement_cell_cluster\variables_clustering_0.35PC.mat';
    'baseline3_placement_cell_cluster\variables_clustering_0.35PC.mat';
    'F1_placement_cell_cluster\variables_clustering_0.35PC.mat';
    'FN1_placement_cell_cluster\variables_clustering_0.35PC.mat';
    'F2_placement_cell_cluster\variables_clustering_0.35PC.mat';
    'FN2_placement_cell_cluster\variables_clustering_0.35PC.mat';

    };

group_dat_all={};
dataC_all={};
colorClusters_all={};
positionC_all={};
optimalK_all={};

% generate data
load('neuronIndividuals_new.mat');
for i=1:length(cluster_filename_all)
    load(cluster_filename_all{i});
    group_dat_all{i}=group{i};
    colorClusters_all{i}=colorClusters;
    dataC_all{i} = [];
    for j = 1:length(unique(group_dat_all{i}))
        dataC_all{i} = [dataC_all{i};neuronIndividuals_new{i}.C(group_dat_all{i} == j,:)];
    end

    positionC_all{i} = [0];
    for j =1:length(unique(group_dat_all{i}))
        positionC_all{i}(j+1) = positionC_all{i}(j)+sum(group_dat_all{i} == j);
    end
    optimalK_all{i}=length(unique(group_dat_all{i}));
end

Y={};
for i=1:7
    group=group_dat_all{i};
    dataC=dataC_all{i};
    for j=1:length(unique(group))
        dataC_g1=dataC(group==j,:);

        dataC_g1_rate=toTimeVaryingRate(dataC_g1,60,15,'gaussian');
%         [coeff, score, latent, tsquared, explained, mu] = pca(double(dataC_g1_rate'));
%         data_out = kernelpca(double(dataC_g1_rate),3);

        D=squareform(pdist(dataC_g1_rate'));

        [Y{i,j}, R, E] = Isomap(D, 'k', 'k');
    end
end

ctt=1;
for i=1:7
    for j=1:7
        if ~isempty(Y{i,j})
            subplot(7,7,ctt)
            plot(Y{i,j}.coords{2}(1,:),Y{i,j}.coords{2}(2,:))
            ctt=ctt+1;
        end
    end
    ctt=i*7+1;
end