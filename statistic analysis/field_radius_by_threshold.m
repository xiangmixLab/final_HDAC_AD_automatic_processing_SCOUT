function radi=field_radius_by_threshold(fr,ct)

fr(ct==0)=0;
fr1=filter2DMatrices(fr,1);

fr2=fr1>0.5*max(fr1(:));

stats=regionprops(fr2,'Area','MajorAxisLength');

Area_all=[stats.Area];

[Area_all_sort,idx]=sort(Area_all);
ratio_to_next=[];
for i=1:length(Area_all_sort)
    ratio_to_next(i)=Area_all_sort(1)/Area_all_sort(i);
end
if ~isempty(find(ratio_to_next>1.5))
    all_major_area_idx=idx(1:find(ratio_to_next>1.5));
else
    all_major_area_idx=idx(1:end); % 1 field, multi similar size field
end

radi=[];
for i=1:length(all_major_area_idx)
    radi(i)=stats(all_major_area_idx(i)).MajorAxisLength/2;
end
radi=mean(radi);
