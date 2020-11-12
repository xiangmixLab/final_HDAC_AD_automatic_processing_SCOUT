
function [behav,frame1_bg,bw_all] = msExtractBehavior_adapted_auto_dry_land(behav,ROImethod,ListedROI,o1,trackLength)
%MSSELECTPROPSFORTRACKING Summary of this function goes here
%   Detailed explanation goes here
    userInput = 'N';
    green = cat(3, zeros(behav.height,behav.width), ...
    ones(behav.height,behav.width), ...
    zeros(behav.height,behav.width));


    frame = double(msReadFrame(behav,round(behav.numFrames/2),false,false,false))/255;
    
    tic
    count=1;
    frame1=zeros(size(frame,1),size(frame,2),round(behav.numFrames/10));
    bwr=zeros(size(frame,1),size(frame,2));
    for i=1:10:behav.numFrames
        tframe=rgb2gray(uint8(msReadFrame(behav,i,false,false,false)));
        frame1(:,:,count)=tframe;
        bwr=bwr+double(imbinarize(frame1(:,:,count),0.5));
        count=count+1;
    end
    bwr=logical(bwr);
    frame1_bg=uint8(median(frame1,3));
    toc;
    clear frame1;
    %% ROI generation
    if isequal(ROImethod,'autoROI')
        frame1_bg_g=rgb2gray(frame1_bg);
        Edge_frame1_bg_g_1 = edge(frame1_bg_g,'canny');
        se1 = strel('disk',10);
        Edge_frame1_bg_g_1=imclose(Edge_frame1_bg_g_1,se1);
        frame1_bg_g=adapthisteq(frame1_bg_g);
        se = strel('disk',40);
        Ie = imerode(frame1_bg_g,se);
        frame1_bg_g_1 = imreconstruct(Ie,frame1_bg_g);
        frame1_bg_resize=reshape(frame1_bg_g_1,size(frame1_bg,1)*size(frame1_bg,2),1);
        kindex=kmeans(frame1_bg_resize,3);
        kindex_resize=reshape(kindex,size(frame1_bg,1),size(frame1_bg,2));
    %     if isequal(cuthalf,'half')
    %         statbwr=regionprops(bwr);
    %         centroid=statbwr.Centroid;
    %         if centroid(1)<=0.5*size(frame,2)
    %             kindex_resize=kindex_resize(:,1:round(0.5*size(frame,2)));
    %         else
    %             kindex_resize=kindex_resize(:,round(0.5*size(frame,2)):end);
    %         end
    %     end
        stats=regionprops(kindex_resize,'Area'); 
        area_all=[stats.Area];
        kindex_resize(kindex_resize~=find(area_all==max(area_all)))=0;
        kindex_resize(Edge_frame1_bg_g_1==1)=0;
        BWao = bwareaopen(kindex_resize,6000);
        se2 = strel('disk',20);
        BWao1 = imclose(BWao,se2);
        stats1=regionprops(BWao1,'Area', 'BoundingBox'); 
        rect=stats1.BoundingBox;
        behav.ROI = rect;
    else if isequal(ROImethod,'manualROI')        
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
    else if isequal(ROImethod,'ROIlist')&&~isempty(ListedROI)
                 %uint16([rect(1) rect(1)+rect(3) rect(2) rect(2)+rect(4)]);
                rect=ListedROI{o1};
                if size(rect,1)==1&&size(rect,2)==4
                    behav.ROI = ListedROI{o1};
                end
                if size(rect,1)==size(frame1_bg,1)&&size(rect,2)==size(frame1_bg,2)
                    statss=regionprops(rect,'BoundingBox');
                    behav.ROI=statss.BoundingBox;
                end
        end
        end           
    end
    %% ear and tail
    positionEar=zeros(behav.numFrames,2);
    positionTail=zeros(behav.numFrames,2);
    bw_all=zeros(size(frame1_bg,1),size(frame1_bg,2),behav.numFrames);
    se=strel('disk',1);
    se1=strel('disk',2);
    
    bwstats_all={};
    for i=1:1:behav.numFrames
        tempf=rgb2gray(uint8(msReadFrame(behav,i,false,false,false)));
        tempf=tempf-frame1_bg;
        
        tic;

        tempf2=zeros(size(tempf,1),size(tempf,2));
        if size(rect,1)==1&&size(rect,2)==4
            frame2=tempf(round(rect(2)):round(rect(2)+rect(4)),round(rect(1)):round(rect(1)+rect(3)),:);
            frame2_gr=squeeze((frame2));
            tempf2(round(rect(2)):round(rect(2)+rect(4)),round(rect(1)):round(rect(1)+rect(3)))=frame2_gr;
        end
        if size(rect,1)==size(tempf,1)&&size(rect,2)==size(tempf,2)
            frame2_gr=tempf.*uint8(rect);
            tempf2=frame2_gr;
        end

%         tempf2=imadjust(tempf2,[0.01 0.016]);
        tempf2=imadjust(tempf2,[0.01 0.016]);

        bw=imopen(tempf2,se);
%         bw=imclose(bw,se1);
        bw1=~bwareaopen(bw,500);
        bw2=bwareaopen(bw,50);
        bw=bw1.*bw2;
        
        bwl=bwlabel(bw);
        bwstats=regionprops(logical(bw),'Area','Centroid','BoundingBox','MajorAxisLength','MinorAxisLength');
        AxisRatio=[bwstats.MajorAxisLength]./[bwstats.MinorAxisLength];
        ear_lab=intersect(find(AxisRatio>1),find(AxisRatio<=3));
        tail_lab=find(AxisRatio>3);
