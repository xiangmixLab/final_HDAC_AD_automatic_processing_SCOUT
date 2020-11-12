function aligned_neurons=align_neurons_subbatch(neurons,corr_thresh,dist_thresh,overlap,data_shape,corr_type,dist_measure)
aligned_neurons={};
for i=1:length(neurons)-1
    aligned_neurons{i}=zeros(size(neurons{i}.centroid,1),length(neurons));
end
for l=1:length(neurons)-1
    aligned_neurons{l}(:,l)=1:size(aligned_neurons{l},1);
    for j=l+1:length(neurons)
            correlations=correlations_positive(neurons{j-1}.C(:,end-overlap+1:end),neurons{j}.C(:,1:overlap),corr_type);
            distance=compute_pairwise_distance(neurons{j-1},neurons{j},data_shape(1),data_shape(2),dist_measure);
            correlations(aligned_neurons{l}(:,j-1)==0,:)=0;
            distance(aligned_neurons{l}(:,j-1)==0,:)=0;
            while max(correlations,[],'all')>corr_thresh
                [~,I]=max(reshape(correlations,1,[]));
                [a,b]=ind2sub(size(correlations),I);
                if distance(a,b)<dist_thresh
                    index=find(aligned_neurons{l}(:,j-1)==a);
                    aligned_neurons{l}(index,j)=b;
                    correlations(a,:)=0;
                    correlations(b,:)=0;
                else
                    correlations(I)=0;
                end
            end
            
            
    end
    
end

                
                
                    
                
                
            
            