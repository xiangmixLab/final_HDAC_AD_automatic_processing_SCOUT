
function [all_dis_corr_circle_all_intra,all_dis_corr_circle_all_inter,f1,f2,rsquare1,rsquare2]=pairwise_dis_tempCorr_placeCell(foldername,cluster_file_name,session,place_cells)
all_dis_circle_intra={};
all_corr_circle_intra={};
all_dis_circle_inter={};
all_corr_circle_inter={};
for k=1:length(foldername)
    cd(foldername{k});
    load('further_processed_neuron_extraction_final_result.mat');
    load('neuronIndividuals_new.mat');
    load([cluster_file_name{k}])
    group=group{session};    
    group=group(place_cells{k});
    uni_group=unique(group);

    nC=neuronIndividuals_new{session}.C;
    nC=nC(place_cells{k},:);
    cen=neuronIndividuals_new{session}.centroid;
    cen=cen(place_cells{k});
    
    dis_all=squareform(pdist(cen));
    corr_all=squareform(1-pdist(nC,'correlation'));
    
    % in group
    tic;
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
        toc;
    end
end

all_dis_corr_circle_all_intra=[];
all_dis_corr_circle_all_inter=[];
ctt1=1;
ctt2=1;
for k=1:length(foldername)
    cd(foldername{k});
    load([cluster_file_name{k}])
    group=group{session};           
    group=group(place_cells{k});
    for i=1:length(unique(group))
        all_dis_corr_circle_all_intra(ctt1:ctt1+length(all_dis_circle_intra{k,i})-1,1)=all_dis_circle_intra{k,i};
        all_dis_corr_circle_all_intra(ctt1:ctt1+length(all_dis_circle_intra{k,i})-1,2)=all_corr_circle_intra{k,i};
        ctt1=ctt1+length(all_dis_circle_intra{k,i});
        
        all_dis_corr_circle_all_inter(ctt2:ctt2+length(all_dis_circle_inter{k,i})-1,1)=all_dis_circle_inter{k,i};
        all_dis_corr_circle_all_inter(ctt2:ctt2+length(all_dis_circle_inter{k,i})-1,2)=all_corr_circle_inter{k,i};
        ctt2=ctt2+length(all_dis_circle_inter{k,i});
    end
end

[f1,gof1]=fit(all_dis_corr_circle_all_intra(1:end,1),all_dis_corr_circle_all_intra(1:end,2),'power2');
[f2,gof2]=fit(all_dis_corr_circle_all_inter(1:end,1),all_dis_corr_circle_all_inter(1:end,2),'power2');

rsquare1=gof1.rsquare;
rsquare2=gof2.rsquare;

figure;
% plot(all_dis_corr_circle_all_intra(1:10:end,1),all_dis_corr_circle_all_intra(1:10:end,2),'.','MarkerSize',15,'color','b');
hold on;
h1=plot(f1,all_dis_corr_circle_all_intra(1:120:end,1),all_dis_corr_circle_all_intra(1:120:end,2));
% plot(all_dis_corr_circle_all_inter(1:50:end,1),all_dis_corr_circle_all_inter(1:50:end,2),'.','MarkerSize',15,'color','r');
h2=plot(f2,all_dis_corr_circle_all_inter(1:120:end,1),all_dis_corr_circle_all_inter(1:120:end,2));

set([h1],'color',[0.4940,0.1840,0.5560],'MarkerSize',10)
set([h2],'color',[0.4660,0.6740,0.1880],'MarkerSize',10)
% [b1,~,~,~,stats1]=regress(all_dis_corr_linear_all(1:end,2),[all_dis_corr_linear_all(1:end,1),ones(length(all_dis_corr_linear_all(1:end,1)),1)]);
% plot(all_dis_corr_linear_all(1:10000:end,1),b1(2)+b1(1)*all_dis_corr_linear_all(1:10000:end,1),'r');

% all_dis_corr_circle_all_intra(isnan(all_dis_corr_circle_all_intra(:,1)),:)=[];
% all_dis_corr_circle_all_intra(isnan(all_dis_corr_circle_all_intra(:,2)),:)=[];
% all_dis_corr_circle_all_inter(isnan(all_dis_corr_circle_all_inter(:,1)),:)=[];
% all_dis_corr_circle_all_inter(isnan(all_dis_corr_circle_all_inter(:,2)),:)=[];
