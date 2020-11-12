function [groupr,colorClusters,CM,dataC,dataSC,b,DC,uniform_score,groupshift1,dis_mat]=dynamicsAnalysisNew_parallel_adapted_040519(neuronori,neuronIndall,nameparts1,nID,conditionfolder,conditionbasedID,num2readt)
%%% temporal dynamical analysis of Ca2+ imaging data
b=0;DC=[];
neuronIndividuals=cell(1,size(neuronIndall,2));
for i=1:size(neuronIndall,2)
    if ~isempty(neuronIndall{i})
        neuronIndividuals{i}=neuronIndall{i}.copy;
    end
end
neuron=neuronori.copy;
if 1% some times there are only a small number of cells, so here when cell num is too small cluster analysis will stop 

%% select the condition to be analyzed
neuronID = nID;
i=neuronID;
if conditionbasedID~=0
    i=conditionbasedID;
end

%% performing clustering using kmeans clustering method

CM={1,length(neuronIndividuals)};
Z={1,length(neuronIndividuals)};
group={1,length(neuronIndividuals)};
cgo={1,length(neuronIndividuals)};

K = 10; % initial guess of number of clusters
N = 100; % bootstrap iterations
Tcorr=0;
cophList=0;
cophList_adjusted=0;
optK=[];
% [group{i},CM{i},Z{i},Tcorr] = cluster_determine_by_corr_threshold(neuronIndividuals{i},K,N);
% [group{i},CM{i},Z{i},cophList,cophList_adjusted]=cluster_determine_by_suoqin_NMF(neuronIndividuals{i},N,K);
% [group{i},CM{i},Z{i}]=cluster_determine_by_suoqin_Gap(neuronIndividuals{i},N,K);
% [group{i},CM{i},Z{i}]=cluster_determine_by_suoqin_Silhouette(neuronIndividuals{i},N,K);
[group{i},CM{i},Z{i},cophList,cophList_adjusted]=cluster_determine_by_suoqin_NMF_firstPeakCoph(neuronIndividuals{i},N,K,optK);

%% move non sig cluster to cluster 1
group{i}=move_cluster_S_to_first(group{i},neuronIndividuals{i}.C);
close all force


%% generate different colors
optimalK=length(unique(group{i}));
colorClusters_all = distinguishable_colors(1500);
colorClusters=colorClusters_all(1+(i-1)*optimalK:(i)*optimalK,:);


%%
threshC{i} = Z{i}(end-optimalK+2,3)-eps;
cgo{i} = clustergram(CM{i},'Standardize',3,'Linkage','complete','Colormap',redbluecmap);
set(cgo{i},'Dendrogram',threshC{i});
close all force

