function [randIndex,shuffled_baseline]=Groupwise_RandIndex_with_baseline(gp_group1,gp_group2)

ctt=1;
for i=1:length(gp_group1)   
    for j=1:length(gp_group2)
        [randIndex{ctt},shuffled_baseline{ctt}]=RandIndex_with_baseline(gp_group1{i},gp_group2{j});
        ctt=ctt+1;
    end
end