function [group_shared,group12,group21]=determineSharedCells_new(group1,group2)
uni_g1=unique(group1);
uni_g2=unique(group2);

group12=group1*0;
group21=group1*0;

group12t=group1*0;
group21t=group1*0;

g1_clust_in_g2=[];
used_idx=[];
% for i=1:length(uni_g1)
%     idxx=find(group1==uni_g1(i));
%     g2_idxx=group2(idxx);
%     g1_clust_in_g2(i)=[mode(g2_idxx)];
% end

for i=1:length(uni_g1)
    idxx=find(group1==uni_g1(i));
    g2_idxx=group2(idxx);
    
    uv=histc(g2_idxx, unique(g2_idxx));
    uni_g2_idxx=unique(g2_idxx);
    utt=sortrows([uv,uni_g2_idxx],1);
    uv_sort_idx=utt(:,2);
    potential_clust_idx=uv_sort_idx(end);
    ctt=1;
    while ismember(potential_clust_idx,used_idx)
        potential_clust_idx=uv_sort_idx(end-ctt);
        ctt=ctt+1; 
        if ctt>=length(uv_sort_idx)
            potential_clust_idx=-1;
            break;
        end
    end
    g1_clust_in_g2(i)=potential_clust_idx;
    used_idx=[used_idx,potential_clust_idx];
end

fullList=1:length(unique(group2));
missingV = setdiff(fullList,g1_clust_in_g2);
g1_clust_in_g2(g1_clust_in_g2==-1)=missingV;

g2_clust_in_g1=[];
used_idx=[];
for i=1:length(uni_g2)
    idxx=find(group2==uni_g2(i));
    g1_idxx=group1(idxx);
    
    uv=histc(g1_idxx, unique(g1_idxx));
    uni_g1_idxx=unique(g1_idxx);
    utt=sortrows([uv,uni_g1_idxx],1);
    uv_sort_idx=utt(:,2);
    
    potential_clust_idx=uv_sort_idx(end);
    ctt=1;
    while ismember(potential_clust_idx,used_idx)
        potential_clust_idx=uv_sort_idx(end-ctt);
        ctt=ctt+1;
        if ctt>=length(uv_sort_idx)
            potential_clust_idx=-1;
            break;
        end
    end
    g2_clust_in_g1(i)=potential_clust_idx;
    used_idx=[used_idx,potential_clust_idx];
end

fullList=1:length(unique(group1));
missingV = setdiff(fullList,g2_clust_in_g1);
g2_clust_in_g1(g2_clust_in_g1==-1)=missingV;


for i=1:length(uni_g1)
    group12t(logical((group2==g1_clust_in_g2(i)).*(group1==uni_g1(i))))=i;  
    group12(logical((group2==g1_clust_in_g2(i))))=i;
end
for i=1:length(uni_g2)
    group21t(logical((group1==g2_clust_in_g1(i)).*(group2==uni_g2(i))))=i; 
    group21(logical((group1==g2_clust_in_g1(i))))=i; 
end

group_shared=(group12t.*group21t)>0;