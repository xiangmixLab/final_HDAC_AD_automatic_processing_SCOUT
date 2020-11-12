function [aligned_neurons,removed_indices]=remove_duplicates_adj(aligned_neurons,scores)

total_removed=0;
newscores=scores;
removed_indices=[];
for i=1:size(aligned_neurons,1)
    if sum(aligned_neurons(i,:)>0)>1;
        for j=1:size(aligned_neurons,1)
            if sum((aligned_neurons(i,:)-aligned_neurons(j,:))==0)>0&& i~=j
                dup=false;
                for k=1:size(aligned_neurons,2)
                    if aligned_neurons(i,k)==aligned_neurons(j,k)&&aligned_neurons(i,k)~=0&&aligned_neurons(j,k)~=0
                        dup=true;
                        break
                    end
                end
                        
                if dup==true;
                    if sum(scores(i,1))/sum(scores(i,:)>0)>sum(scores(j,:))/sum(scores(j,:)>0)||(sum(aligned_neurons(i,:)>0)>sum(aligned_neurons(j,:)>0)&&sum(aligned_neurons(j,:)>0)<size(aligned_neurons,2)/2);
                        aligned_neurons(j,:)=zeros(1,size(aligned_neurons,2));
                        removed_indices=[removed_indices,j];
                    else
                        aligned_neurons(i,:)=zeros(1,size(aligned_neurons,2));
                        removed_indices=[removed_indices,i];
                    end
                end
                total_removed=total_removed+1;
            end
        end
    end
end


num_neurons=sum(aligned_neurons>0,2)==1;
removed_indices=[removed_indices,find(num_neurons)'];

aligned_neurons(num_neurons,:)=0;
aligned_neurons=aligned_neurons(max(aligned_neurons,[],2)>0,:);






