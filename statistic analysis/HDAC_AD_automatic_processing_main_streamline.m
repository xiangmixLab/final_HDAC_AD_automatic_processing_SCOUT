%% HDAC AD common processing script
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

function HDAC_AD_automatic_processing_main_streamline(namepartst,foldernamet,behavnamet,timestampnameallt,mscamid,behavcamid,numpartsall,num2readall,exp,processingparts,exceld,behavled,Fs_msCam)

excelFileNameall={[],[],[],'hdac_virus_b1_data_conclusion_120418_5x5.xlsx','hdac_virus_b2_data_conclusion_110918_5x5.xlsx',[],[],[],[],'hdac_injection_data_conclusion_112518_5x5.xlsx',[],'hdac_control_young_data_conclusion_120418_5x5.xlsx'};
time_lag_period=[10 100 1];%[min(t) max(t)]

% for exp=exp1
%% choose experiment
% experimental_info;

%% some parameters
threshSpatial=10; %when plotting using neuron.S, 1 is enough; using trace, 5 maybe
threshSpatial_2=10;
threshSpatial_3=10;
countTimeThresh=[0.2,10];
compind=1;

%% start
for ikk=[1:length(foldernamet)]  
% for ikk=[5:5] 
    if ikk==10&&exp==10
        continue;
    end
    cd(foldernamet{ikk})

    [neuron,neuronfilename]=read_neuron_data(ikk,foldernamet,2);
    [mscamidt,behavcamidt,numparts,nameparts,timestampname,num2readt,baseinfoScoreThreshold,colorscale1,colorscale2,colorscale3]=HDAC_AD_paramset(mscamid,behavcamid,numpartsall,timestampnameallt,num2readall,namepartst,ikk);    
   
    if ~isempty(num2readt)
        neuron.num2read=num2readt;
    end
       
    neuronIndividuals = splittingMUltiConditionNeuronData_adapted_automatic(neuron,neuronfilename,mscamidt,behavcamidt,timestampname);    
    
    thresh = determiningFiringEventThresh_SPEC(neuron,'C'); % a thresh for C   
%     thresh = determiningFiringEventThresh(neuron,'C');      
    
    num_of_conditions=length(nameparts);
    num_of_all_individual_conditions=length(neuronIndividuals);
    
    [conditionfolder,conditionfolder1,conditionfolder2,conditionfolder3,conditionfolder4,conditionfoldercombine,conditionfoldercombinecluster,one_condition_cluster_index]= HDAC_AD_foldername_set(nameparts,num_of_conditions,numparts);  
    [behavcell,smallvelo,behavcellnodata]=HDAC_AD_behavload(behavnamet,num_of_all_individual_conditions,ikk);   
%     [behavcell,neuronIndividuals,headorientationcell]=HDAC_AD_clear_small_velo_points(neuronIndividuals,behavcell,headorientationcell,smallvelo);   
    maxbehavROI=maxposregioncal(behavcell,neuron,neuronIndividuals);%calculate the max movement region for plotting     
    
%     nameset={'1','2','3','4'};
    nameset={'ori','mov','upd','nov'};
    objnamecell=objnamedec(behavcell,numparts,nameset);
    special_experiment_objname;
    
    [headorientationcell,in_use_objects,unique_obj_name_map]=HDAC_AD_headtoobj(behavcell,num_of_all_individual_conditions,ikk,objnamecell,exp,maxbehavROI);
    
    [neuronIndividuals_new,num2read1,timeindex]=HDAC_AD_merge_individual(neuron,neuronfilename,neuronIndividuals,numparts,num_of_conditions);
    neuronIndividuals_new=neuronIndividuals_special_processing(neuronIndividuals_new,thresh); 
    save('neuronIndividuals_new.mat','neuronIndividuals_new');
    colorscaleminmax1=zeros(num_of_conditions,2);%search all three/two conditions,find the overall min and max;
    colorscaleminmax2=zeros(num_of_conditions,2);%search all three/two conditions,find the overall min and max;
    colorscaleminmax3=zeros(num_of_conditions,2);%search all three/two conditions,find the overall min and max;
    colorscaleminmax4=zeros(num_of_conditions,2);
    countsaveall=cell(1,length(conditionfolder));%save all count information for combined ploting session

