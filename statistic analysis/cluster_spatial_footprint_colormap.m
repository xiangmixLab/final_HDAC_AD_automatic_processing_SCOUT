function A_color=cluster_spatial_footprint_colormap(neuronIndividuals_new,d1,d2,colorClusters_all,group)
A_color=ones(d1*d2,3);
for celll=1:size(neuronIndividuals_new{1}.C,1)
    Ai=reshape(neuronIndividuals_new{1}.A(:,celll),d1,d2);
    Ai(Ai<0.65*max(Ai(:)))=0;
    Ai=logical(Ai);
    Ai=bwareaopen(Ai,9);
    se=strel('disk',2);
    Ai=imclose(Ai,se);
    ind=find(Ai>0);%the pixels at which a neuron shows up
    A_color(ind,:)=repmat(colorClusters_all(group(celll),:),length(ind),1);
end
A_color=reshape(A_color,d1,d2,3);