function [randIndex,shuffled_baseline]=Pairwise_ARI_with_baseline(gp)

ctt=1;
for i=1:length(gp)-1
    for j=i+1:length(gp)
        [randIndex(ctt,1),shuffled_baseline(ctt,1)]=RandIndex_with_baseline(gp{i},gp{j});
        ctt=ctt+1;
    end
end