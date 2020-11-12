
function [all_dis_corr_circle_all_intra,all_dis_corr_circle_all_inter]=pairwise_dis_spatCorr(foldername,cluster_file_name,field_file_name,session)

all_dis_circle_intra={};
all_corr_circle_intra={};
all_dis_circle_inter={};
all_corr_circle_inter={};

for k=1:length(foldername)
   
cd(foldername{k});
    load(field_file_name);
    load('neuronIndividuals_new.mat');
    load(cluster_file_name)
    group=group{session};              
    uni_group=unique(group);

    dis_all=squareform(pdist(neuronIndividuals_new{session}.centroid));
    corr_all1=[];
    ct=1;
    tic
    for k1=1:length(firingrateS)
        for k2=k1:length(firingrateS)
            if ~isempty(firingrateS{k1})&&~isempty(firingrateS{k2})
                firingrateS{k1}=filter2DMatrices(firingrateS{k1},1);
                firingrateS{k2}=filter2DMatrices(firingrateS{k2},1);
                cross_corr=normxcorr2(firingrateS{k1},firingrateS{k2});
%                 corr_all1(ct)=max(max(cross_corr/mean(cross_corr(:))));    %normalized cross-correlation       
                corr_all1(ct)=max(max(cross_corr));            
                ct=ct+1;
            else
                corr_all1(ct)= nan;
            end
            toc
        end
    end

    corr_all=squareform(corr_all1);
    
    % in group
    for k1=1:length(uni_group)
        %distance
        t=triu(dis_all(group==k1,group==k1),1);
        mask = tril(true(size(corr_all(group==k1,group==k1))),1);
        all_dis_circle_intra{k,k1}=t(~mask);
        t=triu(dis_all(group==k1,group~=k1),1);
        mask = tril(true(size(corr_all(group==k1,group~=k1))),1);
        all_dis_circle_inter{k,k1}=t(~mask);
        %correlation
        t=triu(corr_all(group==k1,group==k1),1);
        mask = tril(true(size(corr_all(group==k1,group==k1))),1);
        all_corr_circle_intra{k,k1}=t(~mask);
        t=triu(corr_all(group==k1,group~=k1),1);
        mask = tril(true(size(corr_all(group==k1,group~=k1))),1);
        all_corr_circle_inter{k,k1}=t(~mask);        
    end
end
toc;
all_dis_corr_circle_all_intra=[];
all_dis_corr_circle_all_inter=[];
ctt1=1;
ctt2=1;
for k=1:length(foldername)
    load(cluster_file_name)
    group=group{session};              
    for i=1:length(unique(group))
        all_dis_corr_circle_all_intra(ctt1:ctt1+length(all_dis_circle_intra{k,i})-1,1)=all_dis_circle_intra{k,i};
        all_dis_corr_circle_all_intra(ctt1:ctt1+length(all_dis_circle_intra{k,i})-1,2)=all_corr_circle_intra{k,i};
        ctt1=ctt1+length(all_dis_circle_intra{k,i});
        
        all_dis_corr_circle_all_inter(ctt2:ctt2+length(all_dis_circle_inter{k,i})-1,1)=all_dis_circle_inter{k,i};
        all_dis_corr_circle_all_inter(ctt2:ctt2+length(all_dis_circle_inter{k,i})-1,2)=all_corr_circle_inter{k,i};
        ctt2=ctt2+length(all_dis_circle_inter{k,i});
    end
end

figure;
plot(all_dis_corr_circle_all_intra(1:10:end,1),all_dis_corr_circle_all_intra(1:10:end,2),'.','MarkerSize',15,'color','b');
hold on;
plot(all_dis_corr_circle_all_inter(1:50:end,1),all_dis_corr_circle_all_inter(1:50:end,2),'.','MarkerSize',15,'color','r');
% ylim([2 10])
% [b1,~,~,~,stats1]=regress(all_dis_corr_linear_all(1:end,2),[all_dis_corr_linear_all(1:end,1),ones(length(all_dis_corr_linear_all(1:end,1)),1)]);
% plot(all_dis_corr_linear_all(1:10000:end,1),b1(2)+b1(1)*all_dis_corr_linear_all(1:10000:end,1),'r');
% f=fit(all_dis_corr_linear_all(1:end,1),all_dis_corr_linear_all(1:end,2),'poly2');
all_dis_corr_circle_all_intra(isnan(all_dis_corr_circle_all_intra(:,1)),:)=[];
all_dis_corr_circle_all_intra(isnan(all_dis_corr_circle_all_intra(:,2)),:)=[];
all_dis_corr_circle_all_inter(isnan(all_dis_corr_circle_all_inter(:,1)),:)=[];
all_dis_corr_circle_all_inter(isnan(all_dis_corr_circle_all_inter(:,2)),:)=[];