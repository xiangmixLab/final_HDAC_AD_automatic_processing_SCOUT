function Y_reconstruct=general_video_PCA(Y,component)

Y_reshape=reshape(Y,size(Y,1)*size(Y,2),size(Y,3));
[coeff1, score1, latent, tsquared, explained, mu1] = pca(double(Y_reshape));
coeff2=coeff1;
coeff2(:,component)=1;
Y_reconstruct=reshape(score1*coeff2' + repmat(mu1,size(score1,1),1),size(Y,1),size(Y,2),size(Y,3));

