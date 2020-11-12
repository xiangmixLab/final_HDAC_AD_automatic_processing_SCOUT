function [new_A1,new_A2,data_shape]=align_spatial_footprints(C1,C2,A1,A2,data_shape1,data_shape2)
correlations=correlations_positive(C1,C2,'pearson');
corr_shape=size(correlations);
correlations=reshape(correlations,1,[]);
alignment_pairs=[];
for i=1:15
    [M,I]=max(correlations);
    [a,b]=ind2sub([corr_shape],I);
   
    alignment_pairs=vertcat(alignment_pairs,[a,b]);
    correlations(I)=0;
end
centroids1=[];
centroids2=[];
for i=1:15
    centroid=calculateCentroid(A1(:,alignment_pairs(i,1)),data_shape1(1),data_shape1(2));
    centroids1=[centroids1;centroid];
    centroid=calculateCentroid(A2(:,alignment_pairs(i,2)),data_shape2(1),data_shape2(2));
    centroids2=[centroids2;centroid];
end
centroid_diff=centroids1-centroids2;
outliers=isoutlier(centroid_diff);
remove_indices=find(outliers(:,1)==1);
centroid_diff(remove_indices,:)=[];

centroid_mean_diff=round(mean(centroid_diff,1));


new_Ashape=[max(data_shape1(1),data_shape2(1))+abs(centroid_mean_diff(2)),max(data_shape1(2),data_shape2(2))+abs(centroid_mean_diff(1))];
leftindex1=0;
leftindex2=leftindex1+centroid_mean_diff(1);
topindex1=0;
topindex2=topindex1+centroid_mean_diff(2);


leftin1=leftindex1+abs(min(leftindex1,leftindex2))+1;
leftin2=leftindex2+abs(min(leftindex1,leftindex2))+1;
topin1=topindex1+abs(min(topindex1,topindex2))+1;
topin2=topindex2+abs(min(topindex1,topindex2))+1;

leftindex1=leftin1;
leftindex2=leftin2;
topindex1=topin1;
topindex2=topin2;
new_A1=[];
for i=1:size(A1,2);
    A=zeros(new_Ashape);
    B=reshape(A1(:,i),data_shape1);
    A(topindex1:topindex1+data_shape1(1)-1,leftindex1:leftindex1+data_shape1(2)-1)=B;
    new_A1=cat(3,new_A1,A);
end

new_A2=[];
for i=1:size(A2,2);
    A=zeros(new_Ashape);
    B=reshape(A2(:,i),data_shape2);
    A(topindex2:topindex2+data_shape2(1)-1,leftindex2:leftindex2+data_shape2(2)-1)=B;
    new_A2=cat(3,new_A2,A);
end
A1_proj=max(new_A1,[],3);
A2_proj=max(new_A2,[],3);

remove_top=0;
remove_bottom=0;
remove_left=0;
remove_right=0;

for i=1:size(A1_proj,1);
    if sum(A1_proj(1:i,:),'all')==0&&sum(A2_proj(1:i,:),'all')==0
        remove_top=i;
    else
        break;
    end
    
end


for i=size(A1_proj,1):-1:1;
    if sum(A1_proj(i:end,:),'all')==0&&sum(A2_proj(i:end,:),'all')==0
        remove_bottom=i;
    else
        break;
    end
    
end



for i=1:size(A1_proj,2);
    if sum(A1_proj(:,1:i),'all')==0&&sum(A2_proj(:,1:i),'all')==0
        remove_left=i;
    else
        break;
    end
    
end


for i=size(A1_proj,2):-1:1
    if sum(A1_proj(:,i:end),'all')==0&&sum(A2_proj(:,i:end),'all')==0
        remove_right=i;
    else
        break;
    end
    
end
if remove_top>0
    new_A1=new_A1(remove_top+1:end,:,:);
    new_A2=new_A2(remove_top+1:end,:,:);
    remove_bottom=remove_bottom-remove_top;
end
if remove_bottom>0
    new_A1=new_A1(1:remove_bottom-1,:,:);
    new_A2=new_A2(1:remove_bottom-1,:,:);
end
if remove_left>0
    new_A1=new_A1(:,remove_left+1:end,:);
    new_A2=new_A2(:,remove_left+1:end,:);
    remove_right=remove_right-remove_left;
end
if remove_right>0
    new_A1=new_A1(:,1:remove_right-1,:);
    new_A2=new_A2(:,1:remove_right-1,:);
end
data_shape=[size(new_A1,1),size(new_A1,2)];
new_A1=reshape(new_A1,[],size(A1,2));
new_A2=reshape(new_A2,[],size(A2,2));






