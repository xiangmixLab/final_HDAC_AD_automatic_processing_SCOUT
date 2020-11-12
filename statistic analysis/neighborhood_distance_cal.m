function max_neighboor_dis=neighborhood_distance_cal(centroid)
distt=squareform(pdist(centroid));
distt(distt==0)=inf;
neighboor_dis=mean(min(distt,[],1));
neighboor_dis_std=std(min(distt,[],1));

max_neighboor_dis=neighboor_dis+3*neighboor_dis_std;