%% result generation
    for binsize=15
%% define colormap scale for comparesion and excel data cells
        define_colormap;
%% cell generation
        [compexcel,ampcompexcel,ampcompexcel_sp,infoexcel,placecellexcel,placecellindexexcel,cellclusterindexexcel,mouselookobjectfiringexcel,mouselookobjectfiringrateexcel,mouselookobjectamplitudeexcel,mouselookobjectamplituderateexcel,mouselookobjectcounttimeexcel,individualcompexcel,individualcompexcel_all,individualcompexcel_all_S,individualcompexcel_all_fc,individualcompexcel_leng,compexcel_ss,compexcel_fc,individualcompexcel_sp,individualcompexcel_fc]=HDAC_AD_excel_cell_generation(nameparts);
%% start calculating results
        for i=1:num_of_conditions
             if numparts(i)>0
                    mkdir(conditionfolder{i});
                    mkdir(conditionfolder1{i});

                    %% rearrange behav
                    [behavpos,behavtime,objects]=HDAC_AD_behavdata_gen(behavcell,timeindex,i,behavled);
                    objname=objnamecell(:,i);

                    %% what we should know is that, (0,0) of count ,countTime and firingrate is right left corner as well as obj (obj: selectObject converted)
                    %% and for behav.position, its (0,0) is on left bottom 
                    %% rearrange heading obj
                    rearrange_heading_data;
                    %% calculating firing profile
                    [firingrate,count,countTime] = calculatingCellSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.C,1),thresh,'C',[],[],countTimeThresh);  %%%bin size suggests to be 15
                    [firingrateS,countS,~] = calculatingCellSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.C,1),[],'S',[],[],countTimeThresh);  %%%bin size suggests to be 15
                    [firingratetr,counttr,~] = calculatingCellSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.C,1),[],'trace',[],[],countTimeThresh);  %%%bin size suggests to be 15
                    [amplitude_normalized,amplitude,~] = calculatingCellSpatialForSingleData_adapted_amplitude(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'C',[],[],countTimeThresh);  %%%bin size suggests to be 15
                    [amplitude_normalizedS,amplitudeS,~] = calculatingCellSpatialForSingleData_adapted_amplitude(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),[],'S',[],[],countTimeThresh);  %%%bin size suggests to be 15
                    
                    save([conditionfolder{i},'/','single_cell_amplitude_profile.mat'],'amplitude_normalized','amplitude','objects');
                    save([conditionfolder{i},'/','single_cell_firing_profile.mat'],'firingrate','count','countTime','objects');
                    save([conditionfolder{i},'/','single_cell_firing_profile_S.mat'],'firingrateS','countS','countTime','objects');
                    save([conditionfolder{i},'/','single_cell_firing_profile_tr.mat'],'firingratetr','counttr','countTime','objects');
                    save([conditionfolder{i},'/','single_cell_amplitude_profile_S.mat'],'amplitude_normalizedS','amplitudeS','objects');

                    countTime1={};
                    for o1=1:size(firingrate,2)
                        countTime1{o1}=countTime;
                    end

                    if processingparts(2)==1
                    HDAC_AD_plottingmergedbehavtrajandevents(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,thresh,i,binsize,'C',behavcell);
                    saveas(gcf,[conditionfolder{i},'/','trajectoryFiringEvent.fig'],'fig');
                    saveas(gcf,[conditionfolder{i},'/','trajectoryFiringEvent.tif'],'tif');
                    saveas(gcf,[conditionfolder{i},'/','trajectoryFiringEvent.eps'],'epsc');
                    close all;
                    end
                    
                    %% count event analysis
                    countsaveall{1,i}=count;
                    
                    if processingparts(3)==1
                    compexcel=count_event_analysis(count,firingrate,binsize,countTime, objects,colorscale1,compind,objname,conditionfolder,compexcel,nameset,nameparts,num2readt,i);
                    close all;
                    if ~isnan(behavcell{i}.distanceblue)
                        compexcel{3*i-1,9}=behavcell{i}.distanceblue;
                    else
                        if ~isnan(behavcell{i}.distancered)
                            compexcel{3*i-1,9}=behavcell{i}.distancered;
                        else
                            pb=behavcell{i}.positionblue;                            
                            dx = [0; diff(pb(:,1))];
                            dy = [0; diff(pb(:,2))];
                            dl = sqrt((dx).^2+(dy).^2);
                            compexcel{3*i-1,9} = sum(dl(~isnan(dl)));                          
                        end
                    end
                    end
                    %% count time analysis
                    if processingparts(4)==1
                    compexcel=count_time_analysis(countTime,binsize,objects,colorscale2,compind,objname,conditionfolder,compexcel,nameset,nameparts,i);
                    close all;
                    end

                    %% firing rate analysis
                    if processingparts(5)==1
                    compexcel=firing_rate_analysis(firingrate,binsize,countTime,objects,colorscale3,compind,objname,conditionfolder,compexcel,nameset,nameparts,i);
                    close all;
                    end
                    %% firing rate analysis single spike
                    if processingparts(20)==1
                    compexcel_ss=firing_rate_analysis_single_spike(firingrateS,binsize,countTime,objects,colorscale3/15,compind,objname,conditionfolder,compexcel_ss,nameset,nameparts,i);
                    compexcel_fc=firing_rate_analysis_first_cross(firingratetr,binsize,countTime,objects,colorscale3/15,compind,objname,conditionfolder,compexcel_fc,nameset,nameparts,i);
                    close all;
                    end
                    %% count event analysis single spike
                    if processingparts(21)==1
                    compexcel_ss=count_event_analysis_single_spike(countS,binsize,countTime,objects,colorscale1/15,compind,objname,conditionfolder,compexcel_ss,nameset,nameparts,i);
                    compexcel_fc=count_event_analysis_first_cross(counttr,binsize,countTime,objects,colorscale1/15,compind,objname,conditionfolder,compexcel_fc,nameset,nameparts,i);
                    close all;
                    end
                                        
                    %% comparsion, individual cells
                    if processingparts(6)==1
                    individualcompexcel{1,3+individualcompexcel_leng*(i-1)-1}=nameparts{i};
                    individualcompexcel=ind_event_rate_time_analysis(count,countTime,firingrate,binsize,objects,colorscale1,colorscale2,colorscale3,compind,objname,nameset,individualcompexcel_leng,individualcompexcel,i);     
                    end
                    
                    %% comparsion, individual cells single spike first cross
                    if processingparts(22)==1
                    individualcompexcel_sp{1,3+individualcompexcel_leng*(i-1)-1}=nameparts{i};
                    individualcompexcel_sp=ind_event_rate_time_analysis(countS,countTime,firingrateS,binsize,objects,colorscale1,colorscale2,colorscale3,compind,objname,nameset,individualcompexcel_leng,individualcompexcel_sp,i);     
                    individualcompexcel_fc{1,3+individualcompexcel_leng*(i-1)-1}=nameparts{i};
                    individualcompexcel_fc=ind_event_rate_time_analysis(counttr,countTime,firingratetr,binsize,objects,colorscale1,colorscale2,colorscale3,compind,objname,nameset,individualcompexcel_leng,individualcompexcel_fc,i);     
                    end

                    %% amplitude analysis
                    if processingparts(7)==1
                    ampcompexcel=amplitude_analysis(amplitude,amplitude_normalized,binsize,countTime,objects,colorscale4,objname,conditionfolder,nameparts,nameset,num2readt,ampcompexcel,i);
                    end
                    %% amplitude analysis
                    if processingparts(23)==1
                    ampcompexcel_sp=amplitude_analysis_single_spike(amplitudeS,amplitude_normalizedS,binsize,countTime,objects,colorscale4/15,objname,conditionfolder,nameparts,nameset,num2readt,ampcompexcel_sp,i);
                    end
                    %% individual cell amplitude
                    if processingparts(8)==1
                    individualcompexcel=individual_cell_amplitude(amplitude,amplitude_normalized,countTime,colorscale4,binsize,objects,compind,objname,nameset,individualcompexcel_leng,individualcompexcel,i);                       
                    end
                    %% individual cell amplitude
                    if processingparts(24)==1
                    individualcompexcel_sp=individual_cell_amplitude(amplitudeS,amplitude_normalizedS,countTime,colorscale4,binsize,objects,compind,objname,nameset,individualcompexcel_leng,individualcompexcel_sp,i);                       
                    end
                    %% comparsion, individual cells all box
                    if processingparts(17)==1
                    individualcompexcel_all{1,3+individualcompexcel_leng*(i-1)-1}=nameparts{i};
                    individualcompexcel_all_S{1,3+individualcompexcel_leng*(i-1)-1}=nameparts{i};                    
                    individualcompexcel_all_fc{1,3+individualcompexcel_leng*(i-1)-1}=nameparts{i};                    
                    [individualcompexcel_all,individualcompexcel_all_S,individualcompexcel_all_fc]=ind_single_cell_analysis_allAroundBox(count,binsize,countTime,firingrate,amplitude,amplitude_normalized,countS,countTime,firingrateS,amplitudeS,counttr,firingratetr,objects,compind,objname,colorscale1,colorscale2,colorscale3,colorscale4,individualcompexcel_all,individualcompexcel_all_S,individualcompexcel_all_fc,individualcompexcel_leng,i);
                    end
                    %% info-score part
                    if processingparts(9)==1
                    info_score_and_place_cell;
                    end
                    %% plot individual cells
                    if processingparts(1)==1
                    load(['place_cells_info_',conditionfolder1{i}(1:end-16),'_binsize',num2str(binsize),'.mat']);
                    plottingFiringBehaviorSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,count,1:size(neuronIndividuals_new{i}.trace,1),thresh,[],countTime,[],conditionfolder,i,binsize,'C',behavcell,[],[],firingrate,'firing rate',place_cells,Tinfo)
                    plottingFiringBehaviorSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,countS,1:size(neuronIndividuals_new{i}.trace,1),thresh,[],countTime,[],conditionfolder,i,binsize,'S',behavcell,[],[],firingrateS,'firing rate',place_cells,Tinfo)
                    plottingFiringBehaviorSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,counttr,1:size(neuronIndividuals_new{i}.trace,1),thresh,[],countTime,[],conditionfolder,i,binsize,'trace',behavcell,[],[],firingratetr,'firing rate',place_cells,Tinfo)
                    %plottingFiringBehaviorSpatialForSingleData_adapted_ct(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,count,1:size(neuronIndividuals_new{i}.trace,1),thresh,[],[],[],conditionfolder,i,binsize,'C',behavcell,countTime1,'count time',firingrate,'firing rate',place_cells,TinfoPerSecond)
                    close all;
                    end
                    %% cluster process
                    if processingparts(10)==1
                    cluster_process;
                    end
                    %% cluster process parts
                    if processingparts(25)==1
                    cluster_process_part;
                    end
                    
                    %% traveling wave analysis         
        %           wavelagtime=determinewavecorrgroup(neuron,groupall{i});
        %           save([conditionfolder2{i},'/','inter_group_cross_corr_lag_time.mat'],'wavelagtime');

                    %% mouse head to object individual cell plotting
                    if processingparts(11)==1
                    [mouselookobjectfiringexcel,mouselookobjectfiringrateexcel,mouselookobjectamplitudeexcel,mouselookobjectamplituderateexcel,mouselookobjectcounttimeexcel]=mouse_head_to_obj_cal(objects,numparts,timeindex,binsize,behavcell,countTime,neuronIndividuals_new,behavpos,behavtime,maxbehavROI,thresh,'C',if_mouse_head_toward_object,countTimeThresh,nameparts,nameset,colorscale3,objname,conditionfolder,i,mouselookobjectfiringexcel,mouselookobjectfiringrateexcel,mouselookobjectamplitudeexcel,mouselookobjectamplituderateexcel,mouselookobjectcounttimeexcel);                    
                    end
                    %% mouse no head to object individual cell plotting
                    if processingparts(12)==1
                    [mouselookobjectfiringexcel,mouselookobjectfiringrateexcel,mouselookobjectamplitudeexcel,mouselookobjectamplituderateexcel,mouselookobjectcounttimeexcel]=mouse_not_head_to_obj_cal(objects,numparts,timeindex,binsize,behavcell,countTime,neuronIndividuals_new,behavpos,behavtime,maxbehavROI,thresh,'C',if_mouse_head_toward_object,countTimeThresh,nameparts,nameset,colorscale3,objname,conditionfolder,i,mouselookobjectfiringexcel,mouselookobjectfiringrateexcel,mouselookobjectamplitudeexcel,mouselookobjectamplituderateexcel,mouselookobjectcounttimeexcel);
                    end
                    
                    if processingparts(18)==1
                    distance_orientation_relationship_obj=HDAC_AD_distance_orientation_relationship(headorientationcell{i},behavpos,in_use_objects,exp,conditionfolder,i,ikk);
                    close all;
                    end
                    
                    if processingparts(19)==1
                    HDAC_AD_distance_orientation_rate_relationship(neuronIndividuals_new{i},headorientationcell{i},behavpos,behavtime,in_use_objects,exp,conditionfolder,i,ikk);
                    close all;
                    end

            end
        end
        close all
        %% cluster only on training
        if processingparts(13)==1
        cluster_on_specific_condition;
        end

        %% combined set place cell info
        if processingparts(14)==1
        %    combined_cell_info; 
        end
        %% excel
        exname=['neuron_comparingFiringRate_averageinfo_placecell_data_binsize',num2str(binsize),'.xlsx'];

        %             delete(exname)
        if processingparts(3)==1||processingparts(4)==1||processingparts(5)==1
        xlswrite(exname,compexcel,'comparsion_objects');
        end
        if processingparts(20)==1
        xlswrite(exname,compexcel_ss,'comparsion_objects_single_spike');
        xlswrite(exname,compexcel_fc,'comparsion_objects_first_cross');
        end
        if processingparts(22)==1||processingparts(24)==1
        xlswrite(exname,individualcompexcel_sp,'comparsion_objects_cells_spike');
        xlswrite(exname,individualcompexcel_fc,'comparsion_objects_cells_cross');
        end
        if processingparts(6)==1||processingparts(8)==1
        xlswrite(exname,individualcompexcel,'comparsion_objects_cells');
        end
        if processingparts(17)==1
        xlswrite(exname,individualcompexcel_all,'comparsion_objects_cells_allBox');
        xlswrite(exname,individualcompexcel_all_S,'comparsion_cells_allBox_S');
        xlswrite(exname,individualcompexcel_all_fc,'comparsion_cells_allB_1Cross');
        end
        if processingparts(7)==1
        xlswrite(exname,ampcompexcel,'amplitude_comparsion_objects');
        end
        if processingparts(23)==1
        xlswrite(exname,ampcompexcel_sp,'amplitude_comparsion_spike');
        end
        if processingparts(9)==1
        xlswrite(exname,infoexcel,'info');
        end
        if processingparts(9)==1
        xlswrite(exname,placecellexcel,'place_cells');
        end
        if processingparts(9)==1
        xlswrite(exname,placecellindexexcel,'place_cell_index');
        end
        if processingparts(10)==1||processingparts(13)==1
        xlswrite(exname,cellclusterindexexcel,'cell_cluster');
        end
        if processingparts(11)==1||processingparts(12)==1
        xlswrite(exname,mouselookobjectfiringexcel,'mouselookobject_firing_count');
        xlswrite(exname,mouselookobjectfiringrateexcel,'mouselookobject_firing_rate');
        xlswrite(exname,mouselookobjectamplitudeexcel,'mouselookobject_firing_amp');
        xlswrite(exname,mouselookobjectamplituderateexcel,'mouselookobject_firing_amp_norm');
        xlswrite(exname,mouselookobjectcounttimeexcel,'mouselookobject_count_time');
        end
        if processingparts(14)==1
