%cluster spatial compactness analysis
function [boundary_all,region_all]=cluster_region_cal(group1,session,neuronIndividuals_new)
%% part1 make spatial footprint to colored regions

d1=neuronIndividuals_new{session}.imageSize(1);
d2=neuronIndividuals_new{session}.imageSize(2);

%region boundary
distt=squareform(pdist(neuronIndividuals_new{session}.centroid));
distt(distt==0)=inf;
neighboor_dis=mean(min(distt,[],1));
neighboor_dis_std=std(min(distt,[],1));
% neighboor_dis=min(distt,[],1);

boundary_all={};
for gp=1:length(unique(group1))
    %colored region step 1: get the centroid of one cluster
    cen=round(neuronIndividuals_new{session}.centroid(group1==gp,:));
    [IDX, isnoise]=DBSCAN_modified(cen,neighboor_dis+2*neighboor_dis_std,3,'dis');
%     [IDX, isnoise]=DBSCAN_modified(cen,quantile(neighboor_dis,0.9),3,'dis');
    
    %colored region step 2: get region boundary
    uIDX=unique(IDX);
    uIDX(uIDX==0)=[];
    for i=1:length(unique(IDX))
        cen_t=[cen(IDX==i,1),cen(IDX==i,2)];
        k=boundary(cen_t(:,1),cen_t(:,2),0.9);
        boundary_all{gp,i}=[cen_t(k,1),cen_t(k,2)];
%         plot(cen_t(:,2),cen_t(:,1),'.','MarkerSize',10);
%         hold on;
%         plot(cen_t(k,2),cen_t(k,1));
    end
end

%colored region step 3: fill boundary to get regions
region_all={};
for gp=1:length(unique(group1))
    for i=1:size(boundary_all,2)
        if ~isempty(boundary_all{gp,i})
            boundd=boundary_all{gp,i};
            Ai=poly2mask(boundd(:,2),boundd(:,1),d1,d2);
            region_all{gp,i}=Ai;
        end
    end
end


%experiment
% A_color=ones(d1*d2,3);
% colorClusters=distinguishable_colors(20);
% all_n=1:size(group1,1);
% gp=3;
% nidx=all_n(group1==gp)';
% for celll=1:length(nidx)
%     Ai=reshape(neuronIndividuals_new{session}.A(:,nidx(celll)),d1,d2);
%     Ai(Ai<0.65*max(Ai(:)))=0;
%     Ai=logical(Ai);
%     Ai=bwareaopen(Ai,9);
%     se=strel('disk',2);
%     Ai=imclose(Ai,se);
%     ind=find(Ai>0);%the pixels at which a neuron shows up
%     A_color(ind,:)=repmat(colorClusters(IDX(celll)+1,:),length(ind),1);
% end
% A_color=reshape(A_color,d1,d2,3);
% figure;
% imagesc(A_color)