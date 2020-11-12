function [group_shared,group12,group21,group12_correspond_cluster,group21_correspond_cluster]=determineSharedCells(group1,group2)
uni_g1=unique(group1);
uni_g2=unique(group2);

group12=group1*0;
group21=group1*0;

group12_correspond_cluster=group1*0;
group21_correspond_cluster=group1*0;

for i=1:length(uni_g1)
    idxx=find(group1==uni_g1(i));
    g2_idxx=group2(idxx);
    g1_clust_in_g2(i,:)=[uni_g1(i) mode(g2_idxx) sum(g2_idxx==mode(g2_idxx))];
end


for i=1:size(g1_clust_in_g2,1)
    group12(logical((group2==g1_clust_in_g2(i,2)).*(group1==uni_g1(i))))=g1_clust_in_g2(i,2);  
    group12_correspond_cluster(logical((group2==g1_clust_in_g2(i,2))))=g1_clust_in_g2(i,2);
end

for i=1:length(uni_g2)
    idxx=find(group2==uni_g2(i));
    g1_idxx=group1(idxx);
    g2_clust_in_g1=mode(g1_idxx);
    group21(logical((group1==g2_clust_in_g1).*(group2==uni_g2(i))))=i;  
    group21_correspond_cluster(logical((group1==g2_clust_in_g1)))=i;
end

group_shared=(group12.*group21)>0;
% group12(group12==0)=group2(group12==0);
% group21(group21==0)=group1(group21==0);

%assign remaining 0s 
% uni_g1=unique(group1);
% uni_g2=unique(group2);
% g1_unassign=uni_g1(~ismember(uni_g1,uni_g2));
% g2_unassign=uni_g2(~ismember(uni_g2,uni_g1));
% 
% 
% for i=1:length(g1_unassign)
%     group21_correspond_cluster(logical((group21_correspond_cluster==0).*(group1==g1_unassign(i))))=g1_unassign(i);
% end
% for i=1:length(g2_unassign)
%     group12_correspond_cluster(logical((group12_correspond_cluster==0).*(group2==g2_unassign(i))))=g2_unassign(i);
% end