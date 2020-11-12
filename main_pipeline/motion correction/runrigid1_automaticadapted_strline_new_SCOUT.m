% demo file for applying the NoRMCorre motion correction algorithm on +
% 1-photon widefield imaging data
% Example files can be obtained through the miniscope project page
% www.miniscope.org

function fname_cell=runrigid1_automaticadapted_strline_new_SCOUT(templatename,videoname,mrange,gsig_gsiz_combb)
% clear;
gcp;
%% read data and convert to double
fname_cell={};
for i10=mrange
    
    if ~isempty(templatename{i10})
    foldername=templatename{i10}(1:strfind(templatename{i10},'MAX')-1);
    mousename=templatename{i10}(strfind(templatename{i10},'MAX')+4:strfind(templatename{i10},'.')-1);
    postfix=videoname{i10}(max(strfind(videoname{i10},'.'))+1:end);
    cd(foldername);

    % [filename, filepath] = uigetfile('*.tif','Select Template');
    % templatename1= templatename{i10};
    % template_test1=imread(templatename1);
    % % template_test=greedy_contrast_enhancement_java(template_test1,2);
    % template_test=template_test1;
    % [filename, filepath] = uigetfile('*.tif','Select Video');
    name = videoname{i10};
    %addpath(genpath('../../NoRMCorre'));
    Yf1=[];
    if isequal(postfix,'tif')
        info = imfinfo(name);
        numberOfImages = length(info);
        for k = 1:numberOfImages
            currentImage = imread(name, k);
            Yf1(:,:,k) = currentImage;
        end 
    end
    if isequal(postfix,'mat')
    Yf1 = importdata(name);
    % Yf1=Yft.concatenatedvideo_res;
    clear Yft;
    end
%     Yf=Yf1*0;

    %special for 3323 4th batch
    % tic
    % for i1=1:size(Yf1,1)
    %     for i2=1:size(Yf1,2)
    % %         Yfk=(detrend(squeeze(double(Yf1(i1,i2,:)))));
    %         Yfk=smooth(squeeze(double(Yf1(i1,i2,:))),'sgolay');
    %         [B,A]= butter(10,10/(30/2));
    %         Yfk=filter(B,A,Yfk);
    %         Yf(i1,i2,:)=uint8(Yfk);
    % %         Yf(i1,i2,:)=Yfk.*Yfk;
    %     end
    % end
    % for i1=1:size(Yf1,3)
    %     Yf(:,:,i1)=medfilt2(squeeze(Yf(:,:,i1)));
    % end
    % 
    % template_test=mean(Yf,3);
    % template_test=template_test*255/max(template_test(:));
    % template_test=uint8(template_test);
    % 

    %contrast enhancement
    % for i1=1:size(Yf1,3)
    %     Yf(:,:,i1)=greedy_contrast_enhancement_java(squeeze(Yf1(:,:,i1)),2);
    % end
    Yf=Yf1;% sometimes the first frame have problems
    % Yf=Yf1;
    % Yf1=Yf;Yf
    Yf = single(Yf);
    [d1,d2,T] = size(Yf);
    % [savename,savepath]=uiputfile('*.avi','Save video as');
    % mkdir([mousename,'_update_template']);
    % savepath=[pwd];
    % savepath=savepath(1:findstr(savepath,'individual_condition_videos')-1);
    % savename=['NormCorre_result_',mousename];

    flag=0;
    maxshift=cell(30,16);
    count=1;

    after_process_correlation=zeros(1,4);

    gsig_gsiz_comb=gsig_gsiz_combb;
    for i=1:length(gsig_gsiz_comb)
    % perform some sort of deblurring/high pass filtering
    if (0)    
        hLarge = fspecial('average', 40);
        hSmall = fspecial('average', 2); 
        for t = 1:T
            Y(:,:,t) = filter2(hSmall,Yf(:,:,t)) - filter2(hLarge, Yf(:,:,t));
        end
        %Ypc = Yf - Y;
        bound = size(hLarge,1);
    else
        choice=gsig_gsiz_comb{i};
        gSig = choice(1); %%original 7
        gSiz = choice(2); %%original 17
        psf = fspecial('gaussian', round(gSiz), gSig);
        ind_nonzero = (psf(:)>=max(psf(:,1)));
        psf = psf-mean(psf(ind_nonzero));
        psf(~ind_nonzero) = 0;   % only use pixels within the center disk
        %Y = imfilter(Yf,psf,'same');
        %bound = 2*ceil(gSiz/2);
        Y = imfilter(Yf,psf,'symmetric');
        Y(Y<0)=0;
        bound = 0;
    end

    % se = strel('disk', 8);
    % template_test_1=imbinarize(template_test,'global');
    % template_test_1=imopen(template_test_1,se);
    % template_test_1=uint8(bwareaopen(template_test_1,1000))*255;
    % stats = regionprops(template_test_1);
    % centroid = stats(255).Centroid;
    % template_test_1=template_test_1*0;
    % template_test_1(round(centroid(2)),round(centroid(1)))=255;
    % 
    % 
    % Y=Yf1*0;
    % for i=1:size(Yf,3)
    %     Yt=imbinarize(Yf1(:,:,i),'global');
    %     Yt=imopen(Yt,se);
    %     Yt=uint8(bwareaopen(Yt,1000))*255;
    %     stats = regionprops(Yt);
    %     centroid = stats(255).Centroid;
    %     Yt=Yt*0;
    %     Yt(round(centroid(2)),round(centroid(1)))=255;
    %     Y(:,:,i)=Yt;
    % end
    % Y=single(Y);
    % bound=0;
    %% first try out rigid motion correction
        % exclude boundaries due to high pass filtering effects
    options_r = NoRMCorreSetParms('d1',d1-bound,'d2',d2-bound,'bin_width',5,'max_shift',50,'iter',1,'correct_bidir',false);
    options_r.upd_template=true;

    %% correct ADC noice (horizontal patterns) added 03082019 based on Yanjun and Dr. Aharoni's suggestion
    Yf1=double(Yf1);
    meanFrame = zeros(size(Yf1,1),size(Yf1,2)); 
    %allocate memory
    count = 0;
    downSamp=2;
    for frameNum=1:downSamp:size(Yf1,3)
    count = count + 1;
    meanFrame = meanFrame + double(Yf1(:,:,frameNum));
    if (mod(frameNum,1+100*downSamp)==0)
    display(['Calculating column correction.' num2str(frameNum/size(Yf1,3)*100) '% done']);
    end
    end
    % creates correction frame used to remove ADC noise
    columnCorrection = round(repmat(mean(meanFrame/count,1),size(Yf1,1),1));
    columnCorrectionOffset = mean(columnCorrection(:));
    % correct frames
    for frameNum=1:size(Yf1,3)
        Yf1(:,:,frameNum)=double(Yf1(:,:,frameNum))-columnCorrection+columnCorrectionOffset;  
    end
    Yf1=single(Yf1);
    %% register using the high pass filtered data and apply shifts to original data
    [M1,shifts1,template1] = normcorre_batch(Y(bound/2+1:end-bound/2,bound/2+1:end-bound/2,:),options_r,[]); % register filtered data
    % exclude boundaries due to high pass filtering effects
     Mr = apply_shifts(Yf1,shifts1,options_r,bound/2,bound/2); % apply shifts to full dataset
    % apply shifts on the whole movie
