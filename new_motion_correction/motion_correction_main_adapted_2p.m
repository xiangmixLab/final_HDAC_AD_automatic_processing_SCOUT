%%% demo of the full MIN1PIPE %%%
function [Mr]=motion_correction_main_adapted_2p(fname)
%% session-specific parameter initialization %% 
Fsi = 40;
Fsi_new = 40; %%% no temporal downsampling %%%
spatialr = 1; %%% no spatial downsampling %%%
se = 7; %%% structure element for background removal %%%
ismc = true; %%% run movement correction %%%
flag = 1; %%% use auto seeds selection; 2 if manual %%%
% isvis = true; %%% do visualize %%%



%% main program %%
%Background subtraction
m = motion_correction_adapted(Fsi, Fsi_new, spatialr, se, ismc, flag,fname);

reg_size=size(m,'reg');
Ysignal=zeros(reg_size,'uint8');
for k=1:ceil(reg_size(3)/500)
    Ysignal(:,:,500*(k-1)+1:min(reg_size(3),500*k))=uint8(255*m.reg(:,:,500*(k-1)+1:min(reg_size(3),500*k)));
end
clear m

%Motion Correction
%     Mr=runrigid3(Ysignal,concatenatedvideo_res,true); %Replace with Y=runrigid3(Ysignal,Ysignal,true) for neural extraction from background subtracted data
Mr=runrigid3(Ysignal,Ysignal,true);

reg_name=[fname(1:end-4),'_reg.mat'];
delete(reg_name);
