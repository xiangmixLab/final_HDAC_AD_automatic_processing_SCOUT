function neuron=remove_duplicate_neurons(neuron)
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
                if neuron.scores(i,1)<neuron.scores(j,1)
                    j=i;
                end
                correlations(j,:)=[];
                correlations(:,j)=[];
                neuron.C(j,:)=[];
                neuron.S(j,:)=[];
                neuron.A(:,j)=[];
                neuron.centroid(j,:)=[];
                neuron.scores(j,:)=[];
                i=0;
                break
            end
        
        end
        j=j+1;
       
    end
    i=i+1;
end

                