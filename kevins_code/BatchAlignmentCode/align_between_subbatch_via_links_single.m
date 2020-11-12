function [combined,scores]=align_between_subbatch_via_links_single(neurons_batch_1,neurons_batch_2,link,overlap,height,width)
%Returns linked neurons if any link above threshold, 0's in neuron 2 else.

C_corr1 =correlations_positive(neurons_batch_1.S(:,end-overlap+1:end),link.S(:,1:overlap),'S');
C_corr2=correlations_positive(neurons_batch_1.C(:,end-overlap+1:end),link.C(:,1:overlap));
C_corr3=correlations_positive(neurons_batch_1.C(:,end-overlap+1:end),link.C(:,1:overlap),'pearson');
C_corr=max([reshape(C_corr1,[],1),reshape(C_corr2,[],1),reshape(C_corr3,[],1)],[],2);
C_corr=reshape(C_corr,size(C_corr1));
correlations1=C_corr;
dist1=compute_pairwise_distance(neurons_batch_1,link,height,width,'overlap');
Combined_Metric1=.3*dist1+.7*(1-correlations1);


C_corr1 =correlations_positive(link.S(:,end-overlap+1:end),neurons_batch_2.S(:,1:overlap),'S');
C_corr2=correlations_positive(link.C(:,end-overlap+1:end),neurons_batch_2.C(:,1:overlap));
C_corr3=correlations_positive(link.C(:,end-overlap+1:end),neurons_batch_2.C(:,1:overlap),'pearson');
C_corr=max([reshape(C_corr1,[],1),reshape(C_corr2,[],1),reshape(C_corr3,[],1)],[],2);
C_corr=reshape(C_corr,size(C_corr1));
correlations2=C_corr;
dist2=compute_pairwise_distance(link,neurons_batch_2,height,width,'overlap');
Combined_Metric2=.3*dist2+.7*(1-correlations2);
% 
% 
% correlations1(KL1>threshold)=0;
% correlations1(correlations1<corr_thresh)=0;
% KL1(KL1>threshold)=threshold+1;
% KL1(correlations1<corr_thresh)=threshold+1;
% Combined_Metric1(Combined_Metric1<0)=0;
% Combined_Metric1(KL1>threshold)=0;
% Combined_Metric1(correlations1<corr_thresh)=0;

%correlations2(KL2>threshold)=0;
%correlations2(correlations2<corr_thresh)=0;
%KL2(KL2>threshold)=threshold+1;
%KL2(correlations2<corr_thresh)=threshold+1;

%Combined_Metric2(Combined_Metric2<0)=0;
%Combined_Metric2(KL2>threshold)=0;
%Combined_Metric2(correlations2<corr_thresh)=0;

Linking_Scores=zeros(size(neurons_batch_1.C,1),size(neurons_batch_2.C,1));
corr_scores=zeros(size(Linking_Scores));
KL_scores=zeros(size(Linking_Scores));
for i=1:size(neurons_batch_1.C,1)
    for j=1:size(neurons_batch_2.C,1)
        [Linking_Scores(i,j),link_neuron]=find_min_link_scores(i,j,Combined_Metric1,Combined_Metric2);
        corr_scores(i,j)=(correlations1(i,link_neuron)+correlations2(link_neuron,j))/2;
        KL_scores(i,j)=(KL1(i,link_neuron)+KL2(link_neuron,j))/2;
    end
end

combined=zeros(size(neurons_batch_1.C,1),2);
scores=zeros(size(combined));
combined(:,1)=1:size(neurons_batch_1.C,1);

Linking_Scores(isinf(Linking_Scores)|isnan(Linking_Scores))=min(1001,max(max(Linking_Scores(~isinf(Linking_Scores)&~isnan(Linking_Scores))))+1);

Max_Link=min(max(max(Linking_Scores)),1000);
while min(min(Linking_Scores))<=Max_Link
    [M,I]=min(reshape(Linking_Scores,1,[]));
    [a,b]=ind2sub(size(Linking_Scores),I);
    %if corr_scores(a,b)>corr_thresh&KL_scores(a,b)<threshold
    combined(a,2)=b;
    scores(a,1)=corr_scores(a,b);
    scores(a,2)=KL_scores(a,b);
    Linking_Scores(a,:)=ones(1,size(Linking_Scores,2))*(1+Max_Link); Linking_Scores(:,b)=ones(size(Linking_Scores,1),1)*(1+Max_Link);
    
end  
% for i=1:size(scores,1)
%     if scores(i,2)==0
%         scores(i,2)=threshold+1;
%     end
% end
% 





end
