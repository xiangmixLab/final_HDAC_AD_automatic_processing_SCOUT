
function [all_dis_corr_circle_all_intra,all_dis_corr_circle_all_inter,midx,f1,f2,gof1,gof2]=pairwise_dis_tempCorr(foldername,cluster_file_name,session)
all_dis_circle_intra={};
all_corr_circle_intra={};
all_dis_circle_inter={};
all_corr_circle_inter={};

midx={};
midx_intra=[];
midx_inter=[];

for k=1:length(foldername)
    cd(foldername{k});
    load('further_processed_neuron_extraction_final_result.mat');
    load('neuronIndividuals_new.mat');
    load([cluster_file_name{k}])
    group=group{session};              
    uni_group=unique(group);

    dis_all=squareform(pdist(neuronIndividuals_new{session}.centroid))*2; % *2 is added 042320, in light of the resampling of the frame make all centroid distance only half of what it should be
    corr_all=squareform(1-pdist(neuronIndividuals_new{session}.C,'correlation'));
    
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
    for i=1:length(unique(group))
        all_dis_corr_circle_all_intra(ctt1:ctt1+length(all_dis_circle_intra{k,i})-1,1)=all_dis_circle_intra{k,i};
        all_dis_corr_circle_all_intra(ctt1:ctt1+length(all_dis_circle_intra{k,i})-1,2)=all_corr_circle_intra{k,i};
        midx_intra(ctt1:ctt1+length(all_dis_circle_intra{k,i})-1)=k;
        ctt1=ctt1+length(all_dis_circle_intra{k,i});
        
        all_dis_corr_circle_all_inter(ctt2:ctt2+length(all_dis_circle_inter{k,i})-1,1)=all_dis_circle_inter{k,i};
        all_dis_corr_circle_all_inter(ctt2:ctt2+length(all_dis_circle_inter{k,i})-1,2)=all_corr_circle_inter{k,i};
        midx_inter(ctt2:ctt2+length(all_dis_circle_inter{k,i})-1)=k;
        ctt2=ctt2+length(all_dis_circle_inter{k,i});
    end
end

midx={midx_intra,midx_inter};

[f1,gof1]=fit(all_dis_corr_circle_all_intra(1:end,1),all_dis_corr_circle_all_intra(1:end,2),'power2');
[f2,gof2]=fit(all_dis_corr_circle_all_inter(1:end,1),all_dis_corr_circle_all_inter(1:end,2),'power2');

figure;
% plot(all_dis_corr_circle_all_intra(1:10:end,1),all_dis_corr_circle_all_intra(1:10:end,2),'.','MarkerSize',15,'color','b');
hold on;
h1=plot(f1,all_dis_corr_circle_all_intra(1:40:end,1),all_dis_corr_circle_all_intra(1:40:end,2));
% plot(all_dis_corr_circle_all_inter(1:50:end,1),all_dis_corr_circle_all_inter(1:50:end,2),'.','MarkerSize',15,'color','r');
h2=plot(f2,all_dis_corr_circle_all_inter(1:40:end,1),all_dis_corr_circle_all_inter(1:40:end,2));

set([h1],'color','b','MarkerSize',10)
set([h2],'color','r','MarkerSize',10)
% [b1,~,~,~,stats1]=regress(all_dis_corr_linear_all(1:end,2),[all_dis_corr_linear_all(1:end,1),ones(length(all_dis_corr_linear_all(1:end,1)),1)]);
% plot(all_dis_corr_linear_all(1:10000:end,1),b1(2)+b1(1)*all_dis_corr_linear_all(1:10000:end,1),'r');

% all_dis_corr_circle_all_intra(isnan(all_dis_corr_circle_all_intra(:,1)),:)=[];
% all_dis_corr_circle_all_intra(isnan(all_dis_corr_circle_all_intra(:,2)),:)=[];
% all_dis_corr_circle_all_inter(isnan(all_dis_corr_circle_all_inter(:,1)),:)=[];
% all_dis_corr_circle_all_inter(isnan(all_dis_corr_circle_all_inter(:,2)),:)=[];
