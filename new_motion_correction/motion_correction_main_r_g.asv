%%% demo of the full MIN1PIPE %%%

%% session-specific parameter initialization %% 
Fsi = 20;
Fsi_new = 20; %%% no temporal downsampling %%%
spatialr = 1; %%% no spatial downsampling %%%
se = 5; %%% structure element for background removal %%%
ismc = true; %%% run movement correction %%%
flag = 1; %%% use auto seeds selection; 2 if manual %%%
% isvis = true; %%% do visualize %%%
ifpost = false; %%% set true if want to see post-process %%%

% Input file paths for green and red layers (green first)
 files={
%      '../Yongjun-2P data-R&G/07072020/PVAi9_146_000_000_green_layer3_neuron_recording.avi',...
%     '../Yongjun-2P data-R&G/07072020/PVAi9_146_000_000_red_layer3_neuron_recording.avi'
    'Y:\Kevin\Yongjun-2P data-R&G\07072020\PVAi9_146_000_000_green_layer3_neuron_recording.avi'
    'Y:\Kevin\Yongjun-2P data-R&G\07072020\PVAi9_146_000_000_red_layer3_neuron_recording.avi'
    
    };


%% Initial concatenation and filenaming
%Fix memory issues here later, it is probably best not to load the full
%file into memory
v=VideoReader(files{1});
Y1=v.read();
%Convert recording to grayscale
Y1=squeeze(max(Y1,[],3));

v=VideoReader(files{2});
Y2=v.read();
Y2=squeeze(max(Y2,[],3));

Y=cat(3,Y1,Y2);
%Comment this out if you don't want to resize
Y=imresize(Y,[round(size(Y,1)/2),round(size(Y,2)/2)]);


[path,name,ext]=fileparts(files{1});
path=fullfile(path,'motion_corrected');
mkdir(path)
cd(path)

save('concatenated_layers','Y','-v7.3')
abs_path=pwd;
abs_loc=fullfile(abs_path,'concatenated_layers.mat');

clear Y Y1  Y2

%% main program %%
m = signal_enhancement(Fsi, Fsi_new, spatialr, se, ismc, flag,abs_loc);


%For memory issues
reg_size=size(m,'reg');
Ysignal=zeros(reg_size,'uint8');
for k=1:ceil(reg_size(3)/500)
    Ysignal(:,:,500*(k-1)+1:min(reg_size(3),500*k))=...
        uint8(255*m.reg(:,:,500*(k-1)+1:min(reg_size(3),500*k)));
end
clear m

load(abs_loc,'Y');

green_layer=reshape(Ysignal(:,:,1:size(Ysignal,3)/2),size(Ysignal,1),size(Ysignal,2),1,[]);
red_layer=reshape(Ysignal(:,:,size(Ysignal,3)/2+1:end),size(green_layer));
Ysignal=cat(3,red_layer,green_layer);

green_layer=reshape(Y(:,:,1:size(Y,3)/2),size(Y,1),size(Y,2),1,[]);
red_layer=reshape(Y(:,:,size(Y,3)/2+1:end),size(green_layer));
Y=cat(3,red_layer,green_layer);

clear green_layer red_layer

save('two_layer','Y','Ysignal','-v7.3')

%Expand to 3 color channels



Y=runrigid3(Ysignal,Y,true);


save('two_layer_motion_corrected','Y','-v7.3');

delete('two_layer.mat')
delete('concatenated_layers_reg.mat')
delete('concatenated_layers_frame_all.mat')
delete('concatenated_layers.mat')

neuron_green=demo_script_function(squeeze(Y(:,:,1,:)));
neuron_red=demo_script_function(squeeze(Y(:,:,2,:)));
save('extraction_results','neuron_green','neuron_red');