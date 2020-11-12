%parker et al. 2018
%input: suppose we have m neurons
%centroid: neuron centroids, 2-d m x 2 matrix, [x_coordination,y_coordination]
%group: cluster group index, 1-d m x 1 matrix, contains the group number for each
%neurons
function SCI=spatial_coordination_idx(centroid,group)

tic;

uni_group=unique(group);
SCI=zeros(length(uni_group),1);

for clust=1:length(uni_group) % for each cluster
    
    if sum(group==clust)>2
        intra_pdist={};
        intra_pdist_rand={};
        shuffle=1000;
        %% calculate pairwise distance for clustered neurons
        dataC1 = centroid; 
        corr_all=squareform(pdist(dataC1));
        t=triu(corr_all(group==clust,group==clust),1); 
        mask = tril(true(size(corr_all(group==clust,group==clust))),1); % a method to get the upper triangle of matrix (see online)
        intra_pdist{clust}=t(~mask);

        %% calculate pairwise distance for shuffled all neurons
        for j=1:shuffle
            group_rand = group(randperm(length(group))); % randomly assign neurons as cluster "clust" from the whole neuron set
    %         for clust=1:length(unique(group))
            t=triu(corr_all(group_rand==clust,group_rand==clust),1); 
            mask = tril(true(size(corr_all(group_rand==clust,group_rand==clust))),1);
            intra_pdist_rand{clust,j}=t(~mask);
    %         end
        end

        %% list all pdist clustered
        intra_pdist_all=[];
        ctt=1;
    %     for clust=1:length(unique(group))
        intra_pdist_all(ctt:ctt+length(intra_pdist{clust})-1)=intra_pdist{clust};
    %         ctt=ctt+length(intra_pdist{clust});
    %     end

        %% list all pdist shuffled
        intra_pdist_rand_all=[];
        ctt=1;
    %     for clust=1:length(unique(group))
        for j=1:shuffle
            intra_pdist_rand_all(ctt:ctt+length(intra_pdist_rand{clust,j})-1)=intra_pdist_rand{clust,j}; % we do an average to make the total sample number comparable to the inter-cluster-corr
            ctt=ctt+length(intra_pdist_rand{clust,j});       
        end        
    %     end
        % for i=1:length(unique(group))
        %     for j=1:shuffle
        %         intra_pdist_rand_all(1:length(intra_pdist_rand{i,j})-1,j)=intra_pdist_rand{i,j}; % we do an average to make the total sample number comparable to the inter-cluster-corr
        %     end        
        % end

        %% remove nans
        intra_pdist_all(isnan(intra_pdist_all))=[];
        intra_pdist_rand_all(isnan(intra_pdist_rand_all))=[];
        % for i=1:size(intra_pdist_rand_all,2)
        %     intra_pdist_rand_all(isnan(intra_pdist_rand_all(:,i)),:)=[];
        % end

        %% cdf
        [cdf_intra_pdist_all,x1]=ecdf(intra_pdist_all); %see "help ecdf"
        [cdf_intra_pdist_rand_all,x2]=ecdf(intra_pdist_rand_all);

        % cdf_intra_pdist_all=resample(cdf_intra_pdist_all,1000,length(cdf_intra_pdist_all));
        % cdf_intra_pdist_rand_all=resample(cdf_intra_pdist_rand_all,1000,length(cdf_intra_pdist_rand_all));
        x11=x1(1:length(x1)/100:end); % resample the distribution to make it shorter, can pass the kstest2 test (x1 and x11 are still considered from the same distribution)
        x22=x2(1:length(x2)/100:end);
        [h1c,p1c,~] = kstest2(x1,x11);
        [h2c,p2c,~] = kstest2(x2,x22);

        %% ks test
        [~,p1,~] = kstest2(x11,x22,'Tail','larger');
        [~,p2,~] = kstest2(x11,x22,'Tail','smaller');

        %% SCI
        sign=(mean(intra_pdist_rand_all)-mean(intra_pdist_all))/abs((mean(intra_pdist_rand_all)-mean(intra_pdist_all)));
        SCI(clust)=(-1)*sign*log10(min(p1,p2));
    else
        SCI(clust)=nan;
    end
end
SCI(isnan(SCI))=[];