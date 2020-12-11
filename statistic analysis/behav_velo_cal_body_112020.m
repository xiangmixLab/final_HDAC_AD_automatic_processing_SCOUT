function [behav,pos_body,velo_body]=behav_velo_cal_body_112020(behavo,behavprefix,body_area_size_range)

    disp('reading behav vid');
    
    behavVidName_struct=dir([behavo.oripath,'\',behavprefix,'*.avi']);
    behavVidName={};
    for i=1:length(behavVidName_struct)
        behavVidName{i}=behavVidName_struct(i).name;
    end
    behavVidName=natsort(behavVidName);
    
    framess={};
    ctt=1;
    tic;
    for i=1:length(behavVidName_struct)
        try
        v=VideoReader([behavo.oripath,'\',behavVidName{i}]);
        while hasFrame(v)
            framess{ctt}=readFrame(v);
            ctt=ctt+1;
        end
        catch
            disp([behavo.oripath,'\',behavVidName{i},' ','bad']);
        end
    end
    toc;
    
    framess=framess(2:end-1);
    %% calculate background
    disp('calculate bg');
    frames_bg_part_r=[];
    frames_bg_part_g=[];
    frames_bg_part_b=[];
    ctt=1;
    for i=1:50:length(framess)
        frames_bg_part_r(:,:,ctt)=imadjust(framess{i}(:,:,1));
        frames_bg_part_g(:,:,ctt)=imadjust(framess{i}(:,:,2));
        ctt=ctt+1;
    end
    bgr=mean(frames_bg_part_r,3);
    bgg=mean(frames_bg_part_g,3);

    %% ROI
    ROI=round(behavo.ROI*behavo.ROI3/behavo.trackLength);
    ROI=[ROI(1)+10,ROI(2)+10,ROI(3)-10,ROI(4)-10]; % as we are considering body area, shrink the ROI does no major harm
    ROI_region=double(framess{1}(:,:,1)*0);
    ROI_region(ROI(2):ROI(2)+ROI(4)-1,ROI(1):ROI(1)+ROI(3)-1)=1;

    %% find bg for each frame
    disp('find mouse body area: step 1 -- find mouse binarize figure');
    bg_list={};
    frames_bw_bin={};
%     noise_thres=-8; % mouse is black, which make the local intensity drop
    tic;
    parfor i=1:length(framess)
        bgtr=double(imadjust(framess{i}(:,:,1)))-double(bgr);
        bgtg=double(imadjust(framess{i}(:,:,2)))-double(bgg);
        bgtr=bgtr.*(ROI_region);
        bgtg=bgtg.*(ROI_region);
        noise_thres=max([min(bgtg(:)),min(bgtr(:))])/2;
        bgt_m=(bgtr<noise_thres).*(bgtg<noise_thres);
        frt=imadjust(framess{i}(:,:,2));
        frt(bgt_m==1)=0;
        bg_list{i}=frt;
        frames_bw_bin{i}=bgt_m;
    end
    toc;

    %% binarize mouse body
    disp('find mouse body area: step 2 -- further binarize');
    se=strel('disk',5'); % remove the body split caused by cable
%     body_area_size_range=[100 700]; % 448+/-300
    tic;
    parfor i=1:length(frames_bw_bin)        
        frt=frames_bw_bin{i};
        frt=frt.*logical(ROI_region);
%         frt=imclose(frt,se);
        frt_small=bwareaopen(frt,body_area_size_range(1));
        frt_large=~bwareaopen(frt,body_area_size_range(2));
        frt_combine=logical(frt_small.*frt_large);
        frt_combine=imfill(frt_combine,'holes');
        frt_combine=imopen(frt_combine,se)
        frt_small=bwareaopen(frt,body_area_size_range(1));
        frt_large=~bwareaopen(frt,body_area_size_range(2));
        frt_combine=imclose(frt_combine,se)
        frames_bw_bin{i}=frt_combine; 
    end
    toc;
    %% body pos
    disp('calculate mouse body position');
    pos_body=[];
    se=strel('disk',4);
    parfor i=1:length(frames_bw_bin)
        ft=frames_bw_bin{i};
        ft=imopen(ft,se); % for cables
        statss=regionprops(ft,'Area','Eccentricity','Centroid');
        all_area=[statss.Area];
        if ~isempty(all_area)
            select_idx=find(all_area==max(all_area));
            pos_body(i,:)=statss(select_idx).Centroid;
        else
            pos_body(i,:)=[nan,nan];
        end
    end

    %% position post processing
    % position jump deletion
    distt=[];
    for i=2:size(pos_body,1)
        distt(i-1)=norm(pos_body(i,:)-pos_body(i-1,:));
    end
    dis_uplimit=[nanmean(distt)+3*nanstd(distt(:))];
    pos_body(find(distt>dis_uplimit)+1,:)=repmat([nan nan],length(find(distt>dis_uplimit)),1);
    
    pos_body_nan_idx=logical(isnan(pos_body(:,1))+isnan(pos_body(:,2)));

    pos_body=pos_body(~pos_body_nan_idx,:);

    time = behavo.time(~pos_body_nan_idx);

    pos_body=interp1(time,pos_body,behavo.time,'linear');

    pos_body = smoothdata(pos_body,'SmoothingFactor',0.01);

    pos_body = pos_body*behavo.trackLength/behavo.ROI3;
    
    ddistance=[];
    for i=2:size(pos_body,1)
        ddistance(i-1,1)=norm(pos_body(i-1,:)-pos_body(i,:));
    end    
    
%     behav= msGenerateVideoObj_auto(orilocation_c,behavprefix);
    dtime=diff(behavo.time);    
    velo_body=ddistance./(dtime/1000); % convert to ms
    
    behav=behavo;
    behav.positionbody=pos_body;
    behav.velobody=velo_body;
