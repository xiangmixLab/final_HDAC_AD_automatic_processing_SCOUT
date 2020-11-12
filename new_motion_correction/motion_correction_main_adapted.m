%%% demo of the full MIN1PIPE %%%
function [neuron, Y]=motion_correction_main_adapted(videoname,orirange)
%% session-specific parameter initialization %% 
Fsi = 12;
Fsi_new = 12; %%% no temporal downsampling %%%
spatialr = 1; %%% no spatial downsampling %%%
se = 4; %%% structure element for background removal, half neuron size %%%
ismc = true; %%% run movement correction %%%
flag = 1; %%% use auto seeds selection; 2 if manual %%%
% isvis = true; %%% do visualize %%%
post = false; %%% set true if want to see post-process %%%
downsample_factor=1;

for i=1:length(orirange)
    filename=videoname{orirange(i)};
    filename=GetFullPath(filename);
    [path,name,ext]=fileparts(filename);
    save_file=false;
    if isequal(ext,'.avi')

        v=VideoReader(filename);
        Y1=v.read();
        %Convert recording to grayscale
        Y1=squeeze(max(Y1,[],3));
        filename=fullfile(path,[name,'.mat']);
        Y=Y1;
    end

    if exist('downsample_factor','var')&downsample_factor>1;
        if ~exist('Y','var')
            load(filename);
        end
        Y=imresize(Y,[round(size(Y,1)/downsample_factor),round(size(Y,2)/downsample_factor)]);
        name=[name,'_downsampled'];
        filename=fullfile(path,[name,'.mat']);
    end

    %% main program %%
    %Background subtraction
    m = motion_correction_adapted(Fsi, Fsi_new, spatialr, se, ismc, flag,filename);

    reg_size=size(m,'reg');
    Ysignal=zeros(reg_size,'uint8');
    for k=1:ceil(reg_size(3)/500)
        Ysignal(:,:,500*(k-1)+1:min(reg_size(3),500*k))=uint8(255*m.reg(:,:,500*(k-1)+1:min(reg_size(3),500*k)));
    end
    clear m
    
    reg_name=[filename(1:end-4),'_reg.mat'];
    delete(reg_name);
%     load(filename);

    %Motion Correction
%     Mr=runrigid3(Ysignal,concatenatedvideo_res,true); %Replace with Y=runrigid3(Ysignal,Ysignal,true) for neural extraction from background subtracted data
    Mr=runrigid3(Ysignal,Ysignal,true);
%     Mr=runrigid1_func(Ysignal);
    Ysiz=size(Mr);

    sname=12*100000+4*1000+i;
    aviobj = VideoWriter(fullfile(path,[num2str(sname),'.avi']),'Motion JPEG AVI');
    aviobj.FrameRate=20;

    open(aviobj);
    for it=1:Ysiz(3)
        frame=uint8(Mr(:,:,it));
        writeVideo(aviobj,frame);
    end
    close(aviobj);
    Y=Mr;
    save(fullfile(path,[num2str(sname),'.mat']),'Y','Ysiz','-v7.3'); %Comment this if you don't want to save motion corrected data
    save(fullfile(path,[num2str(sname),'metric.mat']),'Ysiz'); %Comment this if you don't want to save motion corrected data

end
