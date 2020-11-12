function [neuron0,groupr,colorClusters,CM,dataC,dataSC,b,DC,uniform_score,groupshift1]=dynamicsAnalysisNew_parallel_adapted_022118_parts(thresh,neuronori,neuronIndall,infoScore,behavcell,nameparts1,nID,conditionfolder,baseinfoScoreThreshold,conditionbasedID,num2readt,parts,time_lag_period,Fs)
%%% temporal dynamical analysis of Ca2+ imaging data
%"conditionbasedID" variable means whether this analysis is based on a mandated
%condition. 0 means no mandate while 1,2,3 means baseline, training and
%testing
neuronIndividuals=cell(1,size(neuronIndall,2));
for i=1:size(neuronIndall,2)
neuronIndividuals{i}=neuronIndall{i}.copy;
end
neuron=neuronori.copy;
% idx_PC = [];%some times in one condition the trace activity is very small and we do not want it to be included in cluster analysis
% 
% % for i01=1:length(neuronIndividuals)
% %     idx_PC=[idx_PC;find(sum(neuronIndividuals{i01}.trace,2)<100)];% threshold for "small trace activity": 100
% % end
% 
% idx_PC=sort(idx_PC);
neuron0=[];%neuron0 is actually never used
neuronDeleted = [];
if size(neuron.C,1)-length(neuronDeleted)>5% some times there are only a small number of cells, so here when cell num is too small cluster analysis will stop 

%% filter the trail if the peak is extremely small when doing clustering
threshCluster = 0.1*max(neuron.C,[],2); % determine significance; non-significance cells will be put into individual cluster and not participate actually kmeans (as they may not able to go through)
threshCluster(neuronDeleted) = [];
for i = 1:length(neuronIndividuals1)
    neuronIndividuals1{i}.S(neuronDeleted,:) = [];
    neuronIndividuals1{i}.trace(neuronDeleted,:) = [];
    neuronIndividuals1{i}.centroid(neuronDeleted,:) = [];
    neuronIndividuals1{i}.C(neuronDeleted,:) = [];
    neuronIndividuals1{i}.C(neuronDeleted,:) = [];
    neuronIndividuals1{i}.A(:,neuronDeleted) = [];
    neuronIndividuals1{i}.Coor(neuronDeleted) = [];
end

neuronIndividuals2=cell(1,length(neuronIndividuals1)*parts);
for i = 1:length(neuronIndividuals1)
    lengt=size(neuronIndividuals1{i}.S,2);
    interval=[[1:round(lengt/parts):lengt],lengt];    
    for j=1:parts
        neuronIndividuals2{j+(i-1)*parts}=Sources2D;
        if ~isempty(neuronIndividuals1{i}.C)
            neuronIndividuals2{j+(i-1)*parts}.S = neuronIndividuals1{i}.S(:,interval(j):interval(j+1));
            neuronIndividuals2{j+(i-1)*parts}.trace =neuronIndividuals1{i}.trace(:,interval(j):interval(j+1)) ;
            neuronIndividuals2{j+(i-1)*parts}.C = neuronIndividuals1{i}.C(:,interval(j):interval(j+1)) ;
            neuronIndividuals2{j+(i-1)*parts}.C_raw = neuronIndividuals1{i}.C_raw(:,interval(j):interval(j+1)) ;
            neuronIndividuals2{j+(i-1)*parts}.C_df = neuronIndividuals1{i}.C_df(:,interval(j):interval(j+1)) ;
            neuronIndividuals2{j+(i-1)*parts}.time = neuronIndividuals1{i}.time(interval(j):interval(j+1),1) ;
%             neuronIndividuals2{j+(i-1)*parts}.pos = neuronIndividuals1{i}.pos(interval(j):interval(j+1),:) ;  
        end
        neuronIndividuals2{j+(i-1)*parts}.A = neuronIndividuals1{i}.A ;    
        neuronIndividuals2{j+(i-1)*parts}.centroid = neuronIndividuals1{i}.centroid ;  
        neuronIndividuals2{j+(i-1)*parts}.Coor = neuronIndividuals1{i}.Coor ;
        neuronIndividuals2{j+(i-1)*parts}.imageSize = neuronIndividuals1{i}.imageSize ;
        neuronIndividuals2{j+(i-1)*parts}.num2read = neuronIndividuals1{i}.num2read;
        neuronIndividuals2{j+(i-1)*parts}.numFrame = neuronIndividuals1{i}.numFrame;
    end
