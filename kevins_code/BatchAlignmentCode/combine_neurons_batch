function neuron=combine_neurons_batch(neuron_A,neuron_B,indices)
neuron=Sources2D;
neuron.C=zeros(length(indices),size(neuron_A.C,2));
neuron.S=zeros(length(indices),size(neuron_A.S,2));
neuron.A_per_batch={};
neuron.centroids_per_batch={};

for i=1:length(indices)
    positive_A=find(neuron_A.C(indices(i),:)>0);
    nonpositive_A=setdiff(1:size(neuron_A.S,2),positive_A);
    neuron.C(i,positive_A)=neuron_A.C(indices(i),positive_A);
    neuron.C(i,nonpositive_A)=neuron_B.C(indices(i),nonpositive_A);
    neuron.S(i,positive_A)=neuron_A.S(indices(i),positive_A);
    neuron.S(i,nonpositive_A)=neuron_B.S(indices(i),nonpositive_A);
    
    for j=1:length(neuron_A.A_per_batch)
        
        if max(max(neuron_A.A_per_batch{j}(:,indices(i))))==0
            neuron.A_per_batch{j}(:,i)=neuron_B.A_per_batch{j}(:,indices(i));
        else
            neuron.A_per_batch{j}(:,i)=neuron_A.A_per_batch{j}(:,indices(i));
        end
    end
 
    for j=1:length(neuron_A.centroids_per_batch);
        
        if max(neuron_A.centroids_per_batch{j}(indices(i),:))==0
            neuron.centroids_per_batch{j}(i,:)=neuron_B.centroids_per_batch{j}(indices(i),:);
        else
            neuron.centroids_per_batch{j}(i,:)=neuron_A.centroids_per_batch{j}(indices(i),:);
        end
    end
end
neuron.scores(:,1)=min(neuron_A.scores(indices,2),neuron_B.scores(indices,2));
neuron.scores(:,2)=max(neuron_A.scores(indices,4),neuron_B.scores(indices,4));
