function concatenatedvideo=avi_matrix_read_parallel_util(fnv,z_leng)
v=VideoReader(fnv);
concatenatedvideo=uint8(zeros(v.Height,v.Width,z_leng));
p=1;
for i=1:z_leng
    t=read(v,i);
    concatenatedvideo(:,:,i)=t;
    p=p+1;
end