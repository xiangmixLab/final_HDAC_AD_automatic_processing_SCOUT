function neuron=combined_neurons_adj(neuron_A,neuron_B,indices)
neuron=Sources2D;
neuron.C=zeros(size(neuron_A.C));
neuron.S=zeros(size(neuron_A.S));
neuron.C_raw=zeros(size(neuron.C));
neuron.A_per_batch={};
neuron.centroids_per_batch={};







for i=1:size(neuron_A.C,1)
    positive_A=find(neuron_A.C(i,:)>0);
    nonpositive_A=setdiff(1:size(neuron_A.S,2),positive_A);
    neuron.C(i,positive_A)=neuron_A.C(i,positive_A);
    neuron.C(i,nonpositive_A)=neuron_B.C(i,nonpositive_A);
    neuron.S(i,positive_A)=neuron_A.S(i,positive_A);
    neuron.S(i,nonpositive_A)=neuron_B.S(i,nonpositive_A);
    neuron.C_raw(i,positive_A)=neuron_A.C_raw(i,positive_A);
    neuron.C_raw(i,nonpositive_A)=neuron_B.C_raw(i,nonpositive_A);
    for j=1:length(neuron_A.A_per_batch)
        
        if max(max(neuron_A.A_per_batch{j}(:,i)))==0
            neuron.A_per_batch{j}(:,i)=neuron_B.A_per_batch{j}(:,i);
        else
            neuron.A_per_batch{j}(:,i)=neuron_A.A_per_batch{j}(:,i);
        end
    end
 
    for j=1:length(neuron_A.centroids_per_batch);
        
        if max(neuron_A.centroids_per_batch{j}(i,:))==0
            neuron.centroids_per_batch{j}(i,:)=neuron_B.centroids_per_batch{j}(i,:);
        else
            neuron.centroids_per_batch{j}(i,:)=neuron_A.centroids_per_batch{j}(i,:);
        end
    end
end


for i=1:size(neuron_A.corr_scores,1)
    for j=1:size(neuron_A.corr_scores,2)
        if neuron_A.corr_scores(i,j)>0&&neuron_B.corr_scores(i,j)>0
            neuron.corr_scores(i,j)=min(neuron_A.corr_scores(i,j),neuron_B.corr_scores(i,j));
        else
            neuron.corr_scores(i,j)=max(neuron_A.corr_scores(i,j),neuron_B.corr_scores(i,j));
        end
    end
   neuron.KL_scores(i,:)=max(neuron_A.KL_scores(i,:),neuron_B.KL_scores(i,:));
end 