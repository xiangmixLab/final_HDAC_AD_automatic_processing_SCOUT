function nC_thresh=thresholding_neuron(nC,thresh)

for i=1:size(nC,1)
    t=nC(i,:);
    t(t<thresh(i))=0;
    nC_thresh(i,:)=t;
end