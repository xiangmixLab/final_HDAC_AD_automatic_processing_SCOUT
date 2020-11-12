%% C
corr_offsetAll = [];
for i = 1:length(foldername)
    FiringRateAll={};
    load([foldername{i},'\','circle_info_score_placement_cell','\','place_cells_info_circle_info_scor_binsize10_C.mat']);
    load([foldername{i},'\','circle_results','\','single_cell_firing_profile.mat']);
    FiringRateAll(:,1)=firingrate;
    load([foldername{i},'\','square_results','\','single_cell_firing_profile.mat']); 
    FiringRateAll(:,2)=firingrate;
    FiringRateAll = cellfun(@replace_nan, FiringRateAll, repmat( {0}, size(FiringRateAll,1), size(FiringRateAll,2)) , 'UniformOutput', 0);
    corr_offset = zeros(length(place_cells),1);
    for j = 1:length(place_cells)
        rateMap1 = FiringRateAll{place_cells(j),1}; 
        rateMap2 = FiringRateAll{place_cells(j),2};
        cc = xcorr2(rateMap2,rateMap1);
        [max_cc, imax] = max(abs(cc(:)));
        [ypeak, xpeak] = ind2sub(size(cc),imax(1));
        offset = [(ypeak-size(rateMap1,1)) (xpeak-size(rateMap1,2))];
        corr_offset(j) = sqrt(offset(1)^2 + offset(2)^2);
    end
    corr_offsetAll = [corr_offsetAll;corr_offset];
end


corr_offsetAll_shuffled = [];
N=1000;
for i = 1:length(foldername)
    FiringRateAll={};
    load([foldername{i},'\','circle_info_score_placement_cell','\','place_cells_info_circle_info_scor_binsize10_C.mat']);
    load([foldername{i},'\','circle_results','\','single_cell_firing_profile.mat']);
    FiringRateAll(:,1)=firingrate;
    load([foldername{i},'\','square_results','\','single_cell_firing_profile.mat']); 
    FiringRateAll(:,2)=firingrate;
    FiringRateAll = cellfun(@replace_nan, FiringRateAll, repmat( {0}, size(FiringRateAll,1), size(FiringRateAll,2)) , 'UniformOutput', 0);
    corr_offset = zeros(N,1);
    for nboot = 1:N
    %    j = randperm(size(FiringRateAll,1),2);
        j = randi(length(place_cells),1,2);
        rateMap1 = FiringRateAll{place_cells(j(1)),1}; rateMap2 = FiringRateAll{place_cells(j(2)),2};
        cc = xcorr2(rateMap2,rateMap1);
        [max_cc, imax] = max(abs(cc(:)));
        [ypeak, xpeak] = ind2sub(size(cc),imax(1));
        offset = [(ypeak-size(rateMap1,1)) (xpeak-size(rateMap1,2))];
        corr_offset(nboot) = sqrt(offset(1)^2 + offset(2)^2);
    end
    corr_offsetAll_shuffled = [corr_offsetAll_shuffled;corr_offset];
end

% corr_offsetAll = corr_offsetAll*1.5;
% corr_offsetAll_shuffled = corr_offsetAll_shuffled*1.5;
figure;
corr_offsetAll = corr_offsetAll*1.0;
corr_offsetAll_shuffled = corr_offsetAll_shuffled*1.0;
figure
cdfplot(corr_offsetAll)
hold on
cdfplot(corr_offsetAll_shuffled)
legend({'Circle vs. Square','shuffled'})
ylabel('Cumulative probability'); xlabel('Shift (cm)')
[~,p] = kstest2(corr_offsetAll,corr_offsetAll_shuffled)


%% place field cross corrleation figure
allFiringRate={};
countt=1;
for i = 1:length(foldername)
    FiringRateAll={};
    load([foldername{i},'\','circle_info_score_placement_cell','\','place_cells_info_circle_info_scor_binsize10_C.mat']);
    load([foldername{i},'\','circle_results','\','single_cell_firing_profile.mat']);
    FiringRateAll(:,1)=firingrate;
    load([foldername{i},'\','square_results','\','single_cell_firing_profile.mat']); 
    FiringRateAll(:,2)=firingrate;
    FiringRateAll = cellfun(@replace_nan, FiringRateAll, repmat( {0}, size(FiringRateAll,1), size(FiringRateAll,2)) , 'UniformOutput', 0);
    corr_map = {};
    for j = 1:length(place_cells)
        rateMap1 = FiringRateAll{place_cells(j),1}; 
        rateMap2 = FiringRateAll{place_cells(j),2};
        cc = xcorr2(rateMap2,rateMap1);
        corr_map{j}=cc;
    end
    allFiringRate(countt:countt+length(corr_map)-1) = corr_map;
    countt=countt+length(corr_map);
end

sizee=[];
for i=1:length(allFiringRate)
    sizee(i,1)=size(allFiringRate{i},1);
    sizee(i,2)=size(allFiringRate{i},2);
end
% summ=zeros(max(sizee(:,1)),max(sizee(:,2)));
summ=[];
for i=1:length(allFiringRate)
    t=imresize(allFiringRate{i},[max(sizee(:,1)),max(sizee(:,2))]);
    summ(:,:,i)=t;
end
% summ=summ/length(allFiringRate);
% imagesc(max(summ,[],3));
figure;
imagesc(summ(:,:,37));
% imagesc(mean(summ,3));

title('neuronC');
colormap(jet);

%% S
corr_offsetAll = [];
for i = 1:length(foldername)
    FiringRateAll={};
    load([foldername{i},'\','circle_info_score_placement_cell','\','place_cells_info_circle_info_scor_binsize10_S.mat']);
    load([foldername{i},'\','circle_results','\','single_cell_firing_profile_S.mat']);
    FiringRateAll(:,1)=firingrateS;
    load([foldername{i},'\','square_results','\','single_cell_firing_profile_S.mat']); 
    FiringRateAll(:,2)=firingrateS;
    FiringRateAll = cellfun(@replace_nan, FiringRateAll, repmat( {0}, size(FiringRateAll,1), size(FiringRateAll,2)) , 'UniformOutput', 0);
    corr_offset = zeros(length(place_cells),1);
    for j = 1:length(place_cells)
        rateMap1 = FiringRateAll{place_cells(j),1}; 
        rateMap2 = FiringRateAll{place_cells(j),2};
        cc = xcorr2(rateMap2,rateMap1);
        [max_cc, imax] = max(abs(cc(:)));
        [ypeak, xpeak] = ind2sub(size(cc),imax(1));
        offset = [(ypeak-size(rateMap1,1)) (xpeak-size(rateMap1,2))];
        corr_offset(j) = sqrt(offset(1)^2 + offset(2)^2);
    end
    corr_offsetAll = [corr_offsetAll;corr_offset];
end


corr_offsetAll_shuffled = [];
N=1000;
for i = 1:length(foldername)
    FiringRateAll={};
    load([foldername{i},'\','circle_info_score_placement_cell','\','place_cells_info_circle_info_scor_binsize10_S.mat']);
    load([foldername{i},'\','circle_results','\','single_cell_firing_profile_S.mat']);
    FiringRateAll(:,1)=firingrateS;
    load([foldername{i},'\','square_results','\','single_cell_firing_profile_S.mat']); 
    FiringRateAll(:,2)=firingrateS;
    FiringRateAll = cellfun(@replace_nan, FiringRateAll, repmat( {0}, size(FiringRateAll,1), size(FiringRateAll,2)) , 'UniformOutput', 0);
    corr_offset = zeros(N,1);
    for nboot = 1:N
    %    j = randperm(size(FiringRateAll,1),2);
        j = randi(length(place_cells),1,2);
        rateMap1 = FiringRateAll{place_cells(j(1)),1}; rateMap2 = FiringRateAll{place_cells(j(2)),2};
        cc = xcorr2(rateMap2,rateMap1);
        [max_cc, imax] = max(abs(cc(:)));
        [ypeak, xpeak] = ind2sub(size(cc),imax(1));
        offset = [(ypeak-size(rateMap1,1)) (xpeak-size(rateMap1,2))];
        corr_offset(nboot) = sqrt(offset(1)^2 + offset(2)^2);
    end
    corr_offsetAll_shuffled = [corr_offsetAll_shuffled;corr_offset];
end

% corr_offsetAll = corr_offsetAll*1.5;
% corr_offsetAll_shuffled = corr_offsetAll_shuffled*1.5;
figure;
corr_offsetAll = corr_offsetAll*1.0;
corr_offsetAll_shuffled = corr_offsetAll_shuffled*1.0;
figure
cdfplot(corr_offsetAll)
hold on
cdfplot(corr_offsetAll_shuffled)
legend({'Circle vs. Square','shuffled'})
ylabel('Cumulative probability'); xlabel('Shift (cm)')
[~,p] = kstest2(corr_offsetAll,corr_offsetAll_shuffled)


%% place field cross corrleation figure
allFiringRate={};
countt=1;
for i = 1:length(foldername)
    FiringRateAll={};
    load([foldername{i},'\','circle_info_score_placement_cell','\','place_cells_info_circle_info_scor_binsize10_S.mat']);
    load([foldername{i},'\','circle_results','\','single_cell_firing_profile_S.mat']);
    FiringRateAll(:,1)=firingrateS;
    load([foldername{i},'\','square_results','\','single_cell_firing_profile_S.mat']); 
    FiringRateAll(:,2)=firingrateS;
    FiringRateAll = cellfun(@replace_nan, FiringRateAll, repmat( {0}, size(FiringRateAll,1), size(FiringRateAll,2)) , 'UniformOutput', 0);
    corr_map = {};
    for j = 1:length(place_cells)
        rateMap1 = FiringRateAll{place_cells(j),1}; 
        rateMap2 = FiringRateAll{place_cells(j),2};
        cc = xcorr2(rateMap2,rateMap1);
        corr_map{j}=cc;
    end
    allFiringRate(countt:countt+length(corr_map)-1) = corr_map;
    countt=countt+length(corr_map);
end

sizee=[];
for i=1:length(allFiringRate)
    sizee(i,1)=size(allFiringRate{i},1);
    sizee(i,2)=size(allFiringRate{i},2);
end
% summ=zeros(max(sizee(:,1)),max(sizee(:,2)));
summ=[];
for i=1:length(allFiringRate)
    t=imresize(allFiringRate{i},[max(sizee(:,1)),max(sizee(:,2))]);
    summ(:,:,i)=t;
end
% summ=summ/length(allFiringRate);
% imagesc(max(summ,[],3));
% 

figure;
imagesc(summ(:,:,137));
% imagesc(mean(summ,3));
title('neuronS');
colormap(jet);