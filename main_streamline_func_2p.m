% HDAC AD automatic processing main streamline
% possible type of experiment (experiment_type);
% "openfield"
% "OLM"
% "ORM"
% "dryland"
% "GRAB"
function main_streamline_func_2p(experiemnt_type,orirange)

    setenv('MW_MINGW64_LOC','C:\TDM-GCC-64'); % comment out in linux

    %% ask where is the infofile
    [infoname, path] = uigetfile('.mat', 'selete the experiment info matfile');
    load([path,'\',infoname])
    
    %% fetch 2p info
    infoname={};
    for i=1:length(orilocation)
        infoname{i}=[orilocation{i},'.mat'];
    end

    %% make destination folder; timestamp name
    for i=1:size(destination,1)
        mkdir(destination{i});
    end

    %% generate videos from .sbx
    filename_g=sbx_to_avi_func_large_data(orilocation,destination,[1:length(orilocation)],1,1,1);

    for tk=1:length(filename_g)
        cd(destination{tk});
        filename=[filename_g{tk}];
        %% read videos
        disp('read video');
        vid=VideoReader(filename);
        i=1;
        V={};
        while hasFrame(vid)
            V{i}=uint8(rgb2gray(readFrame(vid)));
            disp(num2str(i))
            i=i+1;
        end

        clc;
        %% read infofile
        disp('read info');
        load(infoname{tk});
        if ~isempty(info.otparam)
            layers=info.otparam(3);
        else
            layers=1;
        end
        disp(['layers per round:',num2str(layers)]);

        %% split layers
        disp('split layers');
        
        split_name={};
        for i=1:layers
            V_sub=[];
            Vt=V(i:layers:end-(layers-i));
            for j=1:length(Vt)
                V_sub(:,:,j)=Vt{j};
            end
            save(['layer',num2str(i),'.mat'],'V_sub','-v7.3');
            split_name{i}=[pwd,'\','layer',num2str(i),'.mat'];
            disp(num2str(i));
        end

        clear V Vt;    

        %% motion correction
        disp('motion correction');
        num2read={};
        data_shape={};
        for i=1:layers
%             V_sub_mr=motion_correction_main_adapted_2p(split_name{i});
            load(split_name{i})
            size_V_sub=size(V_sub);
            V_sub=imresize(V_sub,[500,800]);
            V_sub_mr=runnonrigid1_2p_func(V_sub);
            V_sub_mr=imresize(V_sub_mr,size_V_sub(1:2));
            num2read{i}=size(V_sub_mr,3);
            data_shape{i}=[size(V_sub_mr,1),size(V_sub_mr,2)];
            Y=V_sub_mr;
            Y=Y(25:end-25,25:end-25,:); % get rid of the edges
            Ysiz=size(Y);
            save(['layer',num2str(i),'.mat'],'Y','Ysiz','-v7.3');
            corrected_fname{i}=[pwd,'\','layer',num2str(i),'.mat'];
            disp(num2str(i));
        end

        clear V_sub
        %% CNMF
        disp('cell extraction');
        neuronsIndividuals={};
        for i=1:layers
            neuronsIndividuals{i}=SCOUT_pipeline_single_2p(corrected_fname{i},num2read{i},data_shape{i});  %/neuron numbers extracted
            disp(num2str(i));
        end
        
        %% finish save
        [sp,sfn]=fileparts(destination{tk});
        save([destination{tk},'/',sfn,'cell_data','.mat'],'neuronsIndividuals','-v7.3');

    end

    
  