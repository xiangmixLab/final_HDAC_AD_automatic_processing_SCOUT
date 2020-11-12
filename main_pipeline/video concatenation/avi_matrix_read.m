function concatenatedvideo=avi_matrix_read(v,z_leng)

concatenatedvideo=uint8(zeros(v.Height,v.Width,z_leng));
p=1;
while hasFrame(v)
    t=readFrame(v);
    concatenatedvideo(:,:,p)=t;
    p=p+1;
end