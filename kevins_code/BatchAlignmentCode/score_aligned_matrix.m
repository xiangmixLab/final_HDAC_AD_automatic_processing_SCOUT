function [corr_scores,dist,corr_scores_prc,dist_prc]=score_aligned_matrix(neurons,aligned_matrix,offset,overlap,data_shape,corr_type,dist_meas)

corr_scores=zeros(size(aligned_matrix,1),size(aligned_matrix,2)-1);
dist=zeros(size(corr_scores));
corr_scores_prc=zeros(size(corr_scores));
dist_prc=zeros(size(corr_scores));

for j=1:size(aligned_matrix,2)-1
    distance=compute_pairwise_distance(neurons{j},neurons{j+1},data_shape(1),data_shape(2),dist_meas);
    correlations=correlations_positive(neurons{j}.C(:,end-overlap+1:end),neurons{j+1}.C(:,1:overlap),corr_type);
    for i=1:size(aligned_matrix,1)
        if aligned_matrix(i,j)>0&&aligned_matrix(i,j+1)>0
        corr_scores(i,j)=correlations(aligned_matrix(i,j),aligned_matrix(i,j+1));
        dist(i,j)=distance(aligned_matrix(i,j),aligned_matrix(i,j+1));
        stdev=std(correlations(aligned_matrix(i,j),:),'omitnan');
        if stdev>0 
            corr_scores_prc(i,j)=normcdf((correlations(aligned_matrix(i,j),aligned_matrix(i,j+1))-mean(correlations(aligned_matrix(i,j),:),'omitnan'))/stdev);
        else
            corr_scores_prc(i,j)=0;
        
        end
        
        stdev=std(1-distance(aligned_matrix(i,j),:),'omitnan');
        if stdev>0
            dist_prc(i,j)=normcdf((1-distance(aligned_matrix(i,j),aligned_matrix(i,j+1))-mean(1-distance(aligned_matrix(i,j),:),'omitnan'))/stdev);
        else
            dist_prc(i,j)=0;
        end
        end
    end
end
if offset>1
    corr_scores=[zeros(size(corr_scores,1),offset-1),corr_scores];
    dist=[zeros(size(dist,1),offset-1),dist];
    corr_scores_prc=[zeros(size(corr_scores_prc,1),offset-1),corr_scores_prc];
    dist_prc=[zeros(size(dist_prc,1),offset-1),dist_prc];
end






    