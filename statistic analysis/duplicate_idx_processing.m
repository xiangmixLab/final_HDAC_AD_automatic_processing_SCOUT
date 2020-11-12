function [new_dat,uni_idx]=duplicate_idx_processing(dat,idx,method)

uni_idx=unique(idx);

new_dat=[];

for i=1:length(uni_idx)
    dat_in_idx=dat(idx==uni_idx(i));
    if isequal(method,'max')
        dat_idx_avg=max(dat_in_idx);
    else
        dat_idx_avg=mean(dat_in_idx);
    end
    new_dat(i,1)=dat_idx_avg;
end