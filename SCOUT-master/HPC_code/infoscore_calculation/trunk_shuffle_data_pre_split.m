function dat1=trunk_shuffle_data_pre_split(dat_trunk)

rand_order=randperm(max(size(dat_trunk))); % one dim should be 1, the other is the one splitted
dat_shuf=cell2mat(dat_trunk(rand_order));
dat1=dat_shuf;