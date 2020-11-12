%DBSCAN region properities for different num of clusters
function DBSCAN_region_quantify_func_region_make(savedir,data1,data2,fig1,fig2,fig3,fig4,foldername,group_record,clust_num,shuffles_num,clust_idx)

% cond_sign=1;
% 
mkdir(savedir);
load([foldername,'\','neuronIndividuals_new.mat']);
% 
% conds=length(neuronIndividuals_new);
% numClusts=length(clust_num);
% shuffles=shuffles_num;
% 
% boundary_all=cell(conds,numClusts);
% region_all=cell(conds,numClusts);
% boundary_all_shuffled=cell(conds,numClusts,shuffles);
% region_all_shuffled=cell(conds,numClusts,shuffles);
% tic;
% for i=1:conds
%     for j=1:numClusts
%         [boundary_all{i,j},region_all{i,j}]=cluster_region_cal(group_record{i}{j},2,neuronIndividuals_new);
%         for k=1:shuffles
%             group_rand= group_record{i}{j}(randperm(length(group_record{i}{j})));
%             [boundary_all_shuffled{i,j,k},region_all_shuffled{i,j,k}]=cluster_region_cal(group_rand,i,neuronIndividuals_new);      
%         end
%     end
%     toc;
% end
% 
% save([savedir,'\',data1],'boundary_all','boundary_all_shuffled','region_all','region_all_shuffled','-v7.3');
% 
% d1=neuronIndividuals_new{1}.imageSize(1);
% d2=neuronIndividuals_new{1}.imageSize(2);
% avg_max_region_shuffled={};
% avg_max_peri_shuffled={};
% [avg_max_region,avg_max_peri]=DBSCAN_region_perimeter_quantify_func(region_all,[d1,d2]);
% for k=1:shuffles
%     [avg_max_region_shuffled{k},avg_max_peri_shuffled{k}]=DBSCAN_region_perimeter_quantify_func(region_all_shuffled(:,:,k),[d1,d2]);
% end
% 
% save([savedir,'\',data2],'avg_max_region','avg_max_peri','avg_max_region_shuffled','avg_max_peri_shuffled','-v7.3');
% % tic
% % load([savedir,'\',data1]);
% % load([savedir,'\',data2])
% % toc;
% %plot
% avg_max_reg_shuf_all_dat=zeros(conds,numClusts,shuffles);
% for p=1:shuffles
%     avg_max_reg_shuf_all_dat(:,:,p)=avg_max_region_shuffled{p};
% end
% avg_max_reg_shuf_all=mean(avg_max_reg_shuf_all_dat,3);
% avg_max_reg_shuf_all_95=quantile(avg_max_reg_shuf_all_dat,.95,3);
% 
% 
% avg_max_peri_shuf_all_dat=zeros(conds,numClusts);
% for p=1:shuffles
%     avg_max_peri_shuf_all_dat(:,:,p)=avg_max_peri_shuffled{p};
% end
% avg_max_peri_shuf_all=mean(avg_max_peri_shuf_all_dat,3);
% avg_max_peri_shuf_all_95=quantile(avg_max_peri_shuf_all_dat,.95,3);
% 
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
% 
% saveas(gcf,[savedir,'\',fig1,'.fig'],'fig');
% saveas(gcf,[savedir,'\',fig1,'.tif'],'tif');
% saveas(gcf,[savedir,'\',fig1,'.eps'],'epsc');
% 
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
% 
% saveas(gcf,[savedir,'\',fig2,'.fig'],'fig');
% saveas(gcf,[savedir,'\',fig2,'.tif'],'tif');
% saveas(gcf,[savedir,'\',fig2,'.eps'],'epsc');
load([savedir,'\',data1]);
%clust_idx
if isempty(clust_idx)
    clust_idx=1;
end

%inneed: footprints
colorClusters_all=distinguishable_colors(10);
d1=neuronIndividuals_new{1}.imageSize(1);
d2=neuronIndividuals_new{1}.imageSize(2);

figure;
subplot(121)
group=group_record{cond_sign}{clust_idx}; % just use the 4 cluster case as an example
A_color=cluster_spatial_footprint_colormap(neuronIndividuals_new,d1,d2,colorClusters_all,group);
imagesc(A_color);

subplot(122)
group_rand=group_record{cond_sign}{clust_idx}(randperm(length(group_record{cond_sign}{clust_idx})));
A_color_rand=cluster_spatial_footprint_colormap(neuronIndividuals_new,d1,d2,colorClusters_all,group_rand);
imagesc(A_color_rand);

saveas(gcf,[savedir,'\',fig3,'.fig'],'fig');
saveas(gcf,[savedir,'\',fig3,'.tif'],'tif');
saveas(gcf,[savedir,'\',fig3,'.eps'],'epsc');

%inneed: regions
figure;
subplot(121)
A_color_region=ones(d1*d2,3)*255;
for i=1:size(region_all{cond_sign,clust_idx},1)
    for j=1:size(region_all{cond_sign,clust_idx},2)
        if ~isempty(region_all{cond_sign,clust_idx}{i,j})
            ind=find(region_all{cond_sign,clust_idx}{i,j}>0);%the pixels at which a neuron shows up
            A_color_region(ind,:)=repmat(colorClusters_all(i,:),length(ind),1);
        end
    end
end
A_color_region=reshape(A_color_region,d1,d2,3);
imagesc(A_color_region);

subplot(122)
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
imagesc(A_color_region_rand);


saveas(gcf,[savedir,'\',fig4,'.fig'],'fig');
saveas(gcf,[savedir,'\',fig4,'.tif'],'tif');
saveas(gcf,[savedir,'\',fig4,'.eps'],'epsc');

close all;