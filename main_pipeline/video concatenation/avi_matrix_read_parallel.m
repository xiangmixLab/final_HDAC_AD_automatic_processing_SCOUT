function concatenatedvideo=avi_matrix_read_parallel(v,z_leng)

concatenatedvideo=uint8(zeros(v.Height,v.Width,z_leng));

totalNumFrames=v.NumberOfFrames;
spmd 
    myFrameIdxs = find(discretize(1:totalNumFrames, numlabs) == labindex);  
       % numlabs - Total number of workers operating in parallel on current job 
    % read chunk of data 
    myFrameData = readVideoData(videoFname, myFrameIdxs); 
    % process chunk of data 
    
end 