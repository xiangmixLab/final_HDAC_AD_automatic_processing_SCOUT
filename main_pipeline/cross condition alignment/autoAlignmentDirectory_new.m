function []=autoAlignmentDirectory_new(drcty)
%drcty-string, directory path containing files

if ~isfolder('higherdirectory')
    mkdir('higherdirectory')
end
f= dir(drcty); 
total_files={f.name};
vid_files={};
for i=1:length(total_files)
    [filepath,name,ext]= fileparts(total_files{i});
    if isequal(ext,'.tif')||isequal(ext,'.mat')
        vid_files{end+1}=horzcat(name,ext);
    end
end

vid_files=sort(vid_files)
%Check to make sure filenames are in the correct order

i=1;


while i<=length(vid_files)
    [filepath,name,ext]= fileparts(vid_files{i});
    if isequal(ext,'.tif')
        fixed=loadtiff(vid_files{i});
        
    else
        fixed=load(vid_files{i});
        %Edit this 
        %fixed=fixed.fixed;
        fixed=fixed.Mr;
    end
   
    for j=i+1:length(vid_files)
        [filepath,name,ext]= fileparts(vid_files{j});
        if isequal(ext,'.tif')
            moving=double(loadtiff(vid_files{j}));
        else
            moving=load(vid_files{j});
            %moving=double(moving.fixed);
            moving=double(moving.Mr);
        end
        
        fixed_proj=double(max(fixed,[],3));
        moving_proj=max(moving,[],3);
        registration=registration2d(fixed_proj,moving_proj);
        %keep=input('Is registration acceptable? y/n ','s');
        keep='y';
        if isequal(lower(keep),'y')
            parfor k=1:size(moving,3)
                moving(:,:,k) = deformation(moving(:,:,k),...
                registration.displacementField,registration.interpolation);
            end
            moving=uint8(moving);
            fixed(:,:,size(fixed,3)+1:size(fixed,3)+size(moving,3))=moving;
            if j==length(vid_files)
                Y=fixed;
                Ysiz=size(Y);
                save('final concatenated stack.mat','-v7.3');
                i=j-1;
            end
        else
            Y=fixed;
            Ysiz=size(Y);
            save('final concatenated stack.mat','-v7.3');
            i=j-1;
            break
        end
    end
end
    