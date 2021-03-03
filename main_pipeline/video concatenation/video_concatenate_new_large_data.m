%concatenate video
function [templatename,videoname]=video_concatenate_new_large_data(orilocation,destination,vname,mrange,mscamprefix)
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
%         for k=1:lengk
%             ft=filenamestruct(k).name;
%             num_c=ft(findstr(ft,mscamprefix)+length(mscamprefix):findstr(ft,'.avi')-1);
%             if ~isempty(findstr(num_c,'_'))
%                 num_c=num_c(2:end);
%             end
%             num_ind=str2num(num_c);
%             filenamet{num_ind}=ft;
%         end
        
        for k=1:lengk
            ft=filenamestruct(k).name;
            filenamet{num_ind}=ft;
        end
        filenamet=natsort(filenamet);
%% concatenate
        ctt=1;
        v=VideoReader(filenamet{1});
        concatenatedvideo=uint8(zeros(v.Height,v.Width,length(filenamet)*1000));
        for k=1:lengk
            v= VideoReader(filenamet{k});
            
            while hasFrame(v)
                t=readFrame(v);
                concatenatedvideo(:,:,ctt)=uint8(t);
                ctt=ctt+1;
            end
            disp(['concatenate ',num2str(k)]);
            
        end
        disp('concatenate fin')
%% abandon last few dark frames 
        concatenatedvideo(:,:,ctt:end)=[];
        toc;
%% abandon the first and last frame of the videos as it usually             has problems
        concatenatedvideo(:,:,1)=zeros(size(concatenatedvideo,1),size(concatenatedvideo,2));
        concatenatedvideo(:,:,end)=zeros(size(concatenatedvideo,1),size(concatenatedvideo,2));
%% reduce
        concatenatedvideo_res=concatenatedvideo(:,:,1:2:end);
        disp('reduce fin')
        clear concatenatedvideo
%% resize
        scale_f=0.5;
        concatenatedvideo_res=imresize(concatenatedvideo_res,scale_f);
        disp('resize fin')

%% save
        save([destination{i,1},'\',vname{i,1},'.mat'],'concatenatedvideo_res','-v7.3');
        MAX_proj=max(concatenatedvideo_res,[],3);
        imwrite(uint8(MAX_proj), [destination{i,1},'\','MAX_',vname{i,1},'.tif']);        
        count=count+1;
        disp(['finish No.',num2str(i)])
        toc;
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