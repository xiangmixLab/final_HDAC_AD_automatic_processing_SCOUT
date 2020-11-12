%filename should be a .mat
function cross_condition_concatenated_stack_manual_correction(filename,range,shift)

load(filename);
[path,name,ext]=fileparts(filename);
for i=range(1):range(2)
    t=squeeze(Y(:,:,i));
    t1 = imtranslate(t,shift);
    Y(:,:,i)=t1;
end
save(filename,'Y','Ysiz','-v7.3');

disp('save fin,now save vid');
vid_name=name;
vid_name=[vid_name,'avi']

aviobj = VideoWriter(vid_name,'uncompressed AVI');
aviobj.FrameRate=15;
open(aviobj);
for i=1:size(Y,3)
    imshow(uint8(squeeze(Y(:,:,i))))
    frame=getframe(gcf);
    writeVideo(aviobj,frame);
end
close(aviobj)   
