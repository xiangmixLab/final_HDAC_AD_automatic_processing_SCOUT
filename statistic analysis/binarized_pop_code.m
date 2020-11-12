function [nC_b,uni_code,idx_remain]=binarized_pop_code(neuron,idx_remain_preset)

nC=neuron.C;
thresh=0.1*max(nC,[],2);
nC=thresholding_neuron(nC,thresh);
nS=C_to_peakS(nC);

if isempty(idx_remain_preset)% detele neurons have very small firing times (5 times)
    nS_fr_times=sum(nS>0,2);
    nC(nS_fr_times<5,:)=[];
    idx_remaint=find(nS_fr_times>=5);

    % convert C to larger/smaller than 0 binary coding
    nC_b=nC>0;
    % delete neurons with very long activition
    nC_b_fr_time=sum(nC_b,2);
    nC_b(nC_b_fr_time>=size(nC_b,2)*0.85,:)=[];
    idx_remain=idx_remaint(nC_b_fr_time<size(nC_b,2)*0.85);
else
    idx_remain=idx_remain_preset
    nC_b=nC>0;
    nC_b=nC_b(idx_remain_preset,:);
end
% find unique binary code

uni_code = unique(nC_b', 'rows');