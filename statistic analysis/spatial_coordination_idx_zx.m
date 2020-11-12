%parker et al. 2018
%input: suppose we have m neurons
%centroid: neuron centroids, 2-d m x 2 matrix, [x_coordination,y_coordination]
%group: cluster group index, 1-d m x 1 matrix, contains the group number for each
%neurons
function SCI=spatial_coordination_idx_zx(centroid,clus_ind)

    tic;

    uni_group=unique(clus_ind);
    SCI=zeros(length(uni_group),1);

    for clust=1:length(uni_group) % for each cluster

        maxidx=clust;
        %[~,minidx]=min(cnt);

        % [neuron,~]=size(dat);
        neuron=length(clus_ind);
        %ind_rest=setdiff([1 2 3],maxidx);
        %center1=mean(centroid1(centroid1(:,1)==ind_rest(1),:),1);
        %center2=mean(centroid1(centroid1(:,1)==ind_rest(2),:),1);

        clus_ind1=zeros(neuron,1);
        for i=1:neuron
            %center_i=mean(centroid1(centroid1(:,1)==clus_ind(i,1),:),1);
            if clus_ind(i,1)==maxidx
            clus_ind1(i,1)=0;
            else 
            clus_ind1(i,1)=1;
            end
        end



        %get the positions in the cluster
        centroid_new=centroid(find(clus_ind1),:);
        clus_num=size(centroid_new,1);
        if size(centroid_new,1)>3
            cent_mat=zeros(clus_num,clus_num);
            %calculate r^2
            for i=1:clus_num
                for j=i:clus_num
                cent_mat(i,j)=norm(centroid_new(i,:)-centroid_new(j,:));
                end
            end
            for i=1:clus_num
                for j=i:clus_num
                cent_mat(j,i)=NaN;
                end
            end
            cent_vec = reshape(cent_mat,[],1);

            %shuffle 1000 times
            cent_shuf=zeros(size(cent_vec,1),1000);
            for B=1:1000
            %get the positions in the cluster
            centroid_new=centroid(randi([1 neuron],1,clus_num),:);
            cent_mat=zeros(clus_num,clus_num);
            %calculate r^2
            for i=1:clus_num
                for j=i:clus_num
                cent_mat(i,j)=norm(centroid_new(i,:)-centroid_new(j,:));
                end
            end
            for i=1:clus_num
                for j=i:clus_num
                cent_mat(j,i)=NaN;
                end
            end
            cent_shuf(:,B) = reshape(cent_mat,[],1);
            end
            cent_shuf_vec = reshape(cent_shuf,[],1);

            rng(1);
            [~,p1] = kstest2(cent_shuf_vec,cent_vec,'Alpha',0.05,'tail','larger');
            [~,p2] = kstest2(cent_shuf_vec,cent_vec,'Alpha',0.05,'tail','smaller');
            p=min(p1,p2);
            scindex=(-mean(cent_vec)+mean(cent_shuf_vec))*(-1)*log10(p);
        end
        SCI(clust)=scindex;
    end
end
