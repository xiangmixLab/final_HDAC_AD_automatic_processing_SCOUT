function m = motion_correction(Fsi, Fsi_new, spatialr, se, ismc, flag,filename)
% main_processing
%   need to decide whether to use parallel computing
%   Fsi: raw sampling rate
%   Fsi_new: in use sampling rate
%   spatialr: spatial downsampling factor
%   Jinghao Lu 06/10/2016

    %% configure paths %%
    
    
    %% initialize parameters %%
    if nargin < 1 || isempty(Fsi)
        defpar = default_parameters;
        Fsi = defpar.Fsi;
    end
    
    if nargin < 2 || isempty(Fsi_new)
        defpar = default_parameters;
        Fsi_new = defpar.Fsi_new;
    end
    
    if nargin < 3 || isempty(spatialr)
        defpar = default_parameters;
        spatialr = defpar.spatialr;
    end
    
    if nargin < 4 || isempty(se)
        defpar = default_parameters;
        se = defpar.neuron_size;
    end
    
    if nargin < 5 || isempty(ismc)
        ismc = true;
    end
    
    if nargin < 6 || isempty(flag)
        flag = 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% user defined parameters %%%                                     %%%
    Params.Fsi = Fsi;                                                   %%%
    Params.Fsi_new = Fsi_new;                                           %%%
    Params.spatialr = spatialr;                                         %%%
    Params.neuron_size = se; %%% half neuron size; 9 for Inscopix and 5 %%%
                            %%% for UCLA, with 0.5 spatialr separately  %%%
                                                                        %%%
    %%% fixed parameters (change not recommanded) %%%                   %%%
    Params.anidenoise_iter = 4;                   %%% denoise iteration %%%
    Params.anidenoise_dt = 1/7;                   %%% denoise step size %%%
    Params.anidenoise_kappa = 0.5;       %%% denoise gradient threshold %%%
    Params.anidenoise_opt = 1;                %%% denoise kernel choice %%%
    Params.anidenoise_ispara = 1;             %%% if parallel (denoise) %%%   
    Params.bg_remove_ispara = 1;    %%% if parallel (backgrond removal) %%%
    Params.mc_scl = 0.004;      %%% movement correction threshold scale %%%
    Params.mc_sigma_x = 5;  %%% movement correction spatial uncertainty %%%
    Params.mc_sigma_f = 10;    %%% movement correction fluid reg weight %%%
    Params.mc_sigma_d = 1; %%% movement correction diffusion reg weight %%%
    Params.pix_select_sigthres = 0.8;     %%% seeds select signal level %%%
    Params.pix_select_corrthres = 0.6; %%% merge correlation threshold1 %%%
    Params.refine_roi_ispara = 1;          %%% if parallel (refine roi) %%%
    Params.merge_roi_corrthres = 0.9;  %%% merge correlation threshold2 %%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% get dataset info %%
    if ~exist('filename','var')||isempty(filename)
        [path_name, file_base, file_fmt] = data_info;
    else
        [path_name,base,ext]=fileparts(filename);
    end
    file_base{1}=base;
    file_fmt{1}=ext;
    if ~isequal(path_name(end),filesep)
        path_name=[path_name,filesep];
    end
    
    hpipe = tic;
    for i = 1: length(file_base)
        
        %%% judge whether do the processing %%%
        filecur = [path_name, file_base{i}, '_data_processed.mat'];
        msg = 'Redo the analysis? (y/n)';
        overwrite_flag = judge_file(filecur, msg);
        
        if overwrite_flag
            %% data cat %%
            Fsi = Params.Fsi;
            Fsi_new = Params.Fsi_new;
            spatialr = Params.spatialr;
            [m, filename_raw, imaxn, imeanf, pixh, pixw, nf] = data_cat(path_name, file_base{i}, file_fmt{i}, Fsi, Fsi_new, spatialr);
           
            %% neural enhancing batch version %%
           
            filename_reg = [path_name, file_base{i}, '_reg.mat'];
            [m, imaxy, overwrite_flag] = neural_enhance(m, filename_reg, Params);
            
            %% neural enhancing postprocess %%
            if overwrite_flag
                %m = noise_suppress(m, imaxy);
            end
        end
    end
end