behavname=behavName';
quad_idx=dryland_quadrant_determine(behavname);
withObj_idx=ones(149,1);
withObj_idx([1,2,84:86 102:107 123:128 144:149])=0;
trial_idx={
    [3:11];
    [12:20];
    [21:29];
    [30:47];
    [48:65];
    [66:86];
    [87:107];
    [108:128];
    [129:149]
    }

trial_combine_idx=cell(9,4);
trial_combine_idx_test=cell(9,4);

for i=1:length(trial_idx)
    for j=trial_idx{i}
        if withObj_idx(j)==1
            trial_combine_idx{i,quad_idx(j)}=[trial_combine_idx{i,quad_idx(j)},j];
        else
            trial_combine_idx_test{i,quad_idx(j)}=[trial_combine_idx_test{i,quad_idx(j)},j];
        end
    end
end

