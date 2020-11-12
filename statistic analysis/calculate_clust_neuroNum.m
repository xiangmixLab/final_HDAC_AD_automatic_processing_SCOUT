function [group_num]=calculate_clust_neuroNum(gp_rec)
group_num=[];
for i=1:length(unique(gp_rec))
    group_num(i)=sum(gp_rec==i);
end