function [ARI,shuffled_baseline_95,shuffled_baseline]=ARI_with_baseline(gp1,gp2)

[ARI]=RandIndex(gp1,gp2);

shuffled_baseline=[];
for i=1:1000
    rand_idx1=randperm(length(gp1));
    rand_idx2=randperm(length(gp2));
    [shuffled_baseline(i)]=RandIndex(gp1(rand_idx1),gp2(rand_idx2));
end

shuffled_baseline_95=quantile(shuffled_baseline,0.95);