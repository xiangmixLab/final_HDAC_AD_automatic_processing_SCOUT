function fr_ct_mat=firing_count_cal(neuronIndividuals_new)

for i=1:length(neuronIndividuals_new)
    nS=C_to_peakS(neuronIndividuals_new{i}.C);
    thresh=0.1*max(nS,[],2);
    for j=1:size(nS,1)
        t=nS(j,:);
        t(t<thresh(j))=0;
        nS(i,:)=t;
    end
    
    nS_count=sum(nS>0,2);
    fr_ct{1,i}=nS_count;
end

fr_ct_mat=cell2mat(fr_ct);