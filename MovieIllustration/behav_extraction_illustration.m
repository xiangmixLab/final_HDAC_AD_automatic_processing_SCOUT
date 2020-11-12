%% quick illustration
% load([vname{p},'_Behav.mat']);
v = VideoWriter(['mouseBehavIllustration.avi']);
open(v);
tempf=[];
tempf=uint8(tempf);
 for i=1:1:behav.numFrames
tempf{i}=rgb2gray(uint8(msReadFrame(behav,i,false,false,false)));
 end
 
pos1=[behav.positionblue(:,1)*behav.ROI3/behav.trackLength+behav.ROI(1), behav.positionblue(:,2)*behav.ROI3/behav.trackLength+behav.ROI(2)];
pos2=[behav.position(:,1)*behav.ROI3/behav.trackLength+behav.ROI(1), behav.position(:,2)*behav.ROI3/behav.trackLength+behav.ROI(2)];
% pos1=behav.positionTail;
% pos2=behav.positionEar;
% 
for i=1:size(tempf,3)
imshow(tempf{i});hold on
plot(pos2(1:i,1),pos2(1:i,2),'r-');
% quiver(pos1(i,1),pos1(i,2),pos2(i,1)-pos1(i,1),pos2(i,2)-pos1(i,2),'MaxHeadSize',1000);
title(num2str(i));
drawnow;
frame=getframe(gcf);
writeVideo(v,frame);
clf
end
close(v);
disp(['finish ']);
