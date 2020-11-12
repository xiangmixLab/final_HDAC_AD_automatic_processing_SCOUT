function bin_image=binning_matrix(m,nbins)

bin_interval=[round(size(m,1)/nbins(1)),round(size(m,2)/nbins(2))];

bin_image=[];

ctt1=1;
ctt2=1;
for i=1:bin_interval(1):nbins(1)
    for j=1:bin_interval(2):nbins(2)
        patchh=m(i:i+bin_interval(1)-1,j:j+bin_interval(2)-1);
        bin_image(ctt1,ctt2)=mean(patchh(:));
        ctt2=ctt2+1;
    end
    ctt1=ctt1+1;
    ctt2=1;
end