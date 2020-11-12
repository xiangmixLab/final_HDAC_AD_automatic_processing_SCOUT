function [bin_dat,idx]=binarize_data(dat,binpos)

bin_dat=zeros(length(binpos),size(dat,2));
binsize=diff(binpos);
idx=[];
for i = 1:length(binpos)
    bin_dat(i,:)=mean(dat(binpos(i):binpos(i)+binsize-1,:),1);
    idx(binpos(i):binpos(i)+binsize-1,1)=i;
end

