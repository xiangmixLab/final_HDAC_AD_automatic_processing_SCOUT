function Y_denoised=calcium_PCA_gaussBg_processing(Y)

%% downsample
Yt=imresize(Y,0.5);
Yt=Yt(:,:,1:2:end);

%% gaussian Bg subtraction
Yt=double(Yt);
mean_Yt=mean(Yt,3);
Yt=Yt-mean_Yt;

for i=1:size(Yt,3)
    Y1t=squeeze(Yt(:,:,i));
    Y1t_bg=imgaussfilt(Y1t,50);
    Yt(:,:,i)=Yt(:,:,i)-Y1t_bg;
    Yt(:,:,i)=Yt(:,:,i)-min(min(Yt(:,:,i)));
end

tstep=150;
substack_std=[];
ctt=1;
for i=1:tstep:size(Yt,3)-tstep
    substack=Yt(:,:,i:i+tstep-1);
    substack_std(:,:,ctt)=std(substack,[],3);
    ctt=ctt+1;
end

for i=1:tstep:size(Yt,3)-tstep
    substack=Yt(:,:,i:i+tstep-1);
    substack_std(:,:,ctt)=std(substack,[],3);
    ctt=ctt+1;
end

% 
% S1=reshape(substack_std,size(substack_std,1)*size(substack_std,2),size(substack_std,3));
% [coeff,score,latent,tsquared,explained,mu] = pca(S1');
% 
% coeff(:,4:end)=coeff(:,4:end)*0;
% 
% bg_denoised_t=score*coeff';
% bg_denoised=reshape(Y_denoised_t',size(substack_std,1),size(substack_std,2),size(substack_std,3));
% 
% substack_std1=substack_std-bg_denoised;