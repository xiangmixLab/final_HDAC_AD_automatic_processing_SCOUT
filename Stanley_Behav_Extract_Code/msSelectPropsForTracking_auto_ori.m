
function [behav,frame,frame1_bg] = msSelectPropsForTracking_auto(behav,ROImethod,ListedROI,o1)
%MSSELECTPROPSFORTRACKING Summary of this function goes here
%   Detailed explanation goes here
    userInput = 'N';
    green = cat(3, zeros(behav.height,behav.width), ...
    ones(behav.height,behav.width), ...
    zeros(behav.height,behav.width));

    area_ratio_thres=0.0007;
    frame = double(msReadFrame(behav,round(behav.numFrames/2),false,false,false))/255;
    
    tic
    count=1;
    frame1=zeros(size(frame,1),size(frame,2),3,round(behav.numFrames/(10)));
    for i=1:10:behav.numFrames
        frame1(:,:,:,count)=double(msReadFrame(behav,i,false,false,false))/255;
        count=count+1;
    end
    frame1_bg=median(frame1,4);

%     count=1;
%     frame1=zeros(size(frame,1),size(frame,2),3,20);
%     for i=1:40:floor(behav.numFrames/40)*40
%         ct=1;
%         for j=1:2:40
%             frame1(:,:,:,ct)=double(msReadFrame(behav,(i-1)+j,false,false,false))/255;
%             ct=ct+1;
%         end
%         frame1_bg(:,:,:,count)=median(frame1,4);
%         count=count+1;
%     end
    
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
    %% red and blue LED
    se=strel('disk',3);
    tic;
    for i=1:1:behav.numFrames
        tempf=double(msReadFrame(behav,i,false,false,false))/255;
        if length(size(frame1_bg))>3
            tempf=tempf-squeeze(frame1_bg(:,:,:,min(ceil(i/40),floor(behav.numFrames/40))));
        else
            tempf=tempf-frame1_bg;
        end
        if size(rect,1)==1&&size(rect,2)==4
            frame2=tempf(round(rect(2)):round(rect(2)+rect(4)),round(rect(1)):round(rect(1)+rect(3)),:);           
        end
        if size(rect,1)==size(tempf,1)&&size(rect,2)==size(tempf,2)
            frame2t=tempf.*double(rect);
            frame2=frame2t(round(behav.ROI(2)):round(behav.ROI(2)+behav.ROI(4)),round(behav.ROI(1)):round(behav.ROI(1)+behav.ROI(3)),:);
        end
        
        frame2_r=squeeze(frame2(:,:,1));
        frame2_b=squeeze(frame2(:,:,3));
        frame2_g=squeeze(frame2(:,:,2));
        frame2_hsv=rgb2hsv(frame2);
        frame2_h=squeeze(frame2_hsv(:,:,1));
        frame2_s=squeeze(frame2_hsv(:,:,2));
        frame2_v=squeeze(frame2_hsv(:,:,3));
%         bw1=frame2_r>max(frame2_r(:))*0.9;
%         bw2=frame2_b>max(frame2_b(:))*0.9;
%         bw3=frame2_g>max(frame2_g(:))*0.9;
%         frame2_r(logical(bw3))=0;
%         frame2_b(logical(bw3))=0;

        r_b_diff=abs(sum(sum(frame2_r-frame2_b)));
        
        tic;

        tempf1=zeros(size(tempf,1),size(tempf,2));
        tempf1(round(rect(2)):round(rect(2)+rect(4)),round(rect(1)):round(rect(1)+rect(3)))=frame2_r;
        m1=max(frame2_r(:));
        tempf1_s=imgaussfilt(tempf1,3,'FilterSize',[15 15]);
%         for thres=0.1:0.1:0.9
%             stats=regionprops(tempf1>max(tempf1(:))*thres);
%             Area_all=[stats.Area];
%             if (sum(Area_all)/(size(tempf,1)*size(tempf,2))<area_ratio_thres)
%                 thres_red=thres;
%                 break;
%             end
%             if thres==0.9
%                 thres_red=0.9;
%             end
%         end
        thres_red=0.8;
        bwr=tempf1_s>max(tempf1_s(:))*thres_red;
        bwr=logical(bwareaopen(bwr,10).*(~bwareaopen(bwr,81)));
        
        bwrt=imdilate(bwr,se);
        
        tempf2=zeros(size(tempf,1),size(tempf,2));
        tempf2(round(rect(2)):round(rect(2)+rect(4)),round(rect(1)):round(rect(1)+rect(3)))=frame2_b;
        tempf2_s=imgaussfilt(tempf2,3,'FilterSize',[15 15]);
        m2=max(tempf2(:));
