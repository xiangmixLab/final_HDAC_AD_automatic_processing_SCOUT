%for left up, right up, right down, left down type
function withObj_idx=dryland_withobj_determine(behavname)

for i=1:length(behavname)
    load(behavname{i});
    if isempty(behav.object)||sum(behav.object(:))==0
        withObj_idx(i)=0;
    else
        withObj_idx(i)=1;
    end
end
