function Y=general_tiff_read(fname)

FileTif=fname;
InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width
nImage=InfoImage(1).Height
NumberImages=length(InfoImage)
 
FinalImage=zeros(nImage,mImage,NumberImages,'uint16');
for i=1:NumberImages
   Y(:,:,i)=imread(FileTif,'Index',i);
end