function [group_all_1,group_all,group_model]=cluster_stability_illustrate_func(time_series,session,neuronIndividuals_new,win_leng,group_model)

total_leng=size(neuronIndividuals_new{session}.C,2);
% win_leng=round(total_leng/2);
% win_leng=4500;%5min
group_all={};
colorClusters=distinguishable_colors(50);

%% cluster cal
ct=1;
% time_series=1:win_leng/2:total_leng-win_leng/2;
if ~isempty(group_model)
    clust_size=length(unique(group_model));
    group_model_t{1}=group_model;
else
    disp('determining overall cluster size');
    all_group_size=[];
    for i=1:length(neuronIndividuals_new)
         [group_model_t{i}]=cluster_determine_by_suoqin_NMF_firstPeakCoph(neuronIndividuals_new{session},100,10,[]);
         all_group_size(i)=length(unique(group_model_t{i}));
    end
    clust_size=round(mean(all_group_size));
end
clc
disp(['overall cluster size: ',num2str(clust_size)]);
group_model=group_model_t{1};

for i=time_series
% for i=[1 round(total_leng/4)-1 round(total_leng/2)-1]
    neuronIndividuals_temp=neuronIndividuals_new{session}.copy;
    neuronIndividuals_temp.C=neuronIndividuals_temp.C(:,i:min(i+win_leng-1,total_leng));
    neuronIndividuals_temp.S=neuronIndividuals_temp.S(:,i:min(i+win_leng-1,total_leng));
    
    [group,CM,Z,cophList,cophList_adjusted]=cluster_determine_by_suoqin_NMF_firstPeakCoph_stability(neuronIndividuals_temp,100,10,clust_size);
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
try
for i=1:length(group_all)
    if ~isempty(group_model)
% group12: index of group1 inside group2
        [group_shared,group12,group21]=determineSharedCells_new(group_model,group_all_1{i});
        group_all_1{i}=group12;
    else
        if i>1
            [group_shared,group12,group21]=determineSharedCells_new(group_all_1{i-1},group_all_1{i});
            group_all_1{i}=group12;
        end
    end
    %plot anatomical cluster formation
%     group_all_1{i}=group_all{i};
%     d1=neuronIndividuals_new{session}.imageSize(1);
%     d2=neuronIndividuals_new{session}.imageSize(2);
%     A_color=ones(d1*d2,3);
%     for celll=1:size(neuronIndividuals_new{session}.C,1)
%         Ai=reshape(neuronIndividuals_new{session}.A(:,celll),d1,d2);
%         Ai(Ai<0.65*max(Ai(:)))=0;
%         Ai=logical(Ai);
%         Ai=bwareaopen(Ai,9);
%         se=strel('disk',2);
%         Ai=imclose(Ai,se);
%         ind=find(Ai>0);%the pixels at which a neuron shows up
%         A_color(ind,:)=repmat(colorClusters(group_all_1{i}(celll),:),length(ind),1);
%     end
%     
%     A_color=reshape(A_color,d1,d2,3);
%     subplot(2,round(length(group_all)/2),i)
%     imagesc(A_color);
%     drawnow;
%     clf
end
catch
end
