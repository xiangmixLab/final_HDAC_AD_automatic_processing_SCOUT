function [num2read,filedir,ds]=autoAlignmentDirectory_adapted_091820(fname,method)
%drcty-string, directory path containing files
cd(drcty);
% if ~isfolder('higherdirectory')
%     mkdir('higherdirectory')
% end
num2read=[];

vid_files=fname;


% vid_files=sort(vid_files)
%Check to make sure filenames are in the correct order

% i=fix;
i=1;
max_vid_num=10;

% while i<=length(vid_files)
[filepath,name,ext]= fileparts(vid_files{i});
if isequal(ext,'.tif')
    fixed=loadtiff(vid_files{i});   
    num2read(i+1)=size(fixed,3);
else
    fixed=load(vid_files{i});
    %Edit this 
    %fixed=fixed.fixed;
    fixed=fixed.Y;
    num2read(i+1)=size(fixed,3);
end
fixed=double(fixed);
disp('fixed vid loaded');
idxx=[1:length(vid_files)];
idxxx=idxx(idxx~=i);
% Y=[];
% Y(:,:,)
if ~isempty(idxxx)
    for j=idxxx
        [filepath,name,ext]= fileparts(vid_files{j});
        if isequal(ext,'.tif')
            moving=double(loadtiff(vid_files{j}));
            num2read(j+1)=size(moving,3);
        else
            moving=load(vid_files{j});
            %moving=double(moving.fixed);
            moving=double(moving.Y);
            num2read(j+1)=size(moving,3);
        end
        disp(['movine vid ',num2str(j)]);
        if isequal(method,'std')
            fixed_proj=std(double(fixed),[],3);
            moving_proj=std(double(moving),[],3);
        end
        if isequal(method,'median')
            fixed_proj=median(double(fixed),3);
            moving_proj=median(double(moving),3);
        end 
        if isequal(method,'mean')
            fixed_proj=mean(double(fixed),3);
            moving_proj=mean(double(moving),3);
        end 
        if isequal(method,'max')
            fixed_proj=max(double(fixed),[],3);
            moving_proj=max(double(moving),[],3);
        end     
        if isequal(method,'corr')
            fixed_proj=double(correlation_image_for_alignment(double(fixed)));
            moving_proj=double(correlation_image_for_alignment(double(moving)));
        end    
        registration=registration2d(fixed_proj,moving_proj);
        %keep=input('Is registration acceptable? y/n ','s');
        keep='y';
        if isequal(lower(keep),'y')
            for k=1:size(moving,3)
                moving(:,:,k) = deformation(moving(:,:,k),...
                registration.displacementField,registration.interpolation);
            end
            moving=uint8(moving);
            fixed(:,:,size(fixed,3)+1:size(fixed,3)+size(moving,3))=moving;
            if j==i+max_vid_num||j==length(vid_files)
                [filepath,name,ext]= fileparts(vid_files{i}) ;
                [filepath1,name1,ext1]= fileparts(vid_files{j}) ;
                Y=fixed;
                Ysiz=size(Y);
                save(horzcat('./','final_concatenate_stack.mat'),'Y','Ysiz','-v7.3');
                sav=['final_concatenate_stack.avi'];
                aviobj = VideoWriter(sav,'Motion JPEG AVI');
                aviobj.FrameRate=10;
                open(aviobj);
                for it=1:size(Y,3)
                    frameM=uint8(Y(:,:,it));
                    writeVideo(aviobj,frameM);
                end
                close(aviobj);
    %             i=j-1;
            end
        else
            [filepath,name,ext]= fileparts(vid_files{i}); 
            [filepath1,name1,ext1]= fileparts(vid_files{j-1}); 
            Y=fixed;
            Ysiz=size(Y);
            save(horzcat('./','final_concatenate_stack.mat'),'Y','Ysiz','-v7.3');
    %         i=j-1;
            break
        end
    end
else
    Y=fixed;
    Ysiz=size(Y);
    save(horzcat('./','final_concatenate_stack.mat'),'Y','Ysiz','-v7.3');
end

% end
num2read(1)=sum(num2read(2:end)); 
filedir=[pwd,'\','final_concatenate_stack.mat'];
ds=[size(Y,1),size(Y,2)];