end
    
for ik=1:parts
    neuronIndividuals=neuronIndividuals2(ik:parts:ik+parts*(length(neuronIndividuals1)-1));
%% select the condition to be analyzed
neuronID = nID;

%% display the trail and overlay the neuron activity onto trajectories

%% performing clustering using kmeans+consensus clustering method
% using neuron.trace
%K = 3; % initial guess of the number of clusters
N = 100; % the number of repeated times
N1 = 100;
Klist=[1:8];
%optimalK = 4; % the optimal number of clusters
tic
tempK = consensus_Kmeans_numbers_guess_adapted(neuronIndividuals{neuronID},threshCluster,N1,Klist,time_lag_period,Fs);% optimalK=4;
toc;
K=tempK
optimalK=K+1;%max smaller than thresh will be regard as individual cluster

%% prepare cells for containing variables from all conditions
CM={1,length(neuronIndividuals)};
Z={1,length(neuronIndividuals)};
group={1,length(neuronIndividuals)};
threshC={1,length(neuronIndividuals)};
cgo={1,length(neuronIndividuals)};

% for i=1:length(neuronIndividuals) % loop all conditions to get all kinds of CM, Z, GROUP, THRESHC
i=neuronID;
CM{i} = consensusKmeans_adapted(neuronIndividuals{i},threshCluster,K,N,time_lag_period,Fs); % return the simimarity matrix between paired neurons
close all;
% Note: please determine the number of optimal clusters based on the pop-up clustergram
Z{i} = linkage(CM{i},'complete');
% group{i} = cluster(Z{i},'maxclust',optimalK);

%% move non sig cluster to cluster 1
group_temp=cluster(Z{i},'maxclust',optimalK);
group_temp=move_cluster_S_to_first(group_temp,neuronIndividuals{i}.C);

group{i}=group_temp;
%% 
threshC{i} = Z{i}(end-optimalK+2,3)-eps;
% reproduce the clustergram and assign different colors to each cluster
cgo{i} = clustergram(CM{i},'Standardize',3,'Linkage','complete','Colormap',redbluecmap);
set(cgo{i},'Dendrogram',threshC{i});
% end

if conditionbasedID~=0
i=conditionbasedID;
tic
tempK = consensus_Kmeans_numbers_guess_adapted(neuronIndividuals{i},threshCluster,N1,Klist,time_lag_period,Fs);% optimalK=4;
toc;
K=tempK
optimalK=K+1;
CM{i} = consensusKmeans_adapted(neuronIndividuals{i},threshCluster,K,N,time_lag_period,Fs); % return the simimarity matrix between paired neurons
close all;
% Note: please determine the number of optimal clusters based on the pop-up clustergram
%optimalK = 4; % the optimal number of clusters
Z{i} = linkage(CM{i},'complete');

%% move non sig cluster to cluster 1
group_temp=cluster(Z{i},'maxclust',optimalK);
group_temp=move_cluster_S_to_first(group_temp,neuronIndividuals{i}.C);

group{i}=group_temp;

%%
threshC{i} = Z{i}(end-optimalK+2,3)-eps;
% reproduce the clustergram and assign different colors to each cluster
cgo{i} = clustergram(CM{i},'Standardize',3,'Linkage','complete','Colormap',redbluecmap);
set(cgo{i},'Dendrogram',threshC{i});
end


close all force
%% rename the cluster asignment variables which give the cluster assignment for each neuron

%%  extract the order of neuron in the clustergram
cgolabels={1,length(neuronIndividuals)};
perm={1,length(neuronIndividuals)};
% for i=1:length(neuronIndividuals)
i=neuronID;
cgolabels{i} = cgo{i}.RowLabels;
[cgolabels{i},~,perm{i}] = intersect(cgolabels{i},cellstr(num2str([1:length(cgolabels{i})]')),'stable');

if conditionbasedID~=0
i=conditionbasedID;
cgolabels{i} = cgo{i}.RowLabels;
[cgolabels{i},~,perm{i}] = intersect(cgolabels{i},cellstr(num2str([1:length(cgolabels{i})]')),'stable');
end
% end
% permCT = perm; % please rename
% permCNO = perm;

%% generate different colors
colorClusters = distinguishable_colors(optimalK);
colorClusters(3,:)=[0,0.42,0];
colorClusters(4,:)=[0,0,0.1];
%colorClusters(4,:) = []; % the fourth is black
% colormap=[0,0,1;
%         0,1,0;
%         1,0,0;
%         1,0,1;
%         1,1,0;
%         1,0,1;
%         0,0,0.5;
%         0.5,0,0.5;
%         0.5,0,0;
%         0.5,0.5,0;
%         0,0.5,0;
%         0,0.5,0.5;
%         ];
% if nID==1
%     colorClusters=colormap([1 2 3 4],:);
% end
% if nID==2
%     colorClusters=colormap([5 6 7 8],:);
% end
% if nID==3
%     colorClusters=colormap([9 10 11 12],:);
% end
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
saveas(gcf,[conditionfolder,'/','cluster SimilarityHeatmap','_part',num2str(ik),'.fig'],'fig');
saveas(gcf,[conditionfolder,'/','cluster SimilarityHeatmap','_part',num2str(ik),'.tif'],'tif');
saveas(gcf,[conditionfolder,'/','cluster SimilarityHeatmap','_part',num2str(ik),'.eps'],'epsc');

%% distance and cluster
D = pdist(neuron.centroid);
D_pairwise_s=squareform(D);
if conditionbasedID==0
displaydistanceHeatmap_adapted(D_pairwise_s,D_pairwise_s,perm{neuronID},colorClusters,optimalK,group{neuronID},Z{neuronID})
else
displaydistanceHeatmap_adapted(D_pairwise_s,D_pairwise_s,perm{conditionbasedID},colorClusters,optimalK,group{conditionbasedID},Z{conditionbasedID})
end
saveas(gcf,[conditionfolder,'/','distance in or between cluster','_part',num2str(ik),'.fig'],'fig');
saveas(gcf,[conditionfolder,'/','distance in or between cluster','_part',num2str(ik),'.tif'],'tif');
saveas(gcf,[conditionfolder,'/','distance in or between cluster','_part',num2str(ik),'.eps'],'epsc');


%% SimilarityHeatmap regularity
%KL
CM_t=CM{neuronID};
CM_t=CM_t/sum(CM_t(:));% turn to probablistic 
CM_t_uniform=rand(size(CM_t));
CM_t_uniform=CM_t_uniform/sum(CM_t_uniform(:));
CM_t_1=reshape(CM_t,1,size(CM_t,1)*size(CM_t,2));
CM_t_uniform_1=reshape(CM_t_uniform,1,size(CM_t_uniform,1)*size(CM_t_uniform,2));
uniform_score(1)=kullback_leibler_divergence(CM_t_1,CM_t_uniform_1);

% suoqin's simple
CM_t=CM{neuronID};
group_t=group{neuronID};
unique_group_t=unique(group_t);
for i101=1:length(unique_group_t)
    CM_t(group_t==unique_group_t(i101),group_t==unique_group_t(i101))=0;
end
uniform_score(2)=sum(CM_t(:));

%% display the trace of each cluster
if conditionbasedID==0
displayTrace_adapted_parts(neuronIndividuals{neuronID},[], group{neuronID},[],colorClusters,conditionfolder,ik)
else
displayTrace_adapted_parts(neuronIndividuals{neuronID},[], group{conditionbasedID},[],colorClusters,conditionfolder,ik)
end


%% display spatial map
% colorCell6 = [248 118 109; 183 159 0; 0 186 56;0 191 196; 97 156 255; 245 100 227]/255;
showCenter = 1;showShape = 0;

if conditionbasedID==0
displayspatialMap(neuronIndividuals{neuronID},group{neuronID},colorClusters,showCenter,showShape)
else
displayspatialMap(neuronIndividuals{neuronID},group{conditionbasedID},colorClusters,showCenter,showShape)
end

axis([0 neuron.imageSize(2) 0 neuron.imageSize(1)])
set(gca,'Xtick',[]);set(gca,'Ytick',[]);
title('Spatial map');
save([conditionfolder,'/','variables_clustering_0.35PC.mat'],'group','colorClusters','CM');
saveas(gcf,[conditionfolder,'/','cluster spatial map','_part',num2str(ik),'.fig'],'fig');
saveas(gcf,[conditionfolder,'/','cluster spatial map','_part',num2str(ik),'.tif'],'tif');
saveas(gcf,[conditionfolder,'/','cluster spatial map','_part',num2str(ik),'.eps'],'epsc');

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
    saveas(gcf,[conditionfolder,'/','cluster spatial map shift group neuron','_part',num2str(ik),'.fig'],'fig');
    saveas(gcf,[conditionfolder,'/','cluster spatial map shift group neuron','_part',num2str(ik),'.tif'],'tif');
    saveas(gcf,[conditionfolder,'/','cluster spatial map shift group neuron','_part',num2str(ik),'.eps'],'epsc');
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
saveas(gcf,[conditionfolder,'/','cluster spatial map contour','_part',num2str(ik),'.fig'],'fig');
saveas(gcf,[conditionfolder,'/','cluster spatial map contour','_part',num2str(ik),'.tif'],'tif');
saveas(gcf,[conditionfolder,'/','cluster spatial map contour','_part',num2str(ik),'.eps'],'epsc');

%% using heatmap to show the firing/trace dynamics with the changes of frames/time
neuron.S(neuronDeleted,:) = [];
neuron.trace(neuronDeleted,:) = [];
dataC = [];

if conditionbasedID==0
    groupCT=group{neuronID};
else
    groupCT=group{conditionbasedID};
end

for j = 1:length(unique(groupCT))
    dataC = [dataC;neuron.C(groupCT == j,:)];
end

positionS = 0;
for il = 1:length(neuronIndividuals)
    if length(num2readt)>1
    positionS(il+1) = positionS(il)+num2readt(il+1);
    else
    positionS(il+1) = positionS(il)+num2readt;    
    end
    dataCi = [];
end
positionC = 0;
for il = 1:optimalK
    positionC(il+1) = positionC(il)+sum(groupCT == il);
end

figure
imagesc(dataC)
colormap(flipud(hot))
colorbar
hold on
flag = 1;
if flag
    for il = 2:length(positionS)-1
        line([positionS(il)+0.5 positionS(il)+0.5],get(gca,'YLim'),'LineWidth',0.5,'Color','k'); hold on;
    end
    for il = 2:length(positionC)-1
        line(get(gca,'XLim'),[positionC(il) positionC(il)],'LineWidth',0.5,'Color','k'); hold on;
    end
end
set(gca,'FontSize',8)
labels = strcat('C',cellstr(num2str([1:optimalK]')));
ytick0 = positionC(1:end-1)+diff(positionC)/2;
set(gca,'Ytick',ytick0);set(gca,'YtickLabel',labels,'FontName','Arial','FontSize',10)
xtick0 = positionS(1:end-1)+diff(positionS)/2;
xlabels = nameparts1;
set(gca,'Xtick',xtick0);set(gca,'XtickLabel',xlabels,'FontName','Arial','FontSize',10)
xtickangle(45)
xlabel('Frames','FontSize',10)
ylabel('Neurons','FontSize',10)

saveas(gcf,[conditionfolder,'/','cluster firing C dynamics','_part',num2str(ik),'.fig'],'fig');
saveas(gcf,[conditionfolder,'/','cluster firing C dynamics','_part',num2str(ik),'.tif'],'tif');
saveas(gcf,[conditionfolder,'/','cluster firing C dynamics','_part',num2str(ik),'.eps'],'epsc');
%% comparing the average trace (neuron.trace) among different conditions
if conditionbasedID==0
    groupCT=group{neuronID};
else
    groupCT=group{conditionbasedID};
end

dataS = zeros(size(neuronIndividuals{neuronID}.S,1),2);
position = 0;
for il = 1:length(neuronIndividuals)
    if ~isempty(neuronIndividuals{il}.C)
    dataS(:,il) = sum(neuronIndividuals{il}.C,2)/neuronIndividuals{il}.num2read;    
    end
    position(il+1) = position(il)+1;
end
dataSC = [];
for j = 1:length(unique(groupCT))
    dataSC = [dataSC;dataS(groupCT == j,:)];
end
figure
imagesc(dataSC)
colormap(flipud(hot))
c = colorbar;
c.Location = 'southoutside';
c.Label.String = 'dF/F per frame';
c.Label.FontSize = 8;c.Label.FontWeight = 'bold';c.FontSize = 6;
hold on
flag = 1;
if flag
    for il = 2:length(position)-1
        line([position(il)+0.5 position(il)+0.5],get(gca,'YLim'),'LineWidth',0.5,'Color','k'); hold on
    end
    for il = 2:length(positionC)-1
        line(get(gca,'XLim'),[positionC(il) positionC(il)],'LineWidth',0.5,'Color','k'); hold on;
    end
end
set(gca,'FontSize',8)
labels = strcat('C',cellstr(num2str([1:optimalK]')));
ytick0 = positionC(1:end-1)+diff(positionC)/2;
set(gca,'Ytick',ytick0);set(gca,'YtickLabel',labels,'FontName','Arial','FontSize',10)
set(gca,'Xtick',1:length(neuronIndividuals));
xlabels = nameparts1;
set(gca,'XtickLabel',xlabels,'FontName','Arial','FontSize',10)
xtickangle(45)
ylabel('Neurons','FontSize',10)

saveas(gcf,[conditionfolder,'/','cluster average C','_part',num2str(ik),'.fig'],'fig');
saveas(gcf,[conditionfolder,'/','cluster average C','_part',num2str(ik),'.tif'],'tif');
saveas(gcf,[conditionfolder,'/','cluster average C','_part',num2str(ik),'.eps'],'epsc');

%% intra-cluster and inter-cluster pairwise cell distance analysis
% (1) intra-cluster distance analysis
% (1.1) comparison the distance between Control and CNO conditions
% This map just shows the correlation between the traces in group. If the
% group is same, the result should be same.
if conditionbasedID==0
    groupCT=group{neuronID};
else
    groupCT=group{conditionbasedID};
end

DE = zeros(length(unique(groupCT)),2);
DC = zeros(length(unique(groupCT)),length(neuronIndividuals));
for il = 1:length(unique(groupCT))
    %     d = pdist(neuronIndividuals{1}.trace(groupCT == i,:));
    %     DE(i,1) = mean(d(:));
    %     d = pdist(neuronIndividuals{5}.trace(groupCT == i,:));
    %     DE(i,2) = mean(d(:));
    for k = 1:length(neuronIndividuals)
        if ~isempty(neuronIndividuals{k}.C)
        d = pdist(neuronIndividuals{k}.C(groupCT == il,:),'correlation');
        DC(il,k) = mean(1-d(:));
        end
    end
end
% display the average distance across all the cells in an individual cluster
% figure
% subplot(1,2,1);bar(DE)
% legend({'Control','CNO'});
% title('Cells grouped by Control clusters','FontSize',10,'FontWeight','bold')
% xlabel('Clusters','FontSize',10);
% ylabel('Avg intra-cluster pairwise cell distance','FontSize',10)
% xlim([0.5 size(DE,1)+0.5])
figure
% subplot(1,2,2);
b = bar(DC,'FaceColor','flat');
% legend({'Control','CNO'});
% title('Cells grouped by Control clusters','FontSize',10,'FontWeight','bold')
% load colormap7.mat
% for k = 1:size(DC,2)
%     b(k).FaceColor = cmap(k,:);
% end
set(gca,'XtickLabel',{'C1','C2','C3','C4'},'FontName','Arial','FontSize',10);
% legend(xlabels,'FontSize',8)
xlabel('Clusters','FontSize',10);
ylabel('Avg intra-cluster pairwise correlations','FontSize',10)
xlim([0.5 size(DC,1)+0.5])

saveas(gcf,[conditionfolder,'/','Avg intra-cluster pairwise correlations','_part',num2str(ik),'.fig'],'fig');
saveas(gcf,[conditionfolder,'/','Avg intra-cluster pairwise correlations','_part',num2str(ik),'.tif'],'tif');
saveas(gcf,[conditionfolder,'/','Avg intra-cluster pairwise correlations','_part',num2str(ik),'.eps'],'epsc');

end
else
fileID = fopen([conditionfolder,'/','placecell num to low.txt'],'w');
fprintf(fileID,'place cell number less than 5, too little for clustering. Clustering process stop');
fclose(fileID);
end

groupr=group{neuronID};