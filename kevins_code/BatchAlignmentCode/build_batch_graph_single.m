function G=build_batch_graph_single(neuron_set1,neuron_set2,overlap,height,width,index_letter1,index_letter2,score_thresh,G,corr_type,dist_meas)
if ~exist('G','var')
    G=digraph();
end

dist=compute_pairwise_distance(neuron_set1,neuron_set2,height,width,dist_meas);

C_corr1 =correlations_positive(neuron_set1.S(:,end-overlap+1:end),neuron_set2.S(:,1:overlap),'S');
C_corr2=correlations_positive(neuron_set1.C(:,end-overlap+1:end),neuron_set2.C(:,1:overlap));
C_corr3=correlations_positive(neuron_set1.C(:,end-overlap+1:end),neuron_set2.C(:,1:overlap),'pearson');
C_corr=max([reshape(C_corr1,[],1),reshape(C_corr2,[],1),reshape(C_corr3,[],1)],[],2);
C_corr=reshape(C_corr,size(C_corr1));
correlations=C_corr;


Combined_Metric1=.3*dist+.7*(1-correlations);

Combined_Metric1(isinf(Combined_Metric1)|isnan(Combined_Metric1))=min(1001,max(max(Combined_Metric1(~isinf(Combined_Metric1)&~isnan(Combined_Metric1))))+1);

Combined_Metric1(Combined_Metric1>score_thresh)=0;


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
for i=1:size(Combined_Metric1,1)*size(Combined_Metric1,2)
    if Combined_Metric1(i)>0&C_corr(i)>.4
        [a,b]=ind2sub(size(Combined_Metric1),i);
        G=addedge(G,horzcat(index_letter1,num2str(a)),horzcat(index_letter2,num2str(b)),Combined_Metric1(i));
    end
end
