function mscam_with_behav_vid(msCamPath,behavPath,behavdat,savname)

ms=general_avi_read(msCamPath);
bv=general_avi_read(behavPath);

load(behavdat);
pos1=[behav.position(:,1)*behav.ROI3/behav.trackLength+behav.ROI(1), behav.position(:,2)*behav.ROI3/behav.trackLength+behav.ROI(2)];

framee={};
for i=1:1000
    subplot(121)
    imshow(ms{i});
    subplot(122)
    imshow(bv{i});
    hold on;
    plot(pos1(1:i,1),pos1(1:i,2),'r-');
    framee_t=getframe(gcf);
    framee{i}=framee_t.cdata;
end

general_avi_making(framee,savname,15)