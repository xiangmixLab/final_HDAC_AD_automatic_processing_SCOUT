kindex_resize_all=[];
for f=1:length(orilocation)
    cd(orilocation{f});
    behav = msGenerateVideoObj(pwd,'behavCam1_');
    tic
    count=1;
    frame = double(msReadFrame(behav,round(behav.numFrames/2)+100,false,false,false))/255;
    frame1=zeros(size(frame,1),size(frame,2),3,round(behav.numFrames/2));
    for i=1:2:behav.numFrames
        frame1(:,:,:,count)=double(msReadFrame(behav,i,false,false,false))/255;
        count=count+1;
    end
    frame1_bg=median(frame1,4);
    frame1_bg_resize=reshape(frame1_bg,size(frame1_bg,1)*size(frame1_bg,2),size(frame1_bg,3));
    for i=1:size(frame1_bg_resize,2)
        kindex(:,i)=kmeans(frame1_bg_resize(:,i),2);
    end
    kindex_resize=reshape(kindex_resize,size(frame1_bg,1),size(frame1_bg,2),size(frame1_bg,3));
    kindex_resize_all(:,:,:,f)=kindex_resize;
    toc
end