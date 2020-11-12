%avi making
function making_avi_illustration(Y,sav)
Y=Y*255/max(Y(:));
Y=uint8(Y);
aviobj = VideoWriter(sav,'Uncompressed AVI');
aviobj.FrameRate=10;

open(aviobj);
for it=1:size(Y,3)
    frame=Y(:,:,it);
    writeVideo(aviobj,frame);
end
close(aviobj);