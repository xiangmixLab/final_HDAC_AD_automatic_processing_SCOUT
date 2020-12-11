% dirr: 'row' or 'col'
function dat_trunk=trunk_split_data(dat,trunk_num,dirr)

interval=round(size(dat,2)/(trunk_num));
interval_list=[ones(1,floor(size(dat,2)/interval))*interval,size(dat,2)-floor(size(dat,2)/interval)*interval];
interval_list(interval_list==0)=[]; % the last one is 0 inperfact case

if isequal(dirr,'col')
    dat_trunk=mat2cell(dat',interval_list); %mat2cell(dat,[row_sizes_of_the_mat_in_current_splitted_cell],[col_sizes_of_the_mat_in_current_splitted_cell])
    for i=1:length(dat_trunk)
        dat_trunk{i}=dat_trunk{i}';
    end
    dat_trunk=dat_trunk';
else
    dat_trunk=mat2cell(dat,interval_list);
end