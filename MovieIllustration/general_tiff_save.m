function general_tiff_save(Y,fname)

if length(size(Y))<3
    imwrite(Y,fname, 'Compression', 'none');
end
if length(size(Y))==3&&size(Y,3)==3
    imwrite(Y,fname, 'Compression', 'none');
end
if length(size(Y))==3&&size(Y,3)~=3
    for x = 1 : size(Y,3)
            imwrite(squeeze(Y(:,:,x)),fname, 'Compression', 'none','WriteMode', 'append');
    end
end
if length(size(Y))==4
    for x = 1 : size(Y,4)
            imwrite(squeeze(Y(:,:,:,x)),fname, 'Compression', 'none','WriteMode', 'append');
    end
end
disp('fin save');