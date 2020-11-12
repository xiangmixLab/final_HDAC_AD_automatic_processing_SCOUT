for i=1:length(orilocation)
    cd(orilocation{i});
    
    v=VideoReader('behavCam1_2.avi');
    frame=readFrame(v);
    userInput = 'N';
    while (strcmp(userInput,'N'))
        clf
        imshow(frame,'InitialMagnification','fit');
        hold on
        display('Select ROI');
        rect = getrect(); 

        ROIlist{i} = rect; %uint16([rect(1) rect(1)+rect(3) rect(2) rect(2)+rect(4)]);
        rectangle('Position',rect,'LineWidth',2);
        hold off
        userInput = upper(input('Keep ROI? (Y/N)','s'));
    end
end