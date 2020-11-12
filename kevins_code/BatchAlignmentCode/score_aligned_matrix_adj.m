function [corr_scores,dist,corr_scores_prc,dist_prc]=score_aligned_matrix_adj(neurons,aligned_matrix,offset,overlap,data_shape,dist_meas)
height=data_shape(1);
width=data_shape(2);

corr_scores=zeros(size(aligned_matrix,1),size(aligned_matrix,2)-1);
dist=zeros(size(corr_scores));
corr_scores_prc=zeros(size(corr_scores));
dist_prc=zeros(size(corr_scores));

for j=1:size(aligned_matrix,2)-1
    C_corr1 =correlations_positive(neurons{j}.S(:,end-overlap+1:end),neurons{j+1}.S(:,1:overlap),'S');
    C_corr2=correlations_positive(neurons{j}.C(:,end-overlap+1:end),neurons{j+1}.C(:,1:overlap));
    C_corr3=correlations_positive(neurons{j}.C(:,end-overlap+1:end),neurons{j+1}.C(:,1:overlap),'pearson');
    C_corr=max([reshape(C_corr1,[],1),reshape(C_corr2,[],1),reshape(C_corr3,[],1)],[],2);
    C_corr=reshape(C_corr,size(C_corr1));
    correlations=C_corr;
    for i=1:size(aligned_matrix,1)
        if aligned_matrix(i,j)>0&&aligned_matrix(i,j+1)>0
        corr_scores(i,j)=correlations(aligned_matrix(i,j),aligned_matrix(i,j+1));
        
        stdev=std(correlations(aligned_matrix(i,j),:),'omitnan');
        if stdev>0 
            corr_scores_prc(i,j)=normcdf((correlations(aligned_matrix(i,j),aligned_matrix(i,j+1))-mean(correlations(aligned_matrix(i,j),:),'omitnan'))/stdev);
        else
            corr_scores_prc(i,j)=0;
        
        end
        if isnan(corr_scores(i,j))
            corr_scores(i,j)=0;
            corr_scores_prc(i,j)=0;
        end
        end
    end
    
end

    
 for i=1:size(aligned_matrix,1)
     switch dist_meas
         case 'centroid_dist'
         centroid=[];
         for j=1:2:length(neurons)
             centroid=[centroid;neurons{j}.centroid(aligned_matrix(i,j),:)];
         end
         center=mean(centroid,1);
         for j=1:length(neurons)
            dist(i,j)=norm(neurons{j}.centroid(aligned_matrix(i,j),:)-center);
         end
         case 'overlap'
             A=[];
             for j=1:length(neurons)
                 A=[A,neurons{j}.A(:,aligned_matrix(i,j),:)];
             end
             overlap=logical(ones(size(A,1),1));
             for j=1:length(neurons)
                 overlap=overlap&A(:,j)>0;
             end
             for j=1:length(neurons)
                 temp = bsxfun(@times, A>0, 1./sqrt(sum(A>0)));
                temp1=bsxfun(@times, overlap>0, 1./sqrt(sum(overlap>0)));
                distance=1-temp'*temp1;
                if ~isnan(distance(j))
                    dist(i,j)=distance(j);
                else
                    dist(i,j)=1;
                end
                try
                    dist_prc(i,j)=norminv((dist(i,j)-mean(distance))/std(distance,'omitnan'));
                catch
                    dist_prc(i,j)=1;
                    
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






    