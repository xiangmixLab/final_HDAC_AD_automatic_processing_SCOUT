function [avg_cen,all_cen]=firing_field_avg_center(firingrate)

for i=1:length(firingrate)
    t=firingrate{i};
    t=filter2DMatrices(t,1);
    t=t>max(t(:))*0.7;
    stats=regionprops(t);
    cen=[]
    for j=1:length(stats)
        cen(j,:)=stats(j).Centroid;
    end
    all_cen{i}=cen;
    avg_cen(i,:)=mean(cen,1);
end
    
    