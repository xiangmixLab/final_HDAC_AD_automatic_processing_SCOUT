function neuron=combined_over_overlap(neuron1,neuron2,overlap,data_shape)
%for i=1:size(neuron1.C,1)
%    for j=1:size(neuron2.C,1)
%        correlations(i,j)=corr(neuron1.C(i,end-overlap+1:end)',neuron2.C(j,1:overlap)');
  %      KL(i,j)=spatial_overlap_via_bivariate_gaussian(neuron1.A(:,i),neuron2.A(:,j),data_shape(1),data_shape(2));
%    end
%end
correlations1=correlations_positive(neuron1.C(:,end-overlap+1:end),neuron2.C(:,1:overlap));
correlations2=correlations_positive(neuron1.C(:,end-overlap+1:end),neuron2.C(:,1:overlap),'pearson');
correlations3=correlations_positive(neuron1.S(:,end-overlap+1:end),neuron2.S(:,1:overlap),'S');
correlations=max([reshape(correlations1,[],1),reshape(correlations2,[],1),reshape(correlations3,[],1)],[],2);
correlations=reshape(correlations,size(correlations1));



temp1 = bsxfun(@times, neuron1.A>0, 1./sqrt(sum(neuron1.A>0)));
temp2 = bsxfun(@times, neuron2.A>0, 1./sqrt(sum(neuron2.A>0)));
A_overlap=temp1'*temp2;

A_thr=.3;
%KL_thr=3;
corr_thr=.55;

indices=(A_overlap<A_thr|correlations<corr_thr);
correlations(indices)=0;

neuron=neuron1.copy();
neuron.C(:,end+1:size(neuron1.C,2)+size(neuron2.C,2)-overlap)=0;
neuron.S(:,end+1:size(neuron1.C,2)+size(neuron2.C,2)-overlap)=0;
neuron.C_raw(:,end+1:size(neuron1.C,2)+size(neuron2.C,2)-overlap)=0;
N=size(neuron.combined,2)+1;
for i=1:size(neuron1.C,1)
    [M,I]=max(correlations(i,:));
    if M>0
    neuron.C(i,:)=horzcat(neuron1.C(i,:),neuron2.C(I,overlap+1:end));
    neuron.C_raw(i,:)=horzcat(neuron1.C_raw(i,:),neuron2.C_raw(I,overlap+1:end));
    neuron.S(i,:)=horzcat(neuron1.S(i,:),neuron2.S(I,overlap+1:end));
    
    neuron.scores(i,N)=neuron2.scores(I);
    
    neuron.combined(i,N)=neuron2.combined(I);   
    %neuron.corr_scores(i,1:size(neuron1.corr_scores,2)+size(neuron2.corr_scores,2)-4)=horzcat(neuron1.corr_scores,neuron2.corr_scores(5:end));
    %neuron.KL_scores(i,1:size(neuron1.corr_scores,2)+size(neuron2.corr_scores,2)-4)=horzcat(neuron1.KL_scores,neuron2.KL_scores(5:end));
    neuron.scores(i,N)=neuron2.scores(I);
 
    neuron.combined(i,N)=neuron2.combined(I);
    %neuron.corr_scores=vertcat(neuron.corr_scores,horzcat(neuron1.corr_scores(i,:),neuron2.corr_scores(I,5:end)));
    %neuron.KL_scores=vertcat(neuron.KL_scores,horzcat(neuron1.KL_scores(i,:),neuron2.KL_scores(I,5:end)));
    neuron.A(:,i)=(neuron1.A(:,i)+neuron2.A(:,I))/2;
    neuron.overlap_corr(i,N)=correlations(i,I);
    neuron.overlap_dist(i,N)=A_overlap(i,I);
    end
end
neuron.overlap_corr(end+1:size(neuron.C,1),:)=0;
neuron.overlap_dist(end+1:size(neuron.C,1),:)=0;
indices=find(neuron.overlap_corr(:,end)==0);
neuron.scores(indices,:)=[];
neuron.combined(indices,:)=[];
neuron.overlap_corr(indices,:)=[];
neuron.overlap_dist(indices,:)=[];
neuron.C(indices,:)=[];
neuron.S(indices,:)=[];
neuron.C_raw(indices,:)=[];
neuron.centroid(indices,:)=[];
neuron.A(:,indices)=[];

