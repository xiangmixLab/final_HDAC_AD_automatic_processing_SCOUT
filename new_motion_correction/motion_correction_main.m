%%% demo of the full MIN1PIPE %%%
function [neuron, Y]=motion_correction_main(filename,downsample_factor,clear_files)
%% session-specific parameter initialization %% 
Fsi = 20;
Fsi_new = 20; %%% no temporal downsampling %%%
spatialr = 1; %%% no spatial downsampling %%%
se = 5; %%% structure element for background removal %%%
ismc = true; %%% run movement correction %%%
flag = 1; %%% use auto seeds selection; 2 if manual %%%
% isvis = true; %%% do visualize %%%
post = false; %%% set true if want to see post-process %%%

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
   save_file=true;
   avi_file=true;
end

if exist('downsample_factor','var')&downsample_factor>1;
    if ~exist('Y','var')
        load(filename);
    end
    Y=imresize(Y,[round(size(Y,1)/downsample_factor),round(size(Y,2)/downsample_factor)]);
    name=[name,'_downsampled'];
    filename=fullfile(path,[name,'.mat']);
    save_file=true;
end
if save_file
    save(filename,'Y','-v7.3')
end
%% main program %%
%Background subtraction
m = motion_correction(Fsi, Fsi_new, spatialr, se, ismc, flag,filename);

reg_size=size(m,'reg');
Ysignal=zeros(reg_size,'uint8');
for k=1:ceil(reg_size(3)/500)
    Ysignal(:,:,500*(k-1)+1:min(reg_size(3),500*k))=...
        uint8(255*m.reg(:,:,500*(k-1)+1:min(reg_size(3),500*k)));
end
clear m

load(filename,'Y');

%Motion Correction
Y=runrigid3(Ysignal,Y,true); %Replace with Y=runrigid3(Ysignal,Ysignal,true) for neural extraction from background subtracted data
Ysiz=size(Y);

save(fullfile(path,[name,'_motion_corrected']),'Y','Ysiz','-v7.3'); %Comment this if you don't want to save motion corrected data


delete(fullfile(path,[name,'_frame_all.mat']))


%Neural Extraction
neuron=demo_script_adapted_052219(Y,100);
if clear_files
    if exist('downsample_factor','var')&downsample_factor>1;
        delete(fullfile(path,[name,'.mat']))
    end
    try
        delete(fullfile(path,[name,'_motion_corrected','.mat']))
    end
    if avi_file
        try
             delete(fullfile(path,[name,'.mat']))
        end
    end
end

