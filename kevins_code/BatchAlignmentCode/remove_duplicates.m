function keep_indices=remove_duplicates(aligned_neurons,corr_scores)
for i=1:size(corr_scores,1)
    maxim(i)=mean(corr_scores(i,corr_scores(i,:)>0),2);
end
keep_indices=[];
while max(maxim)>0
    [M,I]=max(maxim);
    keep_indices=[keep_indices,I];
    for i=1:size(aligned_neurons,1)
        for j=1:size(aligned_neurons,2)
            if i~=I&aligned_neurons(i,j)==aligned_neurons(I,j)&aligned_neurons(I,j)~=0
                corr_scores(i,:)=0;
                maxim(i)=0;
                aligned_neurons(i,:)=0;
            end
        end
    end
    aligned_neurons(I,:)=0;
    maxim(I)=0;
    aligned_neurons(I,:)=0;
end

    
    
    






