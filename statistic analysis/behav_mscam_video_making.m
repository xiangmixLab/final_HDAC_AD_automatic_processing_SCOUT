function behav_mscam_video_making(foldername,msprefix,behavprefix,Behavfilepostfix,savedir)


cd(foldername);
behav_list=dir(['*',Behavfilepostfix,'.mat']);
vid_num=[9 10];

behavname=behav_list.name;

for i=1:length(vid_num)
    ms_vid_name{i}=[msprefix,num2str(vid_num(i)),'.avi'];
    behav_vid_name{i}=[behavprefix,num2str(vid_num(i)),'.avi'];
end

load(behavname);

msFrame=[];
behavFrame={};
k1=1;
k2=1;

for i=1:length(vid_num)
    v1=VideoReader(ms_vid_name{i});
    v2=VideoReader(behav_vid_name{i});

    while hasFrame(v1)
        msFrame(:,:,k1)=readFrame(v1);
        k1=k1+1;
        disp('1');
    end
    while hasFrame(v2)
        behavFrame{k2}=readFrame(v2);
        k2=k2+1;
        disp('2');
    end
end

% motion correction
msFrame_corrected=runrigid1_func(msFrame);

h=figure;
set(gcf,'position',[0 0 1900 1000]);
sav=[savedir,'\example_ms_behav_vid.avi'];
a=VideoWriter(sav,'Motion JPEG AVI');
a.FrameRate=15;
open(a)

idx=[1:length(msFrame)];
idx_resample=round(resample(idx,2000/30*15,2000))
for i=1:length(msFrame)
    subplot(121)
    imshow(uint8(msFrame_corrected(:,:,i)));
    subplot(122)
    imshow(V{i});
    hold on;
    plot(behav.position(1+(min(vid_num)-1)*1000:i+(min(vid_num)-1)*1000,1)*behav.ROI3/behav.trackLength+behav.ROI(1)*behav.ROI3/behav.trackLength,behav.position(1+(min(vid_num)-1)*1000:i+(min(vid_num)-1)*1000,2)*behav.ROI3/behav.trackLength+behav.ROI(2)*behav.ROI3/behav.trackLength,'-','color','r','lineWidth',1)
    drawnow;
    framee=getframe(h);
    writeVideo(a,framee.cdata);
    disp('3');
    clf
end
close(a);

for i=1:length(idx_resample)
    subplot(121)
    imshow(uint8(msFrame_corrected(:,:,idx_resample(i))));
    title('neuron')
    subplot(122)

    imshow(V{i+3960});
        title('behav')
    drawnow;
    framee=getframe(h);
    writeVideo(a,framee.cdata);
    disp('3');
    clf
end
close(a);