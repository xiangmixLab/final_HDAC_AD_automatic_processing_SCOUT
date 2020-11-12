function behav_vid_with_track_check(behavFolder,behavdat,behavprefix,color_sign)

tempf=[];
tempf=uint8(tempf);

cd(behavFolder);
behavVid=dir([behavprefix,'*.avi']);

ctt=1;
 for i=1:length(behavVid)
     vnamee{i}=behavVid(i).name;
 end
 
 vnamee=natsort(vnamee);
 
 for i=1:length(behavVid) 
     bv=VideoReader(vnamee{i});
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
if isequal(color_sign,'r')
    plot(pos2(1:i,1),pos2(1:i,2),'r-');
else
    plot(pos1(1:i,1),pos1(1:i,2),'b-');
end
% quiver(pos1(i,1),pos1(i,2),pos2(i,1)-pos1(i,1),pos2(i,2)-pos1(i,2),'MaxHeadSize',1000);
title(num2str(i));
drawnow;
disp(num2str(i))
clf
end