%%  extract the order of neuron in the clustergram
cgolabels={1,length(neuronIndividuals)};
perm={1,length(neuronIndividuals)};
cgolabels{i} = cgo{i}.RowLabels;
[cgolabels{i},~,perm{i}] = intersect(cgolabels{i},cellstr(num2str([1:length(cgolabels{i})]')),'stable');
if conditionbasedID~=0
    cgolabels{i} = cgo{i}.RowLabels;
    [cgolabels{i},~,perm{i}] = intersect(cgolabels{i},cellstr(num2str([1:length(cgolabels{i})]')),'stable');
end

%% really start to generate the map needed
% figure;
% set(gcf,'outerposition',get(0,'screensize'));
%% display the simimarity matrix using heatmap
% displaySimilarityHeatmap(CM1,CM2,perm,colorClusters)
% CM1 is for showing the desired similarity matrix;
% CM2,perm,colorClusters are for reordering. If one wants to show the
% heatmap of CNO, but reorder the neuron according to the order in Control,
% then CM1 is the similarity of CNO, CM2,perm,colorClusters are the
% variables of Control.

%Here we use conditionbasedID to determine whether do SimilarityHeatmap to
%one condition itself or between current and mandate conditions

%This map just shows how robust a neuron is clustered into one group during
%the 1000 clustering experiment. If the neuron is always clustered into
%one group, the corresponding position will be more close to red.
if conditionbasedID==0
displaySimilarityHeatmap_adapted(CM{neuronID},CM{neuronID},perm{neuronID},colorClusters,optimalK,group{neuronID},Z{neuronID})
else
displaySimilarityHeatmap_adapted(CM{neuronID},CM{conditionbasedID},perm{conditionbasedID},colorClusters,optimalK,group{conditionbasedID},Z{conditionbasedID})
end
saveas(gcf,[conditionfolder,'/','cluster SimilarityHeatmap','.fig'],'fig');
saveas(gcf,[conditionfolder,'/','cluster SimilarityHeatmap','.tif'],'tif');
saveas(gcf,[conditionfolder,'/','cluster SimilarityHeatmap','.eps'],'epsc');

%% distance and cluster
D = pdist(neuron.centroid);
D_pairwise_s=squareform(D);
if conditionbasedID==0
displaydistanceHeatmap_adapted(D_pairwise_s,D_pairwise_s,perm{neuronID},colorClusters,optimalK,group{neuronID},Z{neuronID})
else
displaydistanceHeatmap_adapted(D_pairwise_s,D_pairwise_s,perm{conditionbasedID},colorClusters,optimalK,group{conditionbasedID},Z{conditionbasedID})
end
saveas(gcf,[conditionfolder,'/','distance in or between cluster','.fig'],'fig');
saveas(gcf,[conditionfolder,'/','distance in or between cluster','.tif'],'tif');
saveas(gcf,[conditionfolder,'/','distance in or between cluster','.eps'],'epsc');

unique_group=unique(group{neuronID});
dis_mat={};
for lk=1:length(unique_group)
intragroup_dis=D_pairwise_s(group{neuronID}==unique_group(lk),group{neuronID}==unique_group(lk));
intergroup_dis=D_pairwise_s(group{neuronID}==unique_group(lk),group{neuronID}~=unique_group(lk));
dis_mat{lk,1}=reshape(intragroup_dis,size(intragroup_dis,1)*size(intragroup_dis,2),1);
dis_mat{lk,2}=reshape(intergroup_dis,size(intergroup_dis,1)*size(intergroup_dis,2),1);
end
save([conditionfolder,'/','cluster intra inter distance','.mat'],'dis_mat');

%% cluster pairwise correlation
C1 = 1-pdist(neuronIndividuals{i}.C,'correlation');
C1_pairwise_s=squareform(C1);
if conditionbasedID==0
displaydistanceHeatmap_adapted(C1_pairwise_s,C1_pairwise_s,perm{neuronID},colorClusters,optimalK,group{neuronID},Z{neuronID})
else
displaydistanceHeatmap_adapted(C1_pairwise_s,C1_pairwise_s,perm{conditionbasedID},colorClusters,optimalK,group{conditionbasedID},Z{conditionbasedID})
end
saveas(gcf,[conditionfolder,'/','cluster pairwise correlation','.fig'],'fig');
saveas(gcf,[conditionfolder,'/','cluster pairwise correlation','.tif'],'tif');
saveas(gcf,[conditionfolder,'/','cluster pairwise correlation','.eps'],'epsc');

%% SimilarityHeatmap regularity
%KL
CM_t=CM{i};
CM_t=CM_t/sum(CM_t(:));% turn to probablistic 
CM_t_uniform=rand(size(CM_t));
CM_t_uniform=CM_t_uniform/sum(CM_t_uniform(:));
CM_t_1=reshape(CM_t,1,size(CM_t,1)*size(CM_t,2));
CM_t_uniform_1=reshape(CM_t_uniform,1,size(CM_t_uniform,1)*size(CM_t_uniform,2));
uniform_score(1)=kullback_leibler_divergence(CM_t_1,CM_t_uniform_1);

% suoqin's simple
% CM_t=CM{neuronID};
% group_t=group{neuronID};
% unique_group_t=unique(group_t);
% for i101=1:length(unique_group_t)
%     CM_t(group_t==unique_group_t(i101),group_t==unique_group_t(i101))=0;
% end
% uniform_score(2)=sum(CM_t(:));

% witnin-inter cluster corr ratio
group_t=group{neuronID};
[ratio,within_all,cross_all]=inter_intra_cluster_ratio_cal(unique(group_t),neuronIndividuals{i}.C,group_t);
uniform_score(2)=ratio;
%% display the trace of each cluster
if conditionbasedID==0
displayTrace_adapted(neuronIndividuals{neuronID},[], group{neuronID},[],colorClusters,conditionfolder)
else
displayTrace_adapted(neuronIndividuals{neuronID},[], group{conditionbasedID},[],colorClusters,conditionfolder)
end


%% display spatial map
% colorCell6 = [248 118 109; 183 159 0; 0 186 56;0 191 196; 97 156 255; 245 100 227]/255;
showCenter = 1;showShape = 0;

if conditionbasedID==0
displayspatialMap(neuronIndividuals{neuronID},group{neuronID},colorClusters,showCenter,showShape)
else
displayspatialMap(neuronIndividuals{neuronID},group{conditionbasedID},colorClusters,showCenter,showShape)
end

% axis([0 neuron.imageSize(2) 0 neuron.imageSize(1)])
set(gca,'Xtick',[]);set(gca,'Ytick',[]);
title('Spatial map');
save([conditionfolder,'/','variables_clustering_0.35PC.mat'],'group','colorClusters','CM','Tcorr','cophList_adjusted','cophList','cgolabels','perm');
saveas(gcf,[conditionfolder,'/','cluster spatial map','.fig'],'fig');
saveas(gcf,[conditionfolder,'/','cluster spatial map','.tif'],'tif');
saveas(gcf,[conditionfolder,'/','cluster spatial map','.eps'],'epsc');

%% spatial location change
groupshift=ones(size(group{neuronID}));
groupshift1=groupshift;
if conditionbasedID~=0    
    groupshift1=group{conditionbasedID};
    for i = 1:optimalK
        idx_previous_group_to_current_group=group{neuronID}(group{conditionbasedID}==i);
        current_group_index=mode(idx_previous_group_to_current_group);
        idx_shift=idx_previous_group_to_current_group~=current_group_index;
        groupindex=find(group{conditionbasedID}==i);
        groupshift(groupindex(idx_shift))=2;
        groupshift1(groupindex(~idx_shift))=groupshift1(groupindex(~idx_shift))*100+current_group_index*10+1;
        shift_group_index=idx_previous_group_to_current_group;
        shift_group_index((shift_group_index==current_group_index))=0;
        groupshift1(groupindex(idx_shift))=groupshift1(groupindex(idx_shift))*100+shift_group_index(idx_shift)*10+2;
    end
    displayspatialMap(neuronIndividuals{neuronID},groupshift,colorClusters,showCenter,showShape)
    axis([0 neuron.imageSize(2) 0 neuron.imageSize(1)])
    set(gca,'Xtick',[]);set(gca,'Ytick',[]);
    title('Spatial map shift group neuron');
    saveas(gcf,[conditionfolder,'/','cluster spatial map shift group neuron','.fig'],'fig');
    saveas(gcf,[conditionfolder,'/','cluster spatial map shift group neuron','.tif'],'tif');
    saveas(gcf,[conditionfolder,'/','cluster spatial map shift group neuron','.eps'],'epsc');
end

%% contour spatial map
% colorCell6 = [248 118 109; 183 159 0; 0 186 56;0 191 196; 97 156 255; 245 100 227]/255;
showCenter = 1;showShape = 0;

if conditionbasedID==0
displayspatialMap_contour(neuronIndividuals{neuronID},group{neuronID},colorClusters,showCenter,showShape,neuron.A)
else
displayspatialMap_contour(neuronIndividuals{neuronID},group{conditionbasedID},colorClusters,showCenter,showShape,neuron.A)
end

axis([0 neuron.imageSize(2) 0 neuron.imageSize(1)])
set(gca,'Xtick',[]);set(gca,'Ytick',[]);
title('Spatial map contour');
% save([conditionfolder,'/','variables_clustering_0.35PC.mat'],'group','colorClusters','CM');
saveas(gcf,[conditionfolder,'/','cluster spatial map contour','.fig'],'fig');
saveas(gcf,[conditionfolder,'/','cluster spatial map contour','.tif'],'tif');
saveas(gcf,[conditionfolder,'/','cluster spatial map contour','.eps'],'epsc');

%% using heatmap to show the firing/trace dynamics with the changes of frames/time
dataC = [];

if conditionbasedID==0
    groupCT=group{neuronID};
else
    groupCT=group{conditionbasedID};
end

for j = 1:length(unique(groupCT))
    dataC = [dataC;neuron.C(groupCT == j,:)];
end
% 
% positionS = 0;
% for i = 1:length(neuronIndividuals)
%     if length(num2readt)>1
%     positionS(i+1) = positionS(i)+num2readt(i+1);
%     else
%     positionS(i+1) = positionS(i)+num2readt;    
%     end
%     dataCi = [];
% end
% positionC = 0;
% for i = 1:optimalK
%     positionC(i+1) = positionC(i)+sum(groupCT == i);
% end
% 
% figure
% imagesc(dataC)
% colormap(jet)
% colorbar
% hold on
% flag = 1;
% if flag
%     for i = 2:length(positionS)-1
%         line([positionS(i)+0.5 positionS(i)+0.5],get(gca,'YLim'),'LineWidth',0.5,'Color','k'); hold on;
%     end
%     for i = 2:length(positionC)-1
%         line(get(gca,'XLim'),[positionC(i) positionC(i)],'LineWidth',0.5,'Color','k'); hold on;
%     end
% end
% set(gca,'FontSize',8)
% labels = strcat('C',cellstr(num2str([1:optimalK]')));
% ytick0 = positionC(1:end-1)+diff(positionC)/2;
% set(gca,'Ytick',ytick0);set(gca,'YtickLabel',labels,'FontName','Arial','FontSize',10)
% xtick0 = positionS(1:end-1)+diff(positionS)/2;
% xlabels = nameparts1;
% set(gca,'Xtick',xtick0);set(gca,'XtickLabel',xlabels,'FontName','Arial','FontSize',10)
% xtickangle(45)
% xlabel('Frames','FontSize',10)
% ylabel('Neurons','FontSize',10)
% 
% saveas(gcf,[conditionfolder,'/','cluster firing C dynamics','.fig'],'fig');
% saveas(gcf,[conditionfolder,'/','cluster firing C dynamics','.tif'],'tif');
% saveas(gcf,[conditionfolder,'/','cluster firing C dynamics','.eps'],'epsc');
%% comparing the average trace (neuron.trace) among different conditions
% if conditionbasedID==0
%     groupCT=group{neuronID};
% else
%     groupCT=group{conditionbasedID};
% end
% 
% dataS = zeros(size(neuronIndividuals{1}.S,1),2);
% position = 0;
% for i = 1:length(neuronIndividuals)
%     dataS(:,i) = sum(neuronIndividuals{i}.C,2)/neuronIndividuals{i}.num2read;
%     position(i+1) = position(i)+1;
% end
dataSC = [];
% for j = 1:length(unique(groupCT))
%     dataSC = [dataSC;dataS(groupCT == j,:)];
% end
% figure
% imagesc(dataSC)
% colormap(flipud(hot))
% c = colorbar;
% c.Location = 'southoutside';
% c.Label.String = 'dF/F per frame';
% c.Label.FontSize = 8;c.Label.FontWeight = 'bold';c.FontSize = 6;
% hold on
% flag = 1;
% if flag
%     for i = 2:length(position)-1
%         line([position(i)+0.5 position(i)+0.5],get(gca,'YLim'),'LineWidth',0.5,'Color','k'); hold on
%     end
%     for i = 2:length(positionC)-1
%         line(get(gca,'XLim'),[positionC(i) positionC(i)],'LineWidth',0.5,'Color','k'); hold on;
%     end
% end
% set(gca,'FontSize',8)
% labels = strcat('C',cellstr(num2str([1:optimalK]')));
% ytick0 = positionC(1:end-1)+diff(positionC)/2;
% set(gca,'Ytick',ytick0);set(gca,'YtickLabel',labels,'FontName','Arial','FontSize',10)
% set(gca,'Xtick',1:length(neuronIndividuals));
% xlabels = nameparts1;
% set(gca,'XtickLabel',xlabels,'FontName','Arial','FontSize',10)
% xtickangle(45)
% ylabel('Neurons','FontSize',10)
% 
% saveas(gcf,[conditionfolder,'/','cluster average C','.fig'],'fig');
% saveas(gcf,[conditionfolder,'/','cluster average C','.tif'],'tif');
% saveas(gcf,[conditionfolder,'/','cluster average C','.eps'],'epsc');
% 
%% intra-cluster and inter-cluster pairwise cell distance analysis
% (1) intra-cluster distance analysis
% (1.1) comparison the distance between Control and CNO conditions
% This map just shows the correlation between the traces in group. If the
% group is same, the result should be same.
% if conditionbasedID==0
%     groupCT=group{neuronID};
% else
%     groupCT=group{conditionbasedID};
% end
% 
% DE = zeros(length(unique(groupCT)),2);
% DC = zeros(length(unique(groupCT)),length(neuronIndividuals));
% for i = 1:length(unique(groupCT))
%     %     d = pdist(neuronIndividuals{1}.trace(groupCT == i,:));
%     %     DE(i,1) = mean(d(:));
%     %     d = pdist(neuronIndividuals{5}.trace(groupCT == i,:));
%     %     DE(i,2) = mean(d(:));
%     for k = 1:length(neuronIndividuals)
%         d = pdist(neuronIndividuals{k}.C(groupCT == i,:),'correlation');
%         DC(i,k) = mean(1-d(:));
%     end
% end
% % display the average distance across all the cells in an individual cluster
% % figure
% % subplot(1,2,1);bar(DE)
% % legend({'Control','CNO'});
% % title('Cells grouped by Control clusters','FontSize',10,'FontWeight','bold')
% % xlabel('Clusters','FontSize',10);
% % ylabel('Avg intra-cluster pairwise cell distance','FontSize',10)
% % xlim([0.5 size(DE,1)+0.5])
% figure
% % subplot(1,2,2);
% b = bar(DC,'FaceColor','flat');
% % legend({'Control','CNO'});
% % title('Cells grouped by Control clusters','FontSize',10,'FontWeight','bold')
% % load colormap7.mat
% % for k = 1:size(DC,2)
% %     b(k).FaceColor = cmap(k,:);
% % end
% set(gca,'XtickLabel',{'C1','C2','C3','C4'},'FontName','Arial','FontSize',10);
% % legend(xlabels,'FontSize',8)
% xlabel('Clusters','FontSize',10);
% ylabel('Avg intra-cluster pairwise correlations','FontSize',10)
% xlim([0.5 size(DC,1)+0.5])
% 
% saveas(gcf,[conditionfolder,'/','Avg intra-cluster pairwise correlations','.fig'],'fig');
% saveas(gcf,[conditionfolder,'/','Avg intra-cluster pairwise correlations','.tif'],'tif');
% saveas(gcf,[conditionfolder,'/','Avg intra-cluster pairwise correlations','.eps'],'epsc');


else
fileID = fopen([conditionfolder,'/','placecell num to low.txt'],'w');
fprintf(fileID,'place cell number less than 5, too little for clustering. Clustering process stop');
fclose(fileID);
end

groupr=group{neuronID};