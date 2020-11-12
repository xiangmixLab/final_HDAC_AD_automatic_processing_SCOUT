% Tank et al. 2009 method for cluster number determine
function [group,CMf,Zf,Tcorr] = cluster_determine_by_corr_threshold(neuron0,K,N)
    
%% cluster number
%     K=floor(size(neuron0.S,1)/10);
%% kmeans clustering
    tic;
    CM = consensusKmeans_adapted(neuron0,3*std(neuron0.S(:)),K,N,[],[]); % return the simimarity matrix between paired neurons
    toc;

%% meta cluster generation
    CM1=CM;
    CM1(CM1<0.5)=0;
    Z = linkage(CM1,'complete');
    meta_cluster_group=cluster(Z,'maxclust',K);

    uni_gtemp=unique(meta_cluster_group);
    
    for i=1:length(uni_gtemp)
        meta_cluster_t=neuron0.C(meta_cluster_group==uni_gtemp(i),:);
        mean_meta_cluster_trace(i,:)=mean(meta_cluster_t,1);
        meta_cluster_size(i)=size(meta_cluster_t,1);
    end
    
%%  Tcorr determine   
    meanSizeCurrentTcorr=[];
    meanIntraCorrCurrentTcorr=[];
    ctt=1;
    
    Tcorr_all=0.05:0.01:0.95;
    
    for Tcorr=Tcorr_all
        meta_cluster_pairwise_corr=abs(1-squareform(pdist(mean_meta_cluster_trace,'correlation')));
        temp_cluster_map=meta_cluster_pairwise_corr>Tcorr;
        temp_cluster={};
        for i=1:size(temp_cluster_map,2)%methology: as we already have the map indicate the position of correlated pairs, we only need to make sure there is only one position for each pair to appear in the map
            t=temp_cluster_map(:,i);
            t(min(find(t==1))+1:end)=0;
            temp_cluster_map(:,i)=t;
        end
        for i=1:size(temp_cluster_map,1)
            t=temp_cluster_map(i,:);
            temp_cluster{i,1}=find(t==1);
        end         
        temp_cluster=temp_cluster(~cellfun(@isempty,temp_cluster));
        cSize=[];
        cIntraCorr=[];
        for i=1:size(temp_cluster,1)
            c = ismember(meta_cluster_group,temp_cluster{i});
            tempClustert=neuron0.C(c,:);
            cSize(i)=size(tempClustert,1);
            cIntraCorr(i)=mean(1-pdist(tempClustert,'correlation'))*cSize(i);
        end
        meanSizeCurrentTcorr(ctt)=mean(cSize);
        meanIntraCorrCurrentTcorr(ctt)=nansum(cIntraCorr)/sum(cSize);
        ctt=ctt+1;
        disp(['finish Tcorr',num2str(Tcorr)]);
    end

    meanSizeCurrentTcorr=meanSizeCurrentTcorr*1/max(meanSizeCurrentTcorr);
    meanIntraCorrCurrentTcorr=meanIntraCorrCurrentTcorr*1/max(meanIntraCorrCurrentTcorr);
    product_sign_corr=meanSizeCurrentTcorr.*meanIntraCorrCurrentTcorr;
    Tcorr_final=Tcorr_all(product_sign_corr==max(product_sign_corr));
    
 %% final cluster generation
    Tcorr=Tcorr_final;
    meta_cluster_pairwise_corr=abs(1-squareform(pdist(mean_meta_cluster_trace,'correlation')));
    temp_cluster_map=meta_cluster_pairwise_corr>Tcorr;
    temp_cluster={};
    for i=1:size(temp_cluster_map,2)%methology: as we already have the map indicate the position of correlated pairs, we only need to make sure there is only one position for each pair to appear in the map
        t=temp_cluster_map(:,i);
        t(min(find(t==1))+1:end)=0;
        temp_cluster_map(:,i)=t;
    end
    for i=1:size(temp_cluster_map,1)
        t=temp_cluster_map(i,:);
        temp_cluster{i,1}=find(t==1);
    end         
    temp_cluster=temp_cluster(~cellfun(@isempty,temp_cluster));
    
    group=zeros(size(meta_cluster_group));
    for i=1:size(temp_cluster,1)
        c = ismember(meta_cluster_group,temp_cluster{i});
        group(c)=i;
    end
 
 %% CMf and Zf
     CMf=CM*0;
     for k = 1:length(unique(group))
         comb = nchoosek(find(group == k),2);
         if length(comb) == 1
             continue;
         end
         linearInd = sub2ind(size(CMf), comb(:,1),comb(:,2));
         CMf(linearInd) = CMf(linearInd) + 1;% if these cells are in same group, similarity +1
     end
     CMf = max(CMf,CMf');
     Zf = linkage(CMf,'complete');

