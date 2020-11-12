function G=build_linkage_graph_single(neuron_set1,neuron_set2,overlap,height,width,index_letter1,index_letter2,G,dist_meth)
if ~exist('G','var')
    G=digraph();
end

dist1=compute_pairwise_distance(neuron_set1,neuron_set2,height,width,dist_meth);
C_corr1 =correlations_positive(neuron_set1.S(:,end-overlap+1:end),neuron_set2.S(:,1:overlap),'S');
C_corr2=correlations_positive(neuron_set1.C(:,end-overlap+1:end),neuron_set2.C(:,1:overlap));
C_corr3=correlations_positive(neuron_set1.C(:,end-overlap+1:end),neuron_set2.C(:,1:overlap),'pearson');
C_corr=max([reshape(C_corr1,[],1),reshape(C_corr2,[],1),reshape(C_corr3,[],1)],[],2);
C_corr=reshape(C_corr,size(C_corr1));

if isequal(dist_meth,'overlap')
    dist1(dist1==1)=score_thresh+100;
end
if isequal(dist_meth,'centroid_dist')
    dist1=atan(dist1/4)*2/pi;
end

for i=1:size(neuron_set1.C,1)
    if findnode(G,horzcat(index_letter1,num2str(i)))==0
        G=addnode(G,horzcat(index_letter1,num2str(i)));
    end
end
for i=1:size(neuron_set2.C,1)
    if findnode(G,horzcat(index_letter2,num2str(i)))==0
        G=addnode(G,horzcat(index_letter2,num2str(i)));
    end
end
for i=1:size(C_corr,1)*size(C_corr,2)
    if C_corr(i)>.65&&dist1(i)<.65
        [a,b]=ind2sub(size(C_corr),i);
        G=addedge(G,horzcat(index_letter1,num2str(a)),horzcat(index_letter2,num2str(b)),.5*C_corr(i)+.5*dist1(i));
    end
end
