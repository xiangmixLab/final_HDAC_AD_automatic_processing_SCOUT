function neuron=remove_duplicate_neurons_adj(neuron)
i=1;
j=1;
correlations=zeros(size(neuron.C,1),size(neuron.C,1));
for i=1:size(neuron.C,1)
    for j=1:size(neuron.C,1)
        corr=corrcoef(neuron.C(i,:),neuron.C(j,:));
        correlations(i,j)=corr(1,2);
    end
end
i=1;
while i<=size(neuron.C,1)
    j=i+1;
    while j<=size(neuron.C,1)
        if correlations(i,j)>.75
            dist=norm(neuron.centroid(i,:)-neuron.centroid(j,:));
            if dist<10
                if sum(neuron.corr_scores(i,:))<sum(neuron.corr_scores(j,:))
                    j=i;
                end
                correlations(j,:)=[];
                correlations(:,j)=[];
                neuron.C(j,:)=[];
                neuron.C_raw(j,:)=[];
                neuron.S(j,:)=[];
                neuron.A(:,j)=[];
                neuron.centroid(j,:)=[];
                neuron.corr_scores(j,:)=[];
                neuron.KL_scores(j,:)=[];
                i=0;
                break
            end
        
        end
        j=j+1;
       
    end
    i=i+1;
end

                