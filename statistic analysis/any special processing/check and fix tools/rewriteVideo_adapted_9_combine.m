function rewriteVideo_adapted_9_combine(neuron,behav,conditionfolder,moviedir,startframe,behavfileindex,idxcell,lab)
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
mkdir(conditionfolder);

position=behav.positionblue;
%startframe indicates which frame you wants to start among the whole data
%series. behavfileindex may do part of the job but as for each day it
%always starts from 1 this may not be the case. startframe further
%indicated which day you wants to start
YSignal=zeros(240,376,length(behavfileindex)*1000/2+1);
neurontrace0=zeros(size(neuron.C,1),size(neuron.C,2));

if lab=='trace'
neurontrace0=neuron.trace;
maxS = max(neuron.trace,[],2);
threshall = 0.1*maxS; % a vector
for j=1:length(behavfileindex)*1000/2+1
for i=1:size(neuron.A,2)
YSignal(:,:,j)=YSignal(:,:,j)+reshape(neuron.A(:,i)*1/max(max(neuron.A(:,i))),240,376)*neuron.trace(i,startframe+(min(behavfileindex)-1)*1000/2+j);
end
end
end
if lab=='S'
neurontrace0=neuron.S;
maxS = max(neuron.S,[],2);
threshall = 0.1*maxS; % a vector
for j=1:length(behavfileindex)*1000/2+1
for i=1:size(neuron.A,2)
YSignal(:,:,j)=YSignal(:,:,j)+reshape(neuron.A(:,i)*1/max(max(neuron.A(:,i))),240,376)*neuron.S(i,startframe+(min(behavfileindex)-1)*1000/2+j);
end
end
end   
if lab=='C'
neurontrace0=neuron.C;
maxS = max(neuron.C,[],2);
threshall = 0.1*maxS; % a vector
for j=1:length(behavfileindex)*1000/2+1
for i=1:size(neuron.A,2)
YSignal(:,:,j)=YSignal(:,:,j)+reshape(neuron.A(:,i)*1/max(max(neuron.A(:,i))),240,376)*neuron.C(i,startframe+(min(behavfileindex)-1)*1000/2+j);
end
disp(num2str(j))
end
end

axt=figure('units','normalized','outerposition',[0 0 1 1]);
ax1 = subplot(10,20,[1:5,21:25,41:45,61:65,81:85]);
ax2 = subplot(10,20,[6:10,26:30,46:50,66:70,86:90]);
ax4 = cell(length(idxcell),1);
for i1=1:length(idxcell)
    ax4{i1,1}=subplot(10,20,[11+(i1-1)*(20):20+(i1-1)*(20)]);
end
ax3 = cell(length(idxcell),1);
for i2=1:length(idxcell)
    ax3{i2,1}=subplot(10,20,[101:105,121:125,141:145,161:165,181:185]+5*(i2-1));
end

behavfilesid={dir([moviedir,'behav*.avi'])};
behavnumFiles = length(behavfileindex); % the number of videos that are needed to be combined. If you comment this line,then it will making a video including all the behavam.avi files;
% otherwise, you just want to make a video including the first few bahavCam.avi files

% neuron movie denoised threshold
% ac_quantile = .99999;
% ACmax = quantile(YSignal(1:1000:numel(YSignal)), ac_quantile);
Coor=neuron.Coor;
aa=cell(1,length(idxcell));

for i = 1:behavnumFiles
    if ~isempty(moviedir)
    tic;
    v = VideoReader([moviedir,'behavCam1_',num2str(behavfileindex(i)),'.avi']);
    %     numFrames = get(v,'NumberOfFrames');
    k=0;

    while hasFrame(v)
        k = k+1;

        vidFrame = readFrame(v);

%% behav video with trajectory
        axes(ax1);
        set(ax1,'Visible','off')
        behavframer=vidFrame;
        imshow(behavframer);
        set(gca,'Ydir','Normal')
        hold on
        plot(position((min(behavfileindex)-1)*1000+1:k+(behavfileindex(i)-1)*1000,1)+behav.ROI(1),position((min(behavfileindex)-1)*1000+1:k+(behavfileindex(i)-1)*1000,2)+behav.ROI(2),'r-','LineWidth',1);
        title('behavior video');
        pause(1/v.FrameRate);
