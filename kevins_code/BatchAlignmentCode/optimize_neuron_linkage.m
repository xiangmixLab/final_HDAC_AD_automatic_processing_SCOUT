function [aligned_neurons,corr_scores,KL_scores]=optimize_neuron_linkage(aligned_neurons,corr_scores,KL_scores);
for i=1:size(aligned_neurons,1)
    scores=[];
    for j=1:(size(aligned_neurons,2)+1)/2
        
        if (aligned_neurons(i,j)==aligned_neurons(i,j+(size(aligned_neurons,2)-1)/2)&&sum(aligned_neurons(i,:)>0)>size(corr_scores,2)/2)||sum(aligned_neurons(i,:)>0)==size(corr_scores,2)/2&&aligned_neurons(i,j)~=0
            scores=vertcat(scores,[j,sum(corr_scores(i,j:j+(size(aligned_neurons,2)-1)/2-1))]);
        end
    end
    if ~isempty(scores)
        [M,I]=max(scores(:,2));
        remove_neurons=setdiff(1:size(aligned_neurons,2),scores(I,1):scores(I,1)+(size(aligned_neurons,2)-1)/2-1);
        remove_scores=setdiff(1:size(corr_scores,2),scores(I,1):scores(I,1)+(size(aligned_neurons,2)-1)/2-1);
        if sum(aligned_neurons(i,:)>0)==size(corr_scores,2)/2
           remove_neurons=setdiff(1:size(aligned_neurons,2),scores(I,1):scores(I,1)+(size(aligned_neurons,2)-1)/2-1);
           remove_scores=setdiff(1:size(corr_scores,2),scores(I,1):scores(I,1)+(size(aligned_neurons,2)-1)/2-2);
        end
        
        aligned_neurons1=aligned_neurons;
        corr_scores1=corr_scores;
        aligned_neurons(i,remove_neurons)=0;
        corr_scores(i,remove_scores)=0;
        KL_scores(i,remove_scores)=0;
        
    else
        aligned_neurons(i,:)=0;
        corr_scores(i,:)=0;
        KL_scores(i,:)=0;
    end
end
for i=size(aligned_neurons,1):-1:1
    if sum(aligned_neurons(i,:)>0)<size(corr_scores,2)/2
        aligned_neurons(i,:)=[];
        corr_scores(i,:)=[];
        KL_scores(i,:)=[];
    end
end


        
        