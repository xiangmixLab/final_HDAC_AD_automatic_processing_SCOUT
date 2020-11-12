function pdt_out=linearTrack_centroid_sort(pdt)

cen=[];
for i=1:size(pdt,1)
    t=pdt(i,:);
    t=t>0.7*max(t);
    statss=regionprops(t);
    cenn=[];
    for j=1:length(statss)
        cenn(j,:)=statss(j).Centroid;
    end
    if ~isempty(cenn)
        cen(i,:)=mean(cenn,1);
    else
        cen(i,:)=[0 0];
    end
end

[~,idx]=sort(cen(:,1));

pdt_out=pdt(idx,:);