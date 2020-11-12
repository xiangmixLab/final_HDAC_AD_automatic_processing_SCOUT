function obj=objSelectManual(orilocation,behavprefix,ROI)

    cd(orilocation)
    V=VideoReader([behavprefix,'2.avi']);

    frame=readFrame(V);

    UsrInput='N';

    frame=imadjust(rgb2gray(frame));
    imshow(frame);

    obj=[];
    userInput = 'N';
    while (strcmp(userInput,'N'))
        clf
        display('Select Object, press Enter to finish');                      
        imshow(frame,'InitialMagnification','fit');
        hold on;
        x=ginput(4);

        for p=1:size(x,1)
            co{p}=[x(p,1)-ROI(1),ROI(2)+ROI(4)-x(p,2)];
        end

        for p=1:size(x,1)
            obj(p,:)=co{p};
        end
        
        color_table={'r','g','b','y'};
        
        for p=1:size(x,1)
            plot(obj(p,1)+ROI(1),ROI(2)+ROI(4)-obj(p,2),'.','MarkerSize',30,'color',color_table{p});
        end 
        
        userInput = upper(input('Keep Objects? (Y/N)','s'));      
    end

end