%         ear_area=zeros(size(bw));
%         tail_area=zeros(size(bw));
%         for l1=1:length(ear_lab)
%             ear_area=ear_area+bwl==ear_lab(l1);
%         end
%         for l1=1:length(tail_lab)
%             tail_area=tail_area+bwl==tail_lab(l1);
%         end        
%         ear_area=ear_area>0;
%         tail_area=tail_area>0;
%         if sum(ear_area(:))>0
%             stats_ear=regionprops(ear_area,'Centroid');
%             positionEar(i,:)=mean(reshape([stats_ear.Centroid],2,length([stats_ear.Centroid])/2)',1);
%         else
%             positionEar(i,:)=[nan nan];
%         end
%         if sum(tail_area(:))>0
%             stats_tail=regionprops(tail_area,'Centroid');
%             positionTail(i,:)=mean(reshape([stats_tail.Centroid],2,length([stats_tail.Centroid])/2)',1);
%         else
%             positionTail(i,:)=[nan nan];
%         end
        CentroidList=reshape([bwstats.Centroid],2,length([bwstats.Centroid])/2)';
        positionEar(i,:)=mean(CentroidList(ear_lab,:),1);
        positionTail(i,:)=mean(CentroidList(tail_lab,:),1);
        bw_all(:,:,i)=bw;
        bwstats_all{i}=bwstats;
    end
    

    %% position ear
%     positionEar = positionEar*trackLength/behav.ROI(3);
    positionEar(1,:)=[nan nan];% first frame might be the recording from last run
    positionEar(end,:)=[nan nan];% last frame might also be weird
    time = behav.time(~isnan(positionEar(:,1)));
    positionEar = positionEar(~isnan(positionEar(:,1)),:); 
   
    positionEar = interp1(time,positionEar,behav.time,'pchip');
%     while ~isempty(find(isnan(positionEar(:,1))))
%         for tk=find(isnan(positionEar(:,1)))'
%             if tk-1>1
%                 if ~isnan(positionEar(tk-1,1))
%                     positionEar(tk,1)=positionEar(tk-1,1);
%                     positionEar(tk,2)=positionEar(tk-1,2);
%                 end
%             end
%             if tk+1<size(positionEar,1)
%                 if ~isnan(positionEar(tk+1,1))
%                     positionEar(tk,1)=positionEar(tk+1,1);
%                     positionEar(tk,2)=positionEar(tk+1,2);
%                 end
%             end  
%         end
%     end
%     position(:,2)=263-position(:,2);
    dt = median(diff(behav.time/1000)); 
%     positionEar = smoothts(positionEar','b',ceil(1/dt))';
    positionEar = smoothts(positionEar','b',ceil(1/dt))';
%     f=fit(positionEar(:,1),positionEar(:,2),'cubicinterp');
    behav.positionEar = positionEar;
    
    dx = [0; diff(positionEar(:,1))];
    dy = [0; diff(positionEar(:,2))];
    
    dl = sqrt((dx).^2+(dy).^2);
    behav.distanceEar = sum(dl);
    behav.speedEar = sqrt((dx).^2+(dy).^2)/dt;
    behav.speedEar = smoothts(behav.speedEar','b',ceil(1/dt));
    behav.dt = dt;
    behav.trackLength = trackLength;
    
    %% position tail
%     positionTail = positionTail *trackLength/behav.ROI(3);
    positionTail(1,:)=[nan nan];
    positionTail(end,:)=[nan nan];% last frame might also be weird

    time = behav.time(~isnan(positionTail (:,1)));
    positionTail  = positionTail (~isnan(positionTail (:,1)),:);  

    positionTail  = interp1(time,positionTail ,behav.time,'pchip');
%     positionblue(:,2)=263-positionblue(:,2);
%    while ~isempty(find(isnan(positionTail(:,1))))
%         for tk=find(isnan(positionTail(:,1)))'
%             if tk-1>1
%                 if ~isnan(positionTail(tk-1,1))
%                     positionTail(tk,1)=positionTail(tk-1,1);
%                     positionTail(tk,2)=positionTail(tk-1,2);
%                 end
%             end
%             if tk+1<size(positionTail,1)
%                 if ~isnan(positionTail(tk+1,1))
%                     positionTail(tk,1)=positionTail(tk+1,1);
%                     positionTail(tk,2)=positionTail(tk+1,2);
%                 end
%             end  
%         end
%     end
    dt = median(diff(behav.time/1000)); 
    positionTail  = smoothts(positionTail','b',ceil(1/dt))';
%     positionTail(:,1) = smooth(positionTail(:,1),'sgolay')';
%     positionTail(:,2) = smooth(positionTail(:,2),'sgolay')';
    behav.positionTail  = positionTail ;
    
    dx = [0; diff(positionTail (:,1))];
    dy = [0; diff(positionTail (:,2))];
    
    dl = sqrt((dx).^2+(dy).^2);
    behav.distanceTail  = sum(dl);
    behav.speedTail  = sqrt((dx).^2+(dy).^2)/dt;
    behav.speedTail  = smoothts(behav.speedTail','b',ceil(1/dt));
    behav.dt = dt;
    behav.trackLength = trackLength;    

