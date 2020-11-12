function behav = SelectObject(behav,trackLength)
%SelectObject Summary of this function goes here
%   Detailed explanation goes here
    userInput = 'N';
    while (strcmp(userInput,'N'))
        clf
        %framinput = round(behav.numFrames/2)+100;
        display('Select Object');                      
        numobject = input('Please select the number of objects (2 or 4):');
        numobject = round(numobject);
        frame = double(msReadFrame(behav,5,false,false,false))/255;
        imshow(frame,'InitialMagnification','fit');
        if numobject == 2
            x=ginput(2);
            
            
            co1=[x(1,1)-behav.ROI(1),behav.ROI(2)+behav.ROI(4)-x(1,2)];
            co2=[x(2,1)-behav.ROI(1),behav.ROI(2)+behav.ROI(4)-x(2,2)];
%             co1=[x(1,1)-behav.ROI(1),x(1,2)-behav.ROI(2)];
%             co2=[x(2,1)-behav.ROI(1),x(2,2)-behav.ROI(2)];

            behav.object=[co1;co2];
            behav.object=behav.object*trackLength/behav.ROI(3);
        end
        if numobject == 4
            x=ginput(4);

            co1=[x(1,1)-behav.ROI(1),behav.ROI(2)+behav.ROI(4)-x(1,2)];
            co2=[x(2,1)-behav.ROI(1),behav.ROI(2)+behav.ROI(4)-x(2,2)];
            co3=[x(3,1)-behav.ROI(1),behav.ROI(2)+behav.ROI(4)-x(3,2)];
            co4=[x(4,1)-behav.ROI(1),behav.ROI(2)+behav.ROI(4)-x(4,2)];
%             co1=[x(1,1)-behav.ROI(1),x(1,2)-behav.ROI(2)];
%             co2=[x(2,1)-behav.ROI(1),x(2,2)-behav.ROI(2)];
%             co3=[x(3,1)-behav.ROI(1),x(3,2)-behav.ROI(2)];
%             co4=[x(4,1)-behav.ROI(1),x(4,2)-behav.ROI(2)];
% 
                       
            behav.object=[co1;co2;co3;co4];
%             behav.object=behav.object*trackLength/behav.ROI(3); % in new
%             streamline, we comment out this. this will be donw in
%             analysis
        end
        
        
        userInput = upper(input('Keep Objects? (Y/N)','s'));      
    end

end

