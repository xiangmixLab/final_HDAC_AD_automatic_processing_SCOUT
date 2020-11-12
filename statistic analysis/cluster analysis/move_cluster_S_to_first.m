function group_temp_1=move_cluster_S_to_first(group_temp,nC)
group_temp_1=group_temp;
group_temp_unique_num=[];
group_temp_unique=unique(group_temp);
for i10=1:length(group_temp_unique)
    group_temp_unique_max(i10,1)=mean(max(nC(group_temp==group_temp_unique(i10),:),[],2));
end
possible_S_cluster=group_temp_unique(find(group_temp_unique_max==min(group_temp_unique_max)));
group_temp_1(group_temp==1)=-1;
% for i=1:length(possible_S_cluster)
group_temp_1(group_temp==min(possible_S_cluster))=1;
% end
group_temp_1(group_temp_1==-1)=min(possible_S_cluster);