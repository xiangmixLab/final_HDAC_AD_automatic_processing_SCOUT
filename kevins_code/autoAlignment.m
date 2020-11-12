function []=autoAlignment(video1_path,video2_path)
%For memory intensive situations, modifies video 2 in place to match video
%1. 
fixed=load(video1_path);
%fixed=fixed.fixed;
fixed=fixed.Y;
moving=load(video2_path);
%moving=moving.fixed;
moving=moving.Y;
fixed_proj=double(max(fixed,[],3));
moving_proj=double(max(moving,[],3));
registration=registration2d(fixed_proj,moving_proj);

%keep=input('Is registration acceptable? y/n ','s');
keep='y';
if isequal(lower(keep),'y')
    parfor k=1:size(moving,3)
        moving(:,:,k) = uint8(deformation(double(moving(:,:,k)),...
        registration.displacementField,registration.interpolation));
    
    end
    
    
    Y=moving;
    Ysiz=size(Y);
    save(video2_path,'Y','Ysiz','-v7.3')
end
