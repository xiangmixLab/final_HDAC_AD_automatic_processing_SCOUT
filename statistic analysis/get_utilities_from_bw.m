function [cen_all,area_all,bbox_all]=get_utilities_from_bw(PMapt)

stats=regionprops(PMapt,'Area','BoundingBox','Centroid');

area_all=[stats.Area];
bbox_all=[];
cen_all=[];
for j=1:length(stats)
    cen_all(j,:)=stats(j).Centroid;
    bbox_all(j,:)=stats(j).BoundingBox;
end