%         xlswrite(exname,pairwisecorr,'pairwise_correlation');
        end
        close all;
    end    
end

group_analysis_settings;

if processingparts(15)==1
%     count_event_time_fr_all_analysis(group,cfolder1,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,objname,num_of_conditions,boxlength,exp,'C');
%     close all;
%     count_event_time_fr_all_analysis(group,cfolder1,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,objname,num_of_conditions,boxlength,exp,'S'); 
%     close all;
%     count_event_time_fr_all_analysis(group,cfolder1,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,objname,num_of_conditions,boxlength,exp,'trace'); 
%     close all;
%     count_event_time_fr_all_analysis_all_obj(group,cfolder9,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,objname,num_of_conditions,boxlength,exp,'C');
%     close all;
%     count_event_time_fr_all_analysis_all_obj(group,cfolder9,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,objname,num_of_conditions,boxlength,exp,'S');    
%     close all;
%     count_event_time_fr_all_analysis_all_obj(group,cfolder9,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,objname,num_of_conditions,boxlength,exp,'trace');    
%     close all;    
%     count_event_time_fr_all_analysis_look_at_obj(group,cfolder2,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,num_of_conditions,boxlength,exp);
%     close all;
%     count_event_time_fr_individual_analysis(group,cfolder10,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,objname,num_of_conditions,boxlength,exp,'C');
%     close all;
%     count_event_time_fr_individual_analysis(group,cfolder10,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,objname,num_of_conditions,boxlength,exp,'S');
%     close all;
%     count_event_time_fr_individual_analysis(group,cfolder10,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,objname,num_of_conditions,boxlength,exp,'S');
%     close all;    
    distance_orientation_all_analysis(group,cfolder3,groupname,nameparts,conditionfolder,num_of_conditions,foldernamet,numpartsall,in_use_objects,exp);   
    distance_orientation_rate_all_analysis(group,cfolder8,groupname,nameparts,conditionfolder,num_of_conditions,foldernamet,numpartsall,in_use_objects,exp);   
    %     calcium_trace_section;
    close all;
