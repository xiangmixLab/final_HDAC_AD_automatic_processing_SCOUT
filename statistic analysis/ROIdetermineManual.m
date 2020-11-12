function ROI=ROIdetermineManual(orilocation,behavprefix)
    cd(orilocation)
    V=VideoReader([behavprefix,'2.avi']);

    frame=readFrame(V);

    UsrInput='N';

    frame=imadjust(rgb2gray(frame));
    imshow(frame);

    while isequal(UsrInput,'N')

        hold on;
        title('select ROI');
        h=drawrectangle;
        ROI=h.Position;
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