function [neighboor_dis_high_estimate,neighboor_dis,neighboor_dis_std]=neighborhood_distance_estimate(pos)

distt=squareform(pdist(pos));
distt(distt==0)=inf;
neighboor_dis=mean(min(distt,[],1));
neighboor_dis_std=std(min(distt,[],1));

neighboor_dis_high_estimate=neighboor_dis+2*neighboor_dis_std;