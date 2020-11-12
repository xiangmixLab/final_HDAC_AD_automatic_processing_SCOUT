function ROI=ROIdetermineManual_older_ver(orilocation,behavprefix)
    cd(orilocation)
    try
        V=VideoReader([behavprefix,'2.avi']);
    catch
        V=VideoReader([behavprefix,'1.avi']);
    end
    
    frame=readFrame(V);

    UsrInput='N';

    frame=imadjust(rgb2gray(frame));
    imagesc(frame);

    while isequal(UsrInput,'N')

        hold on;
        title('select ROI');
        rect = getrect();
        ROI=rect;
        UsrInput=input('Satisfiiiiied? Y/N [Y]:','s');
        if isequal(UsrInput,'Y')
            clf
            break;
        else
            clf
            UsrInput='N';
            imagesc(frame);
        end
    end
    
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