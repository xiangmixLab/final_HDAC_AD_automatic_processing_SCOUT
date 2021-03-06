function [A1_comp,A2_comp]=construct_comparison_footprint_gaussian(centroid,covariance,data_shape)
[X,Y]=meshgrid(1:data_shape(2),1:data_shape(1));
X=reshape(X,[],1);
Y=reshape(Y,[],1);
Z=mvnpdf([X,Y],centroid,covariance);
A1_comp=reshape(Z,data_shape(1),data_shape(2));
A2_comp=A1_comp;

