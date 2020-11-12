function obj=objSelectManual(orilocation,behavprefix,ROI)

    cd(orilocation)
    V=VideoReader([behavprefix,'1.avi']);

    for p=1:900
        frame=readFrame(V);
    end
    UsrInput='N';

    frame=imadjust(rgb2gray(frame));
    imagesc(frame);

    obj=[];
    userInput = 'N';
    while (strcmp(userInput,'N'))
        clf
        display('Select Object, press Enter to finish');          
        frame=imadjust(frame);
        imagesc(frame);
        hold on;
        x=ginput(4);

        for p=1:size(x,1)
            co{p}=[x(p,1),x(p,2)];
        end

        for p=1:size(x,1)
            obj(p,:)=x(p,:); % [i,j] coordination (left top 0)
        end
        
        color_table={'r','g','b','y'};
        
        for p=1:size(x,1)
            plot(co{p}(:,1),co{p}(:,2),'.','MarkerSize',30,'color',color_table{p});
        end 
        
        userInput = upper(input('Keep Objects? (Y/N)','s'));      
    end

end

