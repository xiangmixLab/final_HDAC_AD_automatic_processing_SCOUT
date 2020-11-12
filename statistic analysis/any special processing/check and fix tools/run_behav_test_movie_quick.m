function run_behav_test_movie_quick(neuron,behav,moviedir,behavfileindex,headorientationcell,savedir)
% currently only support using 1 behav video to make movie

%neuron:neuron data (after CNMF_E)
%behav:behav data (after suoqin's behav extraction code)
%conditionfolder: the folder you want to save the video
%moviedir: address of the behav videos
%startframe: along all the frames, which frame you choose to start (the whole experiment, for example, an experiment with 3 conditions and each condition have 1000 frames, the experiment thus have 3000 frames, choose the start frame among the 3000 frames)
%behavfileindex: in current condition the index of behav file you want use
%idxcell: the index of cells want to display (max 4)
%lab: "trace","S" or "C", depend which one in use
close all;
aviobj = VideoWriter([savedir,'\angle_illustration.avi'],'Uncompressed AVI');
        aviobj.FrameRate=10;
        open(aviobj);
position=behav.positionblue;
if_mouse_head_toward_object=headorientationcell.if_mouse_head_toward_object;
mouseheading=headorientationcell.mouseheading;
mouse_object_direction=headorientationcell.mouse_object_dirction;

behavfilesid={dir([moviedir,'behav*.avi'])};
behavnumFiles = length(behavfileindex); % the number of videos that are needed to be combined. If you comment this line,then it will making a video including all the behavam.avi files;
% otherwise, you just want to make a video including the first few bahavCam.avi files

% neuron movie denoised threshold
% ac_quantile = .99999;
% ACmax = quantile(YSignal(1:1000:numel(YSignal)), ac_quantile);
Coor=neuron.Coor;
        ax1=figure;
for i = 1:behavnumFiles
    if ~isempty(moviedir)
    tic;
    v = VideoReader([moviedir,'behavCam1_',num2str(behavfileindex(i)),'.avi']);
    %     numFrames = get(v,'NumberOfFrames');
    k=0;

    while hasFrame(v)
        k = k+1;

        vidFrame(:,:,:,k) = readFrame(v);
    end

%% behav video with trajectory
    for k=1:size(vidFrame,4)
%         set(ax1,'Visible','off')
        behavframer=vidFrame(:,:,:,k);
        imshow(behavframer);
        set(gca,'Ydir','Normal')
        hold on
        plot(position((min(behavfileindex)-1)*1000+1:k+(behavfileindex(i)-1)*1000,1)+behav.ROI(1)-10,position((min(behavfileindex)-1)*1000+1:k+(behavfileindex(i)-1)*1000,2)+behav.ROI(2)-10,'r-','LineWidth',1);
        title('behavior video');
        pause(1/v.FrameRate);

%% plot 60 degree position
        if if_mouse_head_toward_object(k+(behavfileindex(i)-1)*1000,1)==1
%             plot(position(k+(behavfileindex(i)-1)*1000,1)+behav.ROI(1)-10,position(k+(behavfileindex(i)-1)*1000,2)+behav.ROI(2)-10,'r.','MarkerSize',35);
            plot(behav.object(1,1)+behav.ROI(1)-10,(behav.ROI(4)-behav.object(1,2))+behav.ROI(2)+10,'r.','MarkerSize',35);
            quiver(position(k+(behavfileindex(i)-1)*1000,1)+behav.ROI(1)-10,position(k+(behavfileindex(i)-1)*1000,2)+behav.ROI(2)-10,mouseheading(k+(behavfileindex(i)-1)*1000,1)*3,mouseheading(k+(behavfileindex(i)-1)*1000,2)*10,'MaxHeadSize',1000);
            quiver(position(k+(behavfileindex(i)-1)*1000,1)+behav.ROI(1)-10,position(k+(behavfileindex(i)-1)*1000,2)+behav.ROI(2)-10,mouse_object_direction{1}(k+(behavfileindex(i)-1)*1000,1)*3,mouse_object_direction{1}(k+(behavfileindex(i)-1)*1000,2)*3,'MaxHeadSize',1000);
        
        end
        if if_mouse_head_toward_object(k+(behavfileindex(i)-1)*1000,2)==1
%             plot(position(k+(behavfileindex(i)-1)*1000,1)+behav.ROI(1)-10,position(k+(behavfileindex(i)-1)*1000,2)+behav.ROI(2)-10,'b.','MarkerSize',35);
            plot(behav.object(2,1)+behav.ROI(1)-10,(behav.ROI(4)-behav.object(2,2))+behav.ROI(2)+10,'b.','MarkerSize',35);
            quiver(position(k+(behavfileindex(i)-1)*1000,1)+behav.ROI(1)-10,position(k+(behavfileindex(i)-1)*1000,2)+behav.ROI(2)-10,mouseheading(k+(behavfileindex(i)-1)*1000,1)*10,mouseheading(k+(behavfileindex(i)-1)*1000,2)*10,'MaxHeadSize',1000);
            quiver(position(k+(behavfileindex(i)-1)*1000,1)+behav.ROI(1)-10,position(k+(behavfileindex(i)-1)*1000,2)+behav.ROI(2)-10,mouse_object_direction{2}(k+(behavfileindex(i)-1)*1000,1)*3,mouse_object_direction{2}(k+(behavfileindex(i)-1)*1000,2)*3,'MaxHeadSize',1000);       
        end
drawnow;

    %% still ... togo
    disp(num2str(num2str(behavfileindex(i))));
    disp(num2str(k+(behavfileindex(i)-1)*1000));
    disp(['still need',num2str(behavnumFiles*1000-(k+(i-1)*1000)),' to go']);



            frame=getframe(gcf);
            writeVideo(aviobj,frame);

% clf;
    end
    end
            close(aviobj);
    disp(['finished combinedvideo',num2str(i)]);   
    clear v mov vidFrame behavframer
end
% save([conditionfolder,'/','combinedVideomov','_','cell#',num2str(j),'.mat', 'mov', '-v7.3']) %% save the data for making a video
% the following is used for save a video as .AVI


toc;
close all
% end

