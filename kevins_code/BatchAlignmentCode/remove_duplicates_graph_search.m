function [aligned_neurons,scores]=remove_duplicates_graph_search(aligned_neurons,scores)
total_removed=0;
newscores=scores;
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
                    if scores(i)<scores(j)
                        aligned_neurons(j,:)=zeros(1,size(aligned_neurons,2));
                        newscores(j)=0;
                    else
                        aligned_neurons(i,:)=zeros(1,size(aligned_neurons,2));
                        newscores(i)=0;
                    end
                end
                total_removed=total_removed+1;
            end
        end
    end
end



aligned_neurons=aligned_neurons(max(aligned_neurons,[],2)>0,:);
newscores=newscores(newscores>0);
scores=newscores;









 