%         for thres=0.1:0.1:0.9
%             t=tempf2>m2*thres;
%             if r_b_diff>10
%                 t(bwrt)=0;
%             end
%             stats=regionprops(t);
%             Area_all=[stats.Area];
%             if isempty(Area_all)
%                 thres_blue=thres;
%                 break;
%             end
%             if sum(Area_all)/(size(tempf,1)*size(tempf,2))<area_ratio_thres
%                 thres_blue=thres;
%                 break;
%             end
%             if thres==0.9
%                 thres_blue=0.9;
%             end
%         end
        thres_blue=0.8;
        bwb=tempf2>max(tempf2_s(:))*thres_blue;
        if r_b_diff>10
            bwb(bwrt)=0;
        else
            bwb=bwr;
        end
        bwb=imclose(bwb,se);
        bwb=logical(bwareaopen(bwb,10).*(~bwareaopen(bwb,81)));
%         bwrt=bwr;
%         bwbt=bwb;
%         bwr(bwbt)=0;
%         bwb(bwrt)=0;

%         bw=imbinarize(tempf1, 0.5);
%         bw=imclose(bw,se);
%         bw=(~bwareaopen(bw,50));
% %         bwr=bw;
%         bwstats=regionprops(logical(bw),'Area','Centroid','BoundingBox','MajorAxisLength','MinorAxisLength');
%         AxisRatio=[bwstats.MajorAxisLength]./[bwstats.MinorAxisLength];
%         bw_lab=intersect(find(AxisRatio>0.5),find(AxisRatio<=1.5));
%         bw1=bwlabel(bw);
%         bw=bw*0;
%         for sk=1:length(bw_lab)
%             bw=bw+bw1==bw_lab(sk);
%         end
%         bw=logical(bw);
%         bwr=bw;
        bw=bwr;
        temp1 = rgb2hsv(tempf);
        temp2 = tempf;
        H = temp1(:,:,1);
        S = temp1(:,:,2);
        V = temp1(:,:,3);
        H = mean(mean(H(bw)));
        S = mean(mean(S(bw)));
        V = mean(mean(V(bw)));
        R = temp2(:,:,1);
        G = temp2(:,:,2);
        B = temp2(:,:,3);
        R = mean(mean(R(bw)));
        G = mean(mean(G(bw)));
        B = mean(mean(B(bw)));
        hsvLevelsr(i,:) = [H+[-.2 .2] S+[-.2 .2] V+[-.2 .2]];
        rgbLevelsr(i,:) = [R+[-.2 .2] G+[-.2 .2] B+[-.2 .2]];
        statss=regionprops(bw,'centroid');
        rcentroid(i,:)=mean(reshape([statss.Centroid],2,size([statss.Centroid],2)/2)',1);

        
        bw=bwb;
        temp1 = rgb2hsv(tempf);
        temp2 = tempf;
        H = temp1(:,:,1);
        S = temp1(:,:,2);
        V = temp1(:,:,3);
        H = mean(mean(H(bw)));
        S = mean(mean(S(bw)));
        V = mean(mean(V(bw)));
        R = temp2(:,:,1);
        G = temp2(:,:,2);
        B = temp2(:,:,3);
        R = mean(mean(R(bw)));
        G = mean(mean(G(bw)));
        B = mean(mean(B(bw)));
        hsvLevelsb(i,:) = [H+[-.2 .2] S+[-.2 .2] V+[-.2 .2]];
        rgbLevelsb(i,:) = [R+[-.2 .2] G+[-.2 .2] B+[-.2 .2]]; 
        statss=regionprops(bw,'centroid');
        bcentroid(i,:)=mean(reshape([statss.Centroid],2,size([statss.Centroid],2)/2)',1);
        
        toc;
        
    end
    
    [y,x]=find(isnan(hsvLevelsr));
    hsvLevelsr(y,:)=repmat([-1 -1 -1 -1 -1 -1],length(y),1);
    behav.hsvLevelred = hsvLevelsr;
    [y,x]=find(isnan(rgbLevelsr));
    rgbLevelsr(y,:)=repmat([-1 -1 -1 -1 -1 -1],length(y),1);
    behav.rgbLevelred = rgbLevelsr;
    [y,x]=find(isnan(rcentroid));
    rcentroid(y,:)=repmat([nan nan],length(y),1);
    behav.rcentroid=rcentroid;
    
    [y,x]=find(isnan(hsvLevelsb));
    hsvLevelsb(y,:)=repmat([-1 -1 -1 -1 -1 -1],length(y),1);
    behav.hsvLevelblue = hsvLevelsb;
    [y,x]=find(isnan(rgbLevelsb));
    rgbLevelsb(y,:)=repmat([-1 -1 -1 -1 -1 -1],length(y),1);
    behav.rgbLevelblue = rgbLevelsb;
    [y,x]=find(isnan(bcentroid));
    bcentroid(y,:)=repmat([nan nan],length(y),1);
    behav.bcentroid=bcentroid;
    

