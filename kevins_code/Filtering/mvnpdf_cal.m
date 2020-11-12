function A=mvnpdf_cal(data_shape,centroid,cov)
A=zeros(data_shape(1),data_shape(2));
for j=1:data_shape(1)*data_shape(2)
    [ind1,ind2]=ind2sub(data_shape,j);  
    A(j)=mvnpdf([ind2,ind1],centroid,cov);
end