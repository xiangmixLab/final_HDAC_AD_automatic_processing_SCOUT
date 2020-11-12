function neuron_correspond_idx=corresponding_centroid(c1,c2)
for j=1:size(c1,1)
    for k=1:size(c2,1)
        if sum((c2(k,:)-c1(j,:)).^2).^0.5<=5  
            neuron_correspond_idx(j,:)=[j,k];
            break;
        end
    end
end