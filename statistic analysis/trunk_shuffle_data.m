function dat1=trunk_shuffle_data(dat,trunk_num)

interval=round(size(dat,2)/(trunk_num));

trunk_start=1:interval:size(dat,2);

for i=1:length(trunk_start)
    for j=1:size(dat,1)
        dat_trunk{j,i}=dat(j,trunk_start(i):min(trunk_start(i)+interval-1,size(dat,2)));
    end
end

for i=1:size(dat,1)
    dat_trunk_row=dat_trunk(i,:);
    rand_order=randperm(trunk_num);
    dat_shuf(i,:)=cell2mat(dat_trunk_row(rand_order));
end

dat1=dat_shuf;