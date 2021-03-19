% HDAC AD automatic processing main streamline
% possible type of experiment (experiment_type);
% "openfield"
% "OLM"
% "ORM"
% "dryland"
% "GRAB"
function main_streamline_func_session_based(experiemnt_type,orirange)

    setenv('MW_MINGW64_LOC','C:\TDM-GCC-64'); % comment out in linux

    %% ask where is the infofile
    [infoname, path] = uigetfile('.mat', 'selete the experiment info matfile');
    load([path,'\',infoname])

    %% check msprefix, behavprefix
    [unique_prefix]=prefix_check(orilocation{1});
    behavprefix=unique_prefix{1};
    msprefix=unique_prefix{2};
    
    orirange=[1:length(orilocation)];

    %% ROI selection
    for i=[1]
        ROIlist{i}=ROIdetermineManual_older_ver(orilocation{i},behavprefix)
    end

    %% obj selection
    for i=orirange
        objlist{i}=objSelectManual(orilocation{i},behavprefix,ROIlist{i})
    end
    [vname, destination, orilocation,ROIlist,objlist]=arrange_vname(orilocation,destination,ROIlist,objlist,vname,uni_vname);

    %% make destination folder; timestamp name
    for i=1:size(destination,1)
        mkdir(destination{i});
        timestamp_name{i,1}=['timestamp_',vname{i},'.dat'];
    end

    %% move videos
    tic;
    [templatename,videoname]=video_concatenate_new_large_data(orilocation,destination,vname,[31],msprefix);
    toc;
    %% motion correction
    foldernamestruct={};
    t1=tic;
    parfor k=1:length(orirange)
        foldernamestruct{k}=runrigid1_automaticadapted_strline_new(templatename,videoname,k,{[4,12]});
        toc(t1)
    end
    foldernamestruct=reshape(foldernamestruct,length(unique(destination)),[]);
    %% extract behavior
    [behavfile_list]=Miniscope_behav_extraction_auto(orilocation,vname,behavprefix,[1],'ROIlist',ROIlist,'List',objlist,real_arena_size,'lab');
    save([path,'\',infoname],'orilocation','destination','vname','timestamp_name','uni_vname','real_arena_size','num2read','foldernamestruct','data_shape','templatename','videoname','ROIlist','objlist','path','infoname','behavfile_list','behavprefix','msprefix');

    %% neuron extraction
    folderName=unique(destination);
    for i=[4:8]
        tic;
        SCOUT_pipeline_full(foldernamestruct(i,:))    
        toc;
    end
    
    %% project data info generation
    [folderName,condName,namePartst,behavName,timestampName,msCamid,behavCamid,numpartsall]=file_info_generation(orilocation,destination,timestamp_name,vname,1,behavfile_list);
    save([path,'\',infoname],'orilocation','destination','vname','timestamp_name','uni_vname','real_arena_size','num2read','foldernamestruct','data_shape','templatename','videoname','folderName','condName','namePartst','behavName','timestampName','msCamid','behavCamid','numpartsall','ROIlist','objlist','path','infoname','behavprefix','msprefix');
    
    %% manual delete bad neurons
    del_ind={};
    for i=[14 15 25]
        load([folderName{i},'\','further_processed_neuron_extraction_final_result.mat']);
        [neuron,del_ind{i}]=manual_deletion_main(neuron,12);
%         save([folderName{i},'\','further_processed_neuron_extraction_final_result_manual_del.mat'],'neuron','-v7.3');
    end
    uisave({'del_ind'},'manual_temporal_del_030421');

    %% manual delete based on footprint
    neuron_all={};
    for i=1:length(folderName)
        load([folderName{i},'\','further_processed_neuron_extraction_final_result.mat']);
        neuron_all{i}=neuron.copy;
    end
    for i=1:length(folderName)
        [~,del_idx_t]=neuron_delete_based_on_footprint(neuron_all{i});
        del_ind{i}=unique([del_ind{i},del_idx_t]);
    end
    uisave({'del_ind'},'manual_temporal_del_030421');
    %% auto delete bad neurons
    neuronIndividuals_new_generation_030521(foldername(1:20),{'timestamp_hor1.dat','timestamp_hor2.dat','timestamp_hor3.dat','timestamp_vet1.dat','timestamp_vet2.dat','timestamp_hor4.dat'},mscamid(1:20),behavcamid(1:20),[13]);