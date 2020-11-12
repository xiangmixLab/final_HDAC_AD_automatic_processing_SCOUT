%concatenate video
function [templatename,videoname]=video_concatenate_new(orilocation,destination,vname,mrange,mscamprefix)
tic

templatename={};
videoname={};

count=1;
disp('start')
for i=mrange
    tic
    if ~isempty(orilocation{i,1})
        cd(orilocation{i,1});
        filenamestruct=dir([mscamprefix,'*.avi']);
        lengk=sum(~cellfun(@isempty,{filenamestruct.name}));
        for k=1:lengk
            ft=filenamestruct(k).name;
            num_c=ft(findstr(ft,mscamprefix)+length(mscamprefix):findstr(ft,'.avi')-1);
            if ~isempty(findstr(num_c,'_'))
                num_c=num_c(2:end);
            end
            num_ind=str2num(num_c);
            filenamet{num_ind}=ft;
        end
%% concatenate
        sign=1;
%         num2read=[0];
        v=VideoReader(filenamet{1});
        concatenatedvideo=uint8(zeros(v.Height,v.Width,length(filenamet)*1000));
        for k=1:lengk
            v=VideoReader(filenamet{k});
            p=0;
%             Vidt=[];
            while hasFrame(v)
                concatenatedvideo(:,:,sign+p)=readFrame(v);
                p=p+1;
%                 Vidt(:,:,p)=readFrame(v);
            end
%             Vidt=uint8(Vidt);
%             concatenatedvideo(:,:,sign:sign+length(Vidt(1,1,:))-1)=uint8(Vidt);
%             num2read(k+1)=size(Vidt,3);
%             sign=sign+length(Vidt(1,1,:));
            sign=sign+p;
            disp(['concatenate ',num2str(k)]);
        end
        disp('concatenate fin')
%% abandon the first and last frame of the videos as it usually             has problems
        concatenatedvideo=concatenatedvideo(:,:,2:sign-1);
%% reduce
        concatenatedvideo=concatenatedvideo(:,:,1:2:end);
        disp('reduce fin')
%% resize
        scale_f=0.5;
        concatenatedvideo_res=uint8(zeros(size(concatenatedvideo,1)*scale_f,size(concatenatedvideo,2)*scale_f,size(concatenatedvideo,3)));
        for k=1:size(concatenatedvideo,3)
            framet=squeeze(concatenatedvideo(:,:,k));
            framet_2=imresize(framet,scale_f);
            concatenatedvideo_res(:,:,k)=framet_2;
        end
        disp('resize fin')
        clear concatenatedvideo
        concatenatedvideo_res=uint8(concatenatedvideo_res);
%         mkdir([destination{i,j},'\individual_condition_videos'])
%         num2read(1)=sum(num2read(2:end));
        save([destination{i,1},'\',vname{i,1},'.mat'],'concatenatedvideo_res','-v7.3');
        MAX_proj=max(concatenatedvideo_res,[],3);
        imwrite(MAX_proj, [destination{i,1},'\','MAX_',vname{i,1},'.tif']);        
        count=count+1;
        toc
        disp(['finish No.',num2str(i)])
    end
end

%% templatename and vid name
for i=1:length(orilocation)
    if ~isempty(orilocation{i})
        templatename{i}=[destination{i,1},'\','MAX_',vname{i,1},'.tif'];
        videoname{i}=[destination{i,1},'\',vname{i,1},'.mat'];
    else
        templatename{i}=[];
        videoname{i}=[];
    end
end
toc;        