function behav_vid_with_track(behavFolder,behavdat,savname)

v = VideoWriter([savname]);
open(v);
tempf=[];
tempf=uint8(tempf);

cd(behavFolder);
behavVid=dir(['behavCam*.avi']);

ctt=1;
 for i=1:length(behavVid)
     vnamee=behavVid(i).name;
     bv=VideoReader(vnamee);
     while hasFrame(bv)
         tempf{ctt}=uint8(readFrame(bv));
         ctt=ctt+1;
     end
     disp(['read behavVid ',num2str(i)])
 end

 load(behavdat);
pos1=[behav.positionblue(:,1)*behav.ROI3/behav.trackLength+behav.ROI(1)*behav.ROI3/behav.trackLength, behav.positionblue(:,2)*behav.ROI3/behav.trackLength+behav.ROI(2)*behav.ROI3/behav.trackLength];
pos2=[behav.position(:,1)*behav.ROI3/behav.trackLength+behav.ROI(1)*behav.ROI3/behav.trackLength, behav.position(:,2)*behav.ROI3/behav.trackLength+behav.ROI(2)*behav.ROI3/behav.trackLength];
% pos1=behav.positionTail;
% pos2=behav.positionEar;
% 
for i=1:length(tempf)
imshow(tempf{i});hold on
plot(pos2(1:i,1),pos2(1:i,2),'r-');
% quiver(pos1(i,1),pos1(i,2),pos2(i,1)-pos1(i,1),pos2(i,2)-pos1(i,2),'MaxHeadSize',1000);
title(num2str(i));
drawnow;
frame=getframe(gcf);
writeVideo(v,frame);
disp(num2str(i))
clf
end
close(v);
disp(['finish ']);
