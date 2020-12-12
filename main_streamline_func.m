% HDAC AD automatic processing main streamline
% possible type of experiment (experiment_type);
% "openfield"
% "OLM"
% "ORM"
% "dryland"
% "GRAB"
function main_streamline_func(experiemnt_type,orirange)

    setenv('MW_MINGW64_LOC','C:\TDM-GCC-64'); % comment out in linux

    %% ask where is the infofile
    [infoname, path] = uigetfile('.mat', 'selete the experiment info matfile');
    load([path,'\',infoname])

    %% check msprefix, behavprefix
    [unique_prefix]=prefix_check(orilocation{1});
    behavprefix=unique_prefix{1};
    msprefix=unique_prefix{2};

    %% ROI selection
    for i=[1:length(orilocation)]
        ROIlist{i}=ROIdetermineManual_older_ver(orilocation{i},behavprefix)
    end

    %% obj selection
    for i=[1:length(orilocation)]
        objlist{i}=objSelectManual(orilocation{i},behavprefix,ROIlist{i})
    end
    [vname, destination, orilocation,ROIlist,objlist]=arrange_vname(orilocation,destination,ROIlist,objlist,vname,uni_vname);

    %% make destination folder; timestamp name
    for i=1:size(destination,1)
        mkdir(destination{i});
        timestamp_name{i,1}=['timestamp_',vname{i},'.dat'];
    end

    orirange=[1:length(orilocation)];
    %% move videos
    tic;
    [templatename,videoname]=video_concatenate_new_large_data(orilocation,destination,vname,orirange,msprefix);
    toc;
    %% motion correction
    runrigid1_automaticadapted_strline_new(templatename,videoname,orirange,{[4,12]});
%     motion_correction_main_adapted(videoname,orirange)

    %% cross condition alignment
    foldername=unique(destination);
    for i=1:length(foldername)
        cd(foldername{i});
        [num2read{i},foldernamestruct{i},data_shape{i}]=video_registration_main_adapted_local(false,1,'corr',true,[],[]);
        foldernamestruct{i}=[foldername{i},foldernamestruct{i}];
    end
%     [num2read,foldernamestruct,data_shape]=cross_condition_info_extraction(destination,[1:length(unique(destination))]);
%     [foldernamestruct,num2read,data_shape]=HPC_generated_info(foldername);
    save([path,'\',infoname],'orilocation','destination','vname','timestamp_name','uni_vname','real_arena_size','num2read','foldernamestruct','data_shape','templatename','videoname','ROIlist','objlist','path','infoname')
    %% save var
    %% extract behavior
    [behavfile_list]=Miniscope_behav_extraction_auto(orilocation,vname,behavprefix,orirange,'ROIlist',ROIlist,'List',objlist,real_arena_size,'rgb');

    %% neuron extraction
    foldername=unique(destination);
    for i=[9,11]
        cd(foldername{i});
        SCOUT_pipeline_single(foldernamestruct{i},num2read{i},data_shape{i}); % changed to BatchEndoscopeauto_adapted_new_kevin 040420
%         SCOUT_pipeline_full(foldernamestruct{i},num2read,data_shape)    
    end
    
    %% project data info generation
    [folderName,condName,namePartst,behavName,timestampName,msCamid,behavCamid,numpartsall]=file_info_generation(orilocation,destination,timestamp_name,vname,1,behavfile_list);
    save([path,'\',infoname],'orilocation','destination','vname','timestamp_name','uni_vname','real_arena_size','num2read','foldernamestruct','data_shape','templatename','videoname','folderName','condName','namePartst','behavName','timestampName','msCamid','behavCamid','numpartsall','ROIlist','objlist','path','infoname');

    %% manual delete bad neurons
    del_ind={};
    for i=[9:length(folderName)]
        load([folderName{i},'\','further_processed_neuron_extraction_final_result.mat']);
        [neuron,del_ind{i}]=manual_deletion_main(neuron,10);
%         save([folderName{i},'\','further_processed_neuron_extraction_final_result_manual_del.mat'],'neuron','-v7.3');
    end
    uisave({'del_ind'},'manual_temporal_del');
    %% auto delete bad neurons
%     for i=1:length(folderName)
%         load([folderName{i},'\','further_processed_neuron_extraction_final_result.mat']);
%         save([folderName{i},'\','further_processed_neuron_extraction_final_result_ori.mat'],'neuron','-v7.3');
%         [neuron,del_ind]=auto_deletion_main(neuron);
%         save([folderName{i},'\','further_processed_neuron_extraction_final_result.mat'],'neuron','-v7.3');
%     end
    
    %% manual delete based on footprint
%     neuron_all={};
%     neuron_all1={};
%     for i=1:length(folderName)
%         load([folderName{i},'\','further_processed_neuron_extraction_final_result.mat']);
%         neuron_all{i}=neuron.copy;
%     end
%     for i=1:length(folderName)
%         neuron_all1{i}=neuron_delete_based_on_footprint(neuron_all{i});
%     end
%     for i=1:length(folderName)
%         neuron=neuron_all1{i}.copy;
%         save([folderName{i},'\','further_processed_neuron_extraction_final_result.mat'],'neuron','-v7.3');
%     end
    %check if behavName, timestampName, and namePartst make sense before move to next step
    %% which part to process
    %processingparts:
    %processingparts(1):plot individual cells
    %processingparts(2):all firing positions along experiment
    %processingparts(3):count events
    %processingparts(4):count time
    %processingparts(5):firing rate
    %processingparts(6):individual. cell count events, count time, firing rate
    %processingparts(7):amplitude
    %processingparts(8):individual cell amplitude
    %processingparts(9):info score and place cell
    %processingparts(10):individual condition cluster
    %processingparts(11):mouse look at obj
    %processingparts(12):mouse not look at obj
    %processingparts(13):cross condition cluster
    %processingparts(14):combine condition
    %processingparts(15):all mouse analysis 1: count, count time, firing rate
    %processingparts(16):all cell violet/scatter plot
    %processingparts(17):individual cell activity all box
    %processingparts(18):distance orientation relationship
    %processingparts(19):distance activity relationship
    %processingparts(20):firing rate using single peaks and first cross
    %processingparts(21):count event using single peaks and first cross
    %processingparts(22):individual. cell analysis single spike & first cross
    %processingparts(23):amplitude single spike
    %processingparts(24):individual cell amplitude single spike
    %processingparts(25):individual condition cluster parts
    %processingparts(26):distance time relationship
    processingparts=zeros(1,26);
%     processingparts([])=1;
    behavled='red';

    HDAC_AD_automatic_processing_main_new_092719(namePartst,folderName,behavName,timestampName,msCamid,behavCamid,numpartsall,num2read,processingparts,behavled,[1:20],10,[],10,10);
    % HDAC_AD_automatic_processing_main_new_linear_track(namePartst,folderName,behavName,timestampName,msCamid,behavCamid,numpartsall,num2read,processingparts,behavled,[1:length(folderName)],10,[],10,10);

    if isequal(experiemnt_type,'OLM')||isequal(experiemnt_type,'ORM')
        % it will be saved in the last mouse's folder, for now
        excelFileName=[pwd,'\','obj_stats.xlsx'];
        final_data_collection_ad_new_streamlined_func(folderName,namePartst,excelFileName,10)
    end
    