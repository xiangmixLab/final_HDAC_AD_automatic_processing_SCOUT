function h=cluster_spatial_footprint_colormap_centroid(cen,group)
colorClusters_all=distinguishable_colors(100);
h=figure;
hold on;
for i=1:size(cen,1)
    if group(i)>0
        plot(cen(i,1),cen(i,2),'o','color',colorClusters_all(group(i),:));
    end
end