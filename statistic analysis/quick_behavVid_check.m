function quick_behavVid_check(V,behav,vid_num)
v=VideoReader(['behavCam1_',num2str(vid_num),'1.avi']);
k=1;
disp('read vid')
while hasFrame(v)
    V{k}=readFrame(v);
    k=k+1;
end
disp('vid read fin');
figure;
for i=1:length(V)
    imagesc(V{i+(min(vid_num)-1)*1000});
    hold on;
    plot(behav.position(1+(min(vid_num)-1)*1000:i+(min(vid_num)-1)*1000,1)*behav.ROI3/behav.trackLength+behav.ROI(1)*behav.ROI3/behav.trackLength,behav.position(1+(min(vid_num)-1)*1000:i+(min(vid_num)-1)*1000,2)*behav.ROI3/behav.trackLength+behav.ROI(2)*behav.ROI3/behav.trackLength,'-','color','r','lineWidth',1)
    drawnow;
end
