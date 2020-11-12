function cellmatrix=image2patch(mean_data,patch_size)
    cellmatrix = {};
    ctt1=1;
    ctt2=1;
    for i=1:patch_size(1):size(mean_data,1)-patch_size(1)
        for j=1:patch_size(2):size(mean_data,2)-patch_size(2)
            cellmatrix{ctt1,ctt2}=mean_data(i:i+patch_size(1)-1,j:j+patch_size(2)-1);
            ctt2=ctt2+1;
        end
        ctt2=1;
        ctt1=ctt1+1;
    end