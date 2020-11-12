function comparison_scores=compare_activity_across_nonzero_indices(neuron_A,neuron_B)
comparison_scores=[];
for i=1:size(neuron_A.C,1);
    indices_A=neuron_A.C(i,:)>0;
    indices_B=neuron_B.C(i,:)>0;
    indices=indices_A&indices_B;
    if sum(indices)>0;
        corr=corrcoef(neuron_A.C(i,indices),neuron_B.C(i,indices));
        comparison_scores=[comparison_scores,corr(1,2)];
    else
        comparison_scores=[comparison_scores,1];
    end
end