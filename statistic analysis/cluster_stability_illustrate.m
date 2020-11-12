%cluster change in time

load('neuronIndividuals_new.mat');

session=2;
total_leng=size(neuronIndividuals_new{session}.C,2);
% win_leng=round(total_leng/2);
win_leng=4500;%5min
group_all={};
colorClusters=distinguishable_colors(50);

%% cluster cal
ct=1;
time_series=1:win_leng/2:total_leng-win_leng/2;
for i=time_series
% for i=[1 round(total_leng/4)-1 round(total_leng/2)-1]
    neuronIndividuals_temp=neuronIndividuals_new{session}.copy;
    neuronIndividuals_temp.C=neuronIndividuals_temp.C(:,i:min(i+win_leng-1,total_leng));
    neuronIndividuals_temp.S=neuronIndividuals_temp.S(:,i:min(i+win_leng-1,total_leng));
    
    [group,CM,Z,cophList,cophList_adjusted]=cluster_determine_by_suoqin_NMF_firstPeakCoph_stability(neuronIndividuals_temp,100,10,4);
    group=move_cluster_S_to_first(group,neuronIndividuals_temp.C);
    group_all{ct}=group;
    ct=ct+1;
end

%% draw anatomical map
%find corresponding group in current cluster result and assign its
%index to the same of pervious group
% figure;
figure;
group_all_1=group_all;
for i=1:length(group_all)
    if i>1
% group12: index of group1 inside group2
        [group_shared,group12,group21]=determineSharedCells_new(group_all_1{i-1},group_all_1{i});
        group_all_1{i}=group12;
    else
        group_all_1{i}=group_all{i};
    end
    %plot anatomical cluster formation
%     group_all_1{i}=group_all{i};
    d1=neuronIndividuals_new{session}.imageSize(1);
    d2=neuronIndividuals_new{session}.imageSize(2);
    A_color=ones(d1*d2,3);
    for celll=1:size(neuronIndividuals_new{session}.C,1)
        Ai=reshape(neuronIndividuals_new{session}.A(:,celll),d1,d2);
        Ai(Ai<0.65*max(Ai(:)))=0;
        Ai=logical(Ai);
        Ai=bwareaopen(Ai,9);
        se=strel('disk',2);
        Ai=imclose(Ai,se);
        ind=find(Ai>0);%the pixels at which a neuron shows up
        A_color(ind,:)=repmat(colorClusters(group_all_1{i}(celll),:),length(ind),1);
    end
    
    A_color=reshape(A_color,d1,d2,3);
    subplot(2,round(length(group_all)/2),i)
    imagesc(A_color);
    drawnow;
%     clf
end
    
%% cal cluster ensemble map
behav_name='triangle1_results/current_condition_behav.mat';
idx_all=zeros(1,size(neuronIndividuals_new{session}.C,2));

binsize=10;
cfolder2={};
ctt=1;
for i=1:win_leng/2:total_leng-win_leng/2
% for i=[1 round(total_leng/4)-1 round(total_leng/2)-1]
    cfolder2{ctt}=['C:\Users\exx\Desktop\HDAC paper fig and method\SFN2019\SFN2019 fig\panels\fig4\f',num2str(i)];
    idx_t=idx_all;
    idx_t(i:min(i+win_leng-1,total_leng))=1;
    idx_t1=resample(idx_t,length(neuronIndividuals_new{session}.time),size(neuronIndividuals_new{session}.C,2));
    idx_t=logical(idx_t);
    idx_t1=logical(idx_t1);
    
    neuronIndividuals_temp=neuronIndividuals_new{session}.copy;
    neuronIndividuals_temp.C=neuronIndividuals_temp.C(:,idx_t);
    neuronIndividuals_temp.S=neuronIndividuals_temp.S(:,idx_t);
    neuronIndividuals_temp.time=neuronIndividuals_temp.time(idx_t1);
    
    load(behav_name);
    behavpos_t=behavpos(idx_t1,:);
    behavtime_t=behavtime(idx_t1,:);
    
    load('thresh_and_ROI.mat');
    clustered_neuron_ensemble_analysis(neuronIndividuals_temp,group_all{ctt},behavpos_t,behavtime_t,maxbehavROI,binsize,thresh,[0 1000000], [],{},[0 8],[0 8],[0 10],[0 300],[0 100],[0 0.5],[0 0.5],cfolder2{ctt})
    ctt=ctt+1;
end


for itk=1:length(group_all)
    figure;
    hold on;
    set(gcf,'renderer','painters');
    group=group_all{itk};              
    uni_group=group;
    ctt=1;
    % range=[6 10];
    range=[1:length(unique(group))];
    % for i=1:length(unique(group))
    for i=range        
        load([cfolder2{itk},'\','cluster_ensemble_analysis','\','cluster',num2str(i),'_neuron_comparingfiringRate_S_binsize10data_S.mat'])
        subplot(2,round(length(range)/2),ctt);
    %     subplot(1,4,ctt);
        pcolor(firingRateSmoothing2);       
        axis ij
        shading flat;
        axis image
        axis off
        colorbar;
        colormap(jet);

        ctt=ctt+1;
    end
end

%% rand 