%     [cM1f,mM1f,vM1f,dtm] = motion_metrics_adapted(Mr,options_r.max_shift);
    cM1f=[0];
    dtm=[0];
    % evaluation metric

    after_process_correlation(i)=mean(cM1f);
    % figure;
    % set(gcf,'outerposition',get(0,'screensize'));
    % ButtonHandle = uicontrol('Style', 'PushButton', ...
    %                          'String', 'Stop loop', ...
    %                          'Callback', 'delete(gcbf)');
    % for ik=1:1:size(Yf,3)
    % subplot(1,2,1);
    % imshow(uint8(Yf(:,:,ik)));
    % drawnow;
    % title(['original ', 'gSig=',num2str(gSig),' gSiz=',num2str(gSiz)]);
    % subplot(1,2,2)
    % drawnow;
    % imshow(uint8(Mr(:,:,ik)));
    % title('corrected');
    % xlabel(num2str(ik));
    % if ~ishandle(ButtonHandle)
    %     break;
    % end
    % end
    % close all;
    % satif=input('satified? y/n:','s');
    % if satif=='y'
    %     break
    % end
    % Mr1=uint8(Mr);
    % % se = strel('disk', 4);
    % centroid=zeros(size(Mr1,3),2);
    % for ip=1:size(Yf,3)
    %     Mr_1=imbinarize(Mr1(:,:,ip),'global');
    % %     Mr_1=imopen(Mr_1,se);
    %     Mr_1=uint8(bwareaopen(Mr_1,100))*255;
    %     stats = regionprops(Mr_1);
    %     centroid(ip,:) = stats(255).Centroid;
    % end
    % 
    % maxx=max(abs(centroid(:,1)-mean(centroid(:,1))));
    % maxy=max(abs(centroid(:,2)-mean(centroid(:,2))));
    % maxshift{i,count}=[maxx,maxy];
    % count=count+1;
    % maxx
    % maxy
    % maxshift{i,j-2}=[maxx,maxy];
    % if maxx<=3&&maxy<=3
    %% save video as .avi file
    n = size(Yf);
    framenumber = n(3);
    sname=gSiz*100000+gSig*1000+i10;
    % [savename,savepath]=uiputfile('*.avi','Save video as');
    savepath=foldername;
    sav=[savepath,num2str(sname),'.avi'];
    aviobj = VideoWriter(sav,'Motion JPEG AVI');
    aviobj.FrameRate=20;

    open(aviobj);
    for it=1:T
        frame=uint8(Mr(:,:,it));
        writeVideo(aviobj,frame);
    end
    close(aviobj);
    flag=1;
    % save([savepath,'corr_',num2str(mean(cM1f)),'_','gsig',num2str(gSig),'_gsiz',num2str(gSiz),'_',savename,'.mat'],'Mr');
    Y=Mr;
    Ysize=size(Y);
    Ysiz=size(Y);
    save([savepath,num2str(sname),'.mat'],'Y','Ysiz','-v7.3');
    fname_cell{i10}=[savepath,num2str(sname),'.mat'];
    save([savepath,num2str(sname),'metric.mat'],'cM1f','dtm','Ysize');
    disp(['finish ',savepath,num2str(sname),'.mat']);
    % break;
    % end
    end
    % if flag==1
    %     break;
    % end
    count=1;
    end
end
