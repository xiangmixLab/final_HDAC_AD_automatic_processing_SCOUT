function behav = msSelectPropsForTracking(behav)
%MSSELECTPROPSFORTRACKING Summary of this function goes here
%   Detailed explanation goes here
    userInput = 'N';
    green = cat(3, zeros(behav.height,behav.width), ...
    ones(behav.height,behav.width), ...
    zeros(behav.height,behav.width));

    while (strcmp(userInput,'N'))
        clf
        %framinput = round(behav.numFrames/2)+100;
        display('Select Frame');
        framinput = '1';
        totframnum = num2str(behav.numFrames);
        framinput = input(['Please select the frame number (0~', totframnum,'):']);
        framinput = round(framinput);
        frame = double(msReadFrame(behav,framinput,false,false,false))/255;
        imshow(frame,'InitialMagnification','fit');
        userInput = upper(input('Keep Frame Number? (Y/N)','s'));      
    end
    
%     figure(1);

    userInput = 'N';
    while (strcmp(userInput,'N'))
        clf
        imshow(frame,'InitialMagnification','fit');
        hold on
        display('Select ROI');
        rect = getrect(); 

        behav.ROI = rect; %uint16([rect(1) rect(1)+rect(3) rect(2) rect(2)+rect(4)]);
        rectangle('Position',rect,'LineWidth',2);
        hold off
        userInput = upper(input('Keep ROI? (Y/N)','s'));
    end
    
     userInput = 'N';
     while (strcmp(userInput,'N'))
        clf
        imshow(frame,'InitialMagnification','fit');
        hold on
        rectangle('Position',rect,'LineWidth',2);
        
        display('Select Red LED');
        hEllipse = imellipse;
        wait(hEllipse);
%         [w, h] = ginput(1);
%         w = uint16(round(w));
%         h = uint16(round(h));
        ROIMask = createMask(hEllipse);
        temp = rgb2hsv(frame);
        H = temp(:,:,1);
        S = temp(:,:,2);
        V = temp(:,:,3);
        H = mean(mean(H(ROIMask)));
        S = mean(mean(S(ROIMask)));
        V = mean(mean(V(ROIMask)));
        hsvLevels = [H+[-.2 .2] S+[-.2 .2] V+[-.2 .2]];
        bw = hsvThreshold(frame,hsvLevels);
%         outline = bwperim(bw);

        hold off
        imshow(frame,'InitialMagnification','fit');
        hold on
        hOutline = imshow(green);
        set(hOutline,'alphadata',bw==1);
        
        hold off
        behav.hsvLevelred = hsvLevels;
        userInput = upper(input('Keep LED? (Y/N)','s'));
     end
     
    userInput = 'N';
     while (strcmp(userInput,'N'))
        clf
        imshow(frame,'InitialMagnification','fit');
        hold on
        rectangle('Position',rect,'LineWidth',2);
        
        display('Select Blue LED');
        hEllipse = imellipse;
        wait(hEllipse);
%         [w, h] = ginput(1);
%         w = uint16(round(w));
%         h = uint16(round(h));
        ROIMask = createMask(hEllipse);
        temp = rgb2hsv(frame);
        H = temp(:,:,1);
        S = temp(:,:,2);
        V = temp(:,:,3);
        H = mean(mean(H(ROIMask)));
        S = mean(mean(S(ROIMask)));
        V = mean(mean(V(ROIMask)));
        hsvLevels = [H+[-.2 .2] S+[-.2 .2] V+[-.2 .2]];
        bw = hsvThreshold(frame,hsvLevels);
%         outline = bwperim(bw);

        hold off
        imshow(frame,'InitialMagnification','fit');
        hold on
        hOutline = imshow(green);
        set(hOutline,'alphadata',bw==1);
        
        hold off
        behav.hsvLevelblue = hsvLevels;
        userInput = upper(input('Keep LED? (Y/N)','s'));
    end
end

