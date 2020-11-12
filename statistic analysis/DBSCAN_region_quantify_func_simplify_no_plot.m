%DBSCAN region properities for different num of clusters
function [A_color,A_color_region,avg_max_region,avg_max_reg_shuf_all,avg_max_reg_shuf_all_95,A_color_region_rand]=DBSCAN_region_quantify_func_simplify_no_plot(group_record,clust_num,shuffles_num,clust_idx,cond_sign,neuronIndividuals_new)

conds=length(neuronIndividuals_new);
numClusts=length(clust_num);
shuffles=shuffles_num;
% 
boundary_all=cell(conds,numClusts);
region_all=cell(conds,numClusts);
boundary_all_shuffled=cell(conds,numClusts,shuffles);
region_all_shuffled=cell(conds,numClusts,shuffles);
tic;
for i=1:conds
    for j=1:numClusts
        [boundary_all{i,j},region_all{i,j}]=cluster_region_cal(group_record{i}{j},1,neuronIndividuals_new);
        for k=1:shuffles
            group_rand= group_record{i}{j}(randperm(length(group_record{i}{j})));
            [boundary_all_shuffled{i,j,k},region_all_shuffled{i,j,k}]=cluster_region_cal(group_rand,i,neuronIndividuals_new);      
        end
    end
    toc;
end
% 

% load(['C:\Users\exx\Desktop\HDAC paper fig and method\SFN2019\SFN2019 fig\DBSCAN regions\triangle_square_circle\M3412\boundary_and_region.mat']);

d1=neuronIndividuals_new{1}.imageSize(1);
d2=neuronIndividuals_new{1}.imageSize(2);
avg_max_region_shuffled={};
avg_max_peri_shuffled={};
[avg_max_region,avg_max_peri]=DBSCAN_region_perimeter_quantify_func(region_all,[d1,d2]);
for k=1:shuffles
    [avg_max_region_shuffled{k},avg_max_peri_shuffled{k},~,~,area_thresh_all]=DBSCAN_region_perimeter_quantify_func(region_all_shuffled(:,:,k),[d1,d2]);
end

avg_max_reg_shuf_all_dat=zeros(conds,numClusts,shuffles);
for p=1:shuffles
    avg_max_reg_shuf_all_dat(:,:,p)=avg_max_region_shuffled{p};
end
avg_max_reg_shuf_all=mean(avg_max_reg_shuf_all_dat,3);
avg_max_reg_shuf_all_95=quantile(avg_max_reg_shuf_all_dat,.95,3);


avg_max_peri_shuf_all_dat=zeros(conds,numClusts);
for p=1:shuffles
    avg_max_peri_shuf_all_dat(:,:,p)=avg_max_peri_shuffled{p};
end
avg_max_peri_shuf_all=mean(avg_max_peri_shuf_all_dat,3);
avg_max_peri_shuf_all_95=quantile(avg_max_peri_shuf_all_dat,.95,3);


% a1=figure;
% set(a1,'position',[0 0 1900 150*conds]);
% for i=1:conds
%     if conds>3
%        subplot(2,round(conds/2),i);
%     else
%        subplot(1,conds,i);
%     end
%     plot(avg_max_region(i,:),'b');
%     hold on;
%     plot(avg_max_reg_shuf_all(i,:),'--','color','r');
%     plot(avg_max_reg_shuf_all_95(i,:),'-.','color','g');
% end

% a2=figure;
% set(a2,'position',[0 0 1900 150*conds]);
% for i=1:conds
%     if conds>3
%        subplot(2,round(conds/2),i);
%     else
%        subplot(1,conds,i);
%     end
%     plot(avg_max_peri(i,:),'b');
%     hold on;
%     plot(avg_max_peri_shuf_all(i,:),'--','color','r');
%     plot(avg_max_peri_shuf_all_95(i,:),'-.','color','g');
% end


%clust_idx
if isempty(clust_idx)
    clust_idx=1;
end

%inneed: footprints
colorClusters_all=distinguishable_colors(10);
d1=neuronIndividuals_new{1}.imageSize(1);
d2=neuronIndividuals_new{1}.imageSize(2);
group=group_record{cond_sign}{clust_idx}; % just use the 4 cluster case as an example
A_color=cluster_spatial_footprint_colormap(neuronIndividuals_new,d1,d2,colorClusters_all,group);
group_rand=group_record{cond_sign}{clust_idx}(randperm(length(group_record{cond_sign}{clust_idx})));
A_color_rand=cluster_spatial_footprint_colormap(neuronIndividuals_new,d1,d2,colorClusters_all,group_rand);

% figure;
% subplot(121)
% imagesc(A_color);
% subplot(122)
% imagesc(A_color_rand);
% 
%inneed: regions
A_color_region=ones(d1*d2,3)*255;
for i=1:size(region_all{cond_sign,clust_idx},1)
    for j=1:size(region_all{cond_sign,clust_idx},2)
        if ~isempty(region_all{cond_sign,clust_idx}{i,j})
            region_t=region_all{cond_sign,clust_idx}{i,j}>0;
            region_t=bwareaopen(region_t,round(area_thresh_all{cond_sign,clust_idx}(i)));
            ind=find(region_t>0);%the pixels at which a neuron shows up
            A_color_region(ind,:)=repmat(colorClusters_all(i,:),length(ind),1);
        end
    end
end
A_color_region=reshape(A_color_region,d1,d2,3);


[~,region_all_shuffled_exp]=cluster_region_cal(group_rand,1,neuronIndividuals_new);      
A_color_region_rand=ones(d1*d2,3)*255;
for i=1:size(region_all_shuffled_exp,1)
    for j=1:size(region_all_shuffled_exp,2)
        if ~isempty(region_all_shuffled_exp{i,j})
            ind=find(region_all_shuffled_exp{i,j}>0);%the pixels at which a neuron shows up
            A_color_region_rand(ind,:)=repmat(colorClusters_all(i,:),length(ind),1);
        end
    end
end
A_color_region_rand=reshape(A_color_region_rand,d1,d2,3);

% 
% figure;
% subplot(121)
% imagesc(A_color_region);
% subplot(122)
% imagesc(A_color_region_rand);
