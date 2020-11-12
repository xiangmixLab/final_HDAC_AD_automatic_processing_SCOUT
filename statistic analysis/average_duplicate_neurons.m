function [new_dat,uni_idx]=average_duplicate_neurons(dat,idx)

uni_idx=unique(idx);

new_dat=[];

for i=1:length(uni_idx)
    dat_idx=dat(idx==uni_idx(i));
    dat_idx_avg=nanmean(dat_idx);
    new_dat(i,1)=dat_idx_avg;
end