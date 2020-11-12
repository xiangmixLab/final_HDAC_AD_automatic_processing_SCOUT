%concatenate video
function [templatename,videoname]=video_concatenate_new_large_data_fast(orilocation,destination,vname,mrange,mscamprefix)
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
        scale_f=0.5;
        
        tic;
        cvid_temp={};
        
        z_leng=[];
        for k=1:lengk
            z_leng(k)=v.NumberOfFrames;
        end
        
        totalRounds=ceil(lengk/numlabs);
        Num_to_be_processed=lengk;
        nlabs_to_use=12;
        
        for r1=1:totalRounds
            if Num_to_be_processed>nlabs_to_use
                nlabs_to_use_t=nlabs_to_use;
                Num_to_be_processed=Num_to_be_processed-numlabs;
            else
                nlabs_to_use_t=Num_to_be_processed;
            end
            
            spmd(nlabs_to_use_t)  
                % numlabs - Total number of workers operating in parallel on current job 
                % read chunk of data 
                concatenatedvideo_par = avi_matrix_read_parallel_util(filenamet{labindex},z_leng(labindex));
                concatenatedvideo_par=imresize(concatenatedvideo_par,scale_f);
            end 
            
            for r2=1:nlabs_to_use_t
                cvid_temp{r2+nlabs_to_use*(r1-1)}=concatenatedvideo_par{r2};
            end
        end
        toc;
        disp('concatenate fin')
%% abandon the first and last frame of the videos as it usually has problems
        

        concatenatedvideo=cat(1, cvid_temp{:});
        
        concatenatedvideo(:,:,1)=zeros(size(concatenatedvideo,1),size(concatenatedvideo,2));
        concatenatedvideo(:,:,end)=zeros(size(concatenatedvideo,1),size(concatenatedvideo,2));
%% reduce
        concatenatedvideo_res=concatenatedvideo(:,:,1:2:end);
        disp('reduce fin')
%% resize
        
        clear concatenatedvideo

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