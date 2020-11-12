function [aligned_neurons,aligned_neurons_corr,aligned_neurons_KL]=align_neurons_across_batches_via_links(neurons,links,overlap,height,width)
aligned_neurons={};
for i=1:length(neurons)/2
    if mod(i,5)==0
        disp(i)
    end
    [aligned_neurons{i},scores{i}]=align_between_subbatch_via_links_single(neurons{i},neurons{i+1},links{i},overlap,height,width);
    
    aligned_neurons_batch{i}=zeros(size(neurons{i}.C,1),length(neurons));
    
end
aligned_neurons(end+1:length(neurons))=aligned_neurons(1:length(neurons)/2);
aligned_neurons(end+1)=aligned_neurons(1);

aligned_neurons_batch(end+1:length(neurons))=aligned_neurons_batch(1:length(neurons)/2);
aligned_neurons_batch(end+1)=aligned_neurons_batch(1);


scores(end+1:length(neurons))=scores(1:length(neurons)/2);
scores(end+1)=scores(1);
for i=1:length(scores)-1
    
    aligned_neurons_corr{i}=zeros(size(neurons{i}.C,1),length(neurons));
    aligned_neurons_KL{i}=zeros(size(neurons{i}.C,1),length(neurons));
end    
for i=1:length(neurons)+1
    
    aligned_neurons_batch{i}(:,i)=1:size(aligned_neurons{i},1);
    aligned_neurons_corr{i}(:,i)=scores{i}(:,1);
    aligned_neurons_KL{i}(:,i)=scores{i}(:,2);
    for j=i+1:length(neurons)+1
        for k=1:size(aligned_neurons_batch{i},1)
            if aligned_neurons_batch{i}(k,j-1)>0
                aligned_neurons_batch{i}(k,j)=aligned_neurons{j-1}(aligned_neurons_batch{i}(k,j-1),2);
                if aligned_neurons_batch{i}(k,j)>0
                    %aligned_neurons_scores{i}(k,1)=min(aligned_neurons_scores{i}(k,1),aligned_neurons_scores{j-1}(aligned_neurons_batch{i}(k,j-1),1));
                    %aligned_neurons_scores{i}(k,2)=max(aligned_neurons_scores{i}(k,2),aligned_neurons_scores{j-1}(aligned_neurons_batch{i}(k,j-1),2));
                    %aligned_neurons_scores{i}(k,3)=aligned_neurons_scores{i}(k,3)+aligned_neurons_scores{j-1}(aligned_neurons_batch{i}(k,j-1),3);
                    %aligned_neurons_scores{i}(k,4)=aligned_neurons_scores{i}(k,4)+aligned_neurons_scores{j-1}(aligned_neurons_batch{i}(k,j-1),4);
                    aligned_neurons_corr{i}(k,j-1)=scores{j-1}(aligned_neurons_batch{i}(k,j-1),1);
                    aligned_neurons_KL{i}(k,j-1)=scores{j-1}(aligned_neurons_batch{i}(k,j-1),2);
                end
            else
                aligned_neurons_batch{i}(k,j)=0;
                %aligned_neurons_scores{i}(k,2)=0;
                %aligned_neurons_scores{i}(k,1)=0;
            end
        end
    end
    
end
%aligned_neurons1=aligned_neurons;
aligned_neurons=vertcat(aligned_neurons_batch{:});
%scores=vertcat(aligned_neurons_scores{:});
%num_pos=sum(aligned_neurons>0,2);
%scores(:,3:4)=scores(:,3:4)./num_pos;
aligned_neurons_corr=vertcat(aligned_neurons_corr{1:end-1});
aligned_neurons_KL=vertcat(aligned_neurons_KL{1:end-1});