%  
%% cell movie
        axes(ax2);
        imagesc(YSignal(:, :, round((k/2))));
        %     colormap gray;
        hold on; axis equal; axis off;
        set(gca, 'children', flipud(get(gca, 'children')));
        for m=1:length(idxcell)
            temp1 = Coor{idxcell(m)};
            plot(temp1(1, 4:end), temp1(2, 4:end), 'color','r','lineWidth',1);
            text(mean(temp1(1, 4:end))+3, mean(temp1(2, 4:end)), num2str(idxcell(m)), 'fontsize', 15, 'color', 'g');
        end
%         colorbar;
%         caxis([0, ACmax]);
        
 %% behav trajectory--all cells
%  
    for idxc=1:length(idxcell)
        axes(ax3{idxc,1})
%         title(['example cell ',num2str(idxc)  ', ID:',num2str(idxcell(idxc))]);
        title(['cell ',', ID:',num2str(idxcell(idxc))]);
%         set(gca,'Ydir','reverse')
        set(gca,'xtick',[]);
        axis image
        hold on
        plot(behav.ROI(3),behav.ROI(4));
        plot(0,0);
        posObjects=ceil(behav.object); %binsize is 15
        if sum(posObjects)~=0
            for i5 = 1:size(posObjects,01)
                scatter(posObjects(i5,1),behav.ROI(4)-posObjects(i5,2)+1,75,'k','filled')
                text(posObjects(i5,1),behav.ROI(4)-posObjects(i5,2)-2,[num2str(i5)]);
            end
        end
        plot(position((min(behavfileindex)-1)*1000+1:k+(behavfileindex(i)-1)*1000,1),position((min(behavfileindex)-1)*1000+1:k+(behavfileindex(i)-1)*1000,2),'k-','LineWidth',0.75);
        thresh1 = threshall(idxcell(idxc),1);
        idx = neurontrace0(idxcell(idxc),(k+(behavfileindex(i)-1)*1000/2))>thresh1;
        if any(idx)
            scatter(position(k+(behavfileindex(i)-1)*1000,1),position(k+(behavfileindex(i)-1)*1000,2),10,'r','filled');
        end
    end        
% %        
%% cell neuron.C--all cells 
      
    startnum=round((min(behavfileindex)-1)*1000/2+1);
    if startnum<1
        startnum=1;
    end
    if round(max(behavfileindex)*1000)>size(neuron.C,2)
        endnum=round(size(neuron.C,2));
    else
        endnum=round(max(behavfileindex)*1000/2);
    end
            
        ylimrange=[zeros(length(idxcell),1) max(neurontrace0(idxcell,:),[],2)+1];
  
    
    
    for idxc2=1:length(idxcell)
        delete(aa{idxc2});
        axes(ax4{idxc2,1});
        plot(neurontrace0(idxcell(idxc2), startnum:endnum),'color','b'); hold on;
%         ylabel(['cell ',num2str(idxc2)],'FontSize',15);
        set(gca, 'xticklabel', []); axis tight;
        set(gca, 'yticklabel', []);
        xlim([1, length(startnum:endnum)]);
        ylim(ylimrange(idxc2,:)); 
%         eval(sprintf(['aa',num2str(idxc2),'=plot([k+startnum,k+startnum], get(gca, ''ylim''), ''r''); ']));
        aa{idxc2}=plot([(k+(i-1)*1000/2),(k+(i-1)*1000/2)], get(gca,'ylim'), 'r');
%         eval(sprintf(['delete(aa',num2str(idxc2),'); ']));
    end    
%     
    mov(k)=getframe(axt);    
    %% still ... togo
    disp(num2str(num2str(behavfileindex(i))));
    disp(num2str(k+(behavfileindex(i)-1)*1000));
    disp(['still need',num2str(behavnumFiles*1000-(k+(i-1)*1000)),' to go']);
    end
    end

    v1 = VideoWriter([conditionfolder,'/','behav_video ',num2str(behavfileindex(i)),'.avi'],'Uncompressed AVI');
    open(v1)
    writeVideo(v1,mov)
    close(v1)
    
    disp(['finished combinedvideo',num2str(i)]);   
    clear v mov vidFrame behavframer
end
% save([conditionfolder,'/','combinedVideomov','_','cell#',num2str(j),'.mat', 'mov', '-v7.3']) %% save the data for making a video
% the following is used for save a video as .AVI


toc;
close all
% end