end
if processingparts(16)==1
    histogram_plot(cfolder4,group,groupname,nameparts,foldernamet,exp,'C') ;
    histogram_plot(cfolder4,group,groupname,nameparts,foldernamet,exp,'S') ;
    histogram_plot_all_box(group,groupname,cfolder5,foldernamet,nameparts,exp,'C');  
    histogram_plot_all_box(group,groupname,cfolder5,foldernamet,nameparts,exp,'S');
    histogram_plot_all_box(group,groupname,cfolder5,foldernamet,nameparts,exp,'trace');
    histogram_plot_all_box_no_spatial(group,groupname,cfolder6,foldernamet,nameparts,exp,'C')   
    histogram_plot_all_box_no_spatial(group,groupname,cfolder6,foldernamet,nameparts,exp,'S')
    histogram_plot_looking_at_obj(cfolder7,group,groupname,nameparts,foldernamet,exp) ;
    close all;
end
if exceld==1
excelFileName=excelFileNameall{exp};
final_data_collection_ad_new_streamlined;
end
% end
%% all cell count E, count T and firing rate analysis

% excelFileName='hdac_virus_b1_data_conclusion_100718_3x3.xlsx';
% excelFileName='hdac_virus_b2_data_conclusion_100718_3x3.xlsx';
% excelFileName='hdac_injection_data_conclusion_100718_3x3.xlsx';
% excelFileName='hdac_injection_data_conclusion_100718_5x5.xlsx';
% excelFileName='hdac_virus_b1_data_conclusion_100718_5x5.xlsx';
% excelFileName='hdac_virus_b2_data_conclusion_100718_5x5.xlsx';
% 
% 
% final_data_collection_ad_new_streamlined;