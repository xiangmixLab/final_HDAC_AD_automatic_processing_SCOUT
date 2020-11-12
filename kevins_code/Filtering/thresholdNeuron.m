function neuron=thresholdNeuron(neuron,prctile_thresh);
A=neuron.A;
parfor i=1:size(neuron.A,2)
    A1=A(:,i);
    thresh=max(A1)*prctile_thresh;
    A1(A1<thresh)=0;
    A(:,i)=A1;
end
neuron.A=A;