function spr=sparsity_place_cell(firingrate,countTime)

%skaggs et al.1996 Theta Phase Precession in Hippocampal Neuronal Populations and the Compression of Temporal Sequences

p=countTime/(sum(sum(countTime)));

spr=sum(sum((p.*firingrate))).^2/(sum(sum(p.*firingrate.^2)));