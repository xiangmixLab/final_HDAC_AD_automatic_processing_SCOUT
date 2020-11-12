function neuron=CombineNeurons(neuron1,neuron2)
neuron.A=neuron1.A;
neuron.C=neuron1.C;
neuron.S=neuron1.S;
neuron.centroid=neuron1.centroid;
neuron.scores=neuron1.scores;
if size(neuron.scores,2)==2;
    neuron.scores=[neuron.scores,ones(size(neuron.scores,1),1)];
end
correlations=zeros(size(neuron.C,1),size(neuron2.C,1));
for i=1:size(neuron.C,1)
    for j=1:size(neuron2.C,1)
        corr=corrcoef(neuron.C(i,:),neuron2.C(j,:));
        correlations(i,j)=corr(1,2);
    end
end
repeat=find(max(correlations,[],2)>.7);
%neuron.scores(repeat,3)=neuron.scores(repeat,3)+1;
new=find(max(correlations,[],1)<.4);
neuron.A=horzcat(neuron.A,neuron2.A(:,new));
neuron.C=vertcat(neuron.C,neuron2.C(new,:));
neuron.S=vertcat(neuron.S,neuron2.S(new,:));
neuron.centroid=vertcat(neuron.centroid,neuron2.centroid(new,:));
%neuron.scores(end+1:end+length(new),1:2)=neuron2.scores(new,:);
%neuron.scores(end-length(new)+1:end,3)=neuron.scores(end-length(new)+1:end,3)+1;
