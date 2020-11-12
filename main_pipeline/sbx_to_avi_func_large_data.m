function [filename_g,filename_r]=sbx_to_avi_func_large_data(fnamee,destination,range,interval_in,rsign,gsign)
%2p processing
% fname1={'07302018_000_000','07302018_000_001','07302018_000_002','07302018_001_000','07302018_001_001'};
if iscell(fnamee)
    fname1=fnamee;
else
    fname1={fnamee};
end


filename_g={};
filename_r={};

for k=range

    tic;
    %%open folder and select file
    fname=fname1{k}
    [pn,fn]=fileparts(fname);
    savname_prefix=[destination{k},'\',fn];

    startframe=1;

    try
        load([fname,'.mat']);
    catch
        continue
    end

    [rawdata,totalframe]=sbxread_frame_adapted(fname,startframe,[]);% make total frame empty will read all frames
    toc;

    if isempty(interval_in)
        interval=1;
    else
        interval=interval_in;
    end

    count=1;
    rawdata1=rawdata;
    clear rawdata
    pmt0=0;
    pmt1=0;
    switch info.channels
        case 1
            pmt0=1;      % both PMT0 & 1
            pmt1=1;
    %         outputdatar=single(zeros(size(rawdata1,2),size(rawdata1,3),floor(size(rawdata1,4)/interval)));
    %         outputdatag=single(zeros(size(rawdata1,2),size(rawdata1,3),floor(size(rawdata1,4)/interval)));
             outputdatar=cell(floor(size(rawdata1,4)/interval),1);
             outputdatag=cell(floor(size(rawdata1,4)/interval),1);
             outputdatar_8bit=cell(floor(size(rawdata1,4)/interval),1);
             outputdatag_8bit=cell(floor(size(rawdata1,4)/interval),1);

        case 2
            pmt0=1;      % PMT 0
            pmt1=0;
    %         outputdatag=single(zeros(size(rawdata1,2),size(rawdata1,3),floor(size(rawdata1,4)/interval)));
            outputdatag=cell(floor(size(rawdata1,4)/interval),1);
            outputdatag_8bit=cell(floor(size(rawdata1,4)/interval),1);
        case 3
            pmt0=0;      % PMT 1
            pmt1=1;
    %         outputdatar=single(zeros(size(rawdata1,2),size(rawdata1,3),floor(size(rawdata1,4)/interval)));
            outputdatar=cell(floor(size(rawdata1,4)/interval),1);
            outputdatar_8bit=cell(floor(size(rawdata1,4)/interval),1);
    end

    % pmt0=1;% a problem is pmt gain larger than 0 do not necessaryily mean the channel is active... check 08292018/01/01_000_002 for reference
    % pmt1=0;


    %% rawdata, time filtering, green
    countg=1;
    if pmt0>0&&gsign==1
        rawdatag=squeeze(rawdata1(1,:,:,:));
        %% green, spatial
        max_output_datag=zeros(1,size(outputdatag,1));
        for i=1:interval:totalframe-interval+1
            frameg=mean(squeeze(rawdatag(:,:,i:i+interval-1)),3);
            outputdatag{countg}=frameg;
            max_output_datag(i)=max(outputdatag{countg}(:));
            countg=countg+1;
        end
        toc;
        clear rawdatag
        for i=1:size(outputdatag,1)
            t=double(outputdatag{i});
            t=t*255/65536; % max value of uint16
            t=uint8(t);
            outputdatag_8bit{i}=t;
        end
        %% green save
        filename_g{k}=[savname_prefix,'_green_averaged_every_',num2str(interval),'_frames.avi'];
        sav=[savname_prefix,'_green_averaged_every_',num2str(interval),'_frames.avi'];
        aviobj = VideoWriter(sav,'Uncompressed AVI');
        aviobj.FrameRate=15;

        open(aviobj);
        for it=1:size(outputdatag_8bit,1)
            frame=outputdatag_8bit{it};
            writeVideo(aviobj,frame);
        end
        close(aviobj);

    end
    %% rawdata, time filtering, red
    countr=1;
    if pmt1>0&&rsign==1
        if pmt0>0
            rawdatar=squeeze(rawdata1(2,:,:,:));
            %% red, spatial
            max_output_datar=zeros(1,size(outputdatar,1));
            for i=1:interval:totalframe-interval+1
                framer=mean(squeeze(rawdatar(:,:,i:i+interval-1)),3);
                outputdatar{countr}=framer;
                max_output_datar(i)=max(outputdatar{countr}(:));
                countr=countr+1;
            end

            clear rawdatar
            for i=1:size(outputdatar,1)
                t=outputdatar{i};
                t=t*255/65536;
                t=uint8(t);
                outputdatar_8bit{i}=t;
            end
            %% red save
            filename_r{k}=[savname_prefix,'_red_averaged_every_',num2str(interval),'_frames.avi'];
            sav=[savname_prefix,'_red_averaged_every_',num2str(interval),'_frames.avi'];
            aviobj = VideoWriter(sav,'Uncompressed AVI');
            aviobj.FrameRate=15;

            open(aviobj);
            for it=1:size(outputdatar_8bit,1)
                frame=outputdatar_8bit{it};
                writeVideo(aviobj,frame);
            end
            close(aviobj);
        else
            rawdatar=squeeze(rawdata1(1,:,:,:));
            %% red, spatial
            max_output_datar=zeros(1,size(outputdatar,1));
            for i=1:interval:totalframe-interval+1
                framer=mean(squeeze(rawdatar(:,:,i:i+interval-1)),3);
                outputdatar{countr}=framer;
                max_output_datar(i)=max(outputdatar{countr}(:));
                countr=countr+1;
            end

            clear rawdatar
            for i=1:size(outputdatar,1)
                t=outputdatar{i};
                t=t*255/65536;
                t=uint8(t);
                outputdatar_8bit{i}=t;
            end
            %% red save
            filename_r{k}=[savname_prefix,'_red_averaged_every_',num2str(interval),'_frames.avi'];
            sav=[savname_prefix,'_red_averaged_every_',num2str(interval),'_frames.avi'];
            aviobj = VideoWriter(sav,'Uncompressed AVI');
            aviobj.FrameRate=15;

            open(aviobj);
            for it=1:size(outputdatar_8bit,1)
                frame=outputdatar_8bit{it};
                writeVideo(aviobj,frame);
            end
            close(aviobj);

        end   
    end

end
