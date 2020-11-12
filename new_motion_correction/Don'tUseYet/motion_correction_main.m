%%% demo of the full MIN1PIPE %%%
function neuron=motion_correction_main(filename)
%% session-specific parameter initialization %% 
Fsi = 20;
Fsi_new = 20; %%% no temporal downsampling %%%
spatialr = 1; %%% no spatial downsampling %%%
se = 5; %%% structure element for background removal %%%
ismc = true; %%% run movement correction %%%
flag = 1; %%% use auto seeds selection; 2 if manual %%%
% isvis = true; %%% do visualize %%%
ifpost = false; %%% set true if want to see post-process %%%




%% main program %%
m = motion_correction(Fsi, Fsi_new, spatialr, se, ismc, flag,filename);

reg_size=size(m,'reg');
Ysignal=zeros(reg_size,'uint8');
for k=1:ceil(reg_size(3)/500)
    Ysignal(:,:,500*(k-1)+1:min(reg_size(3),500*k))=...
        uint8(255*m.reg(:,:,500*(k-1)+1:min(reg_size(3),500*k)));
end
clear m

load(filename);

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
