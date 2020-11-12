function concatenatedvideo=avi_matrix_read_cell(v)

concatenatedvideo={};
p=1;
while hasFrame(v)
    t=readFrame(v);
    concatenatedvideo{p}=t;
    p=p+1;
end