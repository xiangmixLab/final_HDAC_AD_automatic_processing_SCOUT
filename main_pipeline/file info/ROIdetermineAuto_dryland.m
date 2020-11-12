function [ROI,bg]=ROIdetermineAuto_dryland(orilocation,behavprefix)
    cd(orilocation)
    V=VideoReader([behavprefix,'1.avi']);

    frame=[];
    ctt=1;
    for k=1:100
        frame(:,:,:,ctt)=readFrame(V);
        ctt=ctt+1;
    end
    
    bg=median(frame,4);
    
    bg1=bg(:,:,1);
    bg2=bg(:,:,2);
    bg3=bg(:,:,3);
    
    dryland=(bg1<25).*(bg2<25).*(bg3<25);
    
    dryland=medfilt2(dryland);
    dryland=bwareaopen(dryland,10000);
    
    statss=regionprops(dryland);
    ROI=statss(1).BoundingBox;
    
    if ROI(1)<1
        ROI(1)=2;
    end
    if ROI(2)<1
        ROI(2)=2;
    end   
    
    if ROI(3)+ROI(1)>size(frame,2)
        ROI(3)=size(frame,2)-ROI(1);
    end
    
    if ROI(4)+ROI(2)>size(frame,1)
        ROI(4)=size(frame,1)-ROI(2);
    end
    
 