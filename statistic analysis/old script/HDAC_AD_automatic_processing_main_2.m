%% HDAC AD common processing script

clear all;clc

nameparts_hdac_ad;
foldername_hdac_ad;
behavname_hdac_ad;
timestamp_hdac_ad;
camid_hdac_ad;
numpart_hdac_ad;
num2read_hdac_ad;


exp1=[4 5 10];

for exp=exp1
%% choose experiment
experimental_info;

threshSpatial=10; %when plotting using neuron.S, 1 is enough; using trace, 5 maybe
threshSpatial_2=10;
threshSpatial_3=10;
behavled='red';
countTimeThresh=[0.2,10];
compind=1;
for ikk=[1:length(foldernamet)]  
% for ikk=[5:5] 
    if ikk==10
        continue;
    end
    cd(foldernamet{ikk})
    [neuron,neuronfilename]=read_neuron_data(ikk,foldernamet,2);
    [mscamidt,behavcamidt,numparts,nameparts,timestampname,num2readt,baseinfoScoreThreshold,colorscale1,colorscale2,colorscale3]=HDAC_AD_paramset(mscamid,behavcamid,numpartsall,timestampnameallt,num2readall,namepartst,ikk);    
   
    if ~isempty(num2readt)
        neuron.num2read=num2readt;
    end
    
    
    neuronIndividuals = splittingMUltiConditionNeuronData_adapted_automatic(neuron,neuronfilename,mscamidt,behavcamidt,timestampname);    
    
    thresh = determiningFiringEventThresh_SPEC(neuron,'C');    
%     thresh = determiningFiringEventThresh(neuron,'C');    
    
    num_of_conditions=length(nameparts);
    num_of_all_individual_conditions=length(neuronIndividuals);
    
    [conditionfolder,conditionfolder1,conditionfolder2,conditionfolder3,conditionfoldercombine,conditionfoldercombinecluster,trainingindex]= HDAC_AD_foldername_set(nameparts,num_of_conditions,numparts);  
    [behavcell,headorientationcell,smallvelo,behavcellnodata]=HDAC_AD_behavload(behavnamet,num_of_all_individual_conditions,ikk);   
%     [behavcell,neuronIndividuals,headorientationcell]=HDAC_AD_clear_small_velo_points(neuronIndividuals,behavcell,headorientationcell,smallvelo);   
    maxbehavROI=maxposregioncal(behavcell,neuron,neuronIndividuals);%calculate the max movement region for plotting     
    
%     nameset={'1','2','2','2'};
    nameset={'ori','mov','upd','nov'};
    objnamecell=objnamedec(behavcell,numparts,nameset);
% 
    special_experiment_objname;
    
    [neuronIndividuals_new,num2read1,timeindex]=HDAC_AD_merge_individual(neuron,neuronfilename,neuronIndividuals,numparts,num_of_conditions);
    
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
        [compexcel,ampcompexcel,infoexcel,placecellexcel,placecellindexexcel,cellclusterindexexcel,mouselookobjectfiringexcel,mouselookobjectfiringrateexcel,mouselookobjectamplitudeexcel,mouselookobjectamplituderateexcel,mouselookobjectcounttimeexcel,individualcompexcel,individualcompexcel_leng]=HDAC_AD_excel_cell_generation(nameparts);

%% start calculating results
        for i=1:num_of_conditions
             if numparts(i)>0
                    mkdir(conditionfolder{i});
                    mkdir(conditionfolder1{i});

                    %% rearrange behav
                    [behavpos,behavtime,objects]=HDAC_AD_behavdata_gen(behavcell,timeindex,i,behavled);
                    objname=objnamecell(:,i);

                    %% what we should know is that, behav.position's (0,0) is on left top corner, so does count,countTime and firingrate
                    %% and for obj, its (0,0) is on left bottom (selectObject converted)
                    %% rearrange heading obj
                    rearrange_heading_data;
                    %% calculating firing profile
                    [firingrate,count,countTime] = calculatingCellSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'C',[],[],countTimeThresh);  %%%bin size suggests to be 15

                    countTime1={};
                    for o1=1:size(firingrate,2)
                        countTime1{o1}=countTime;
                    end

                    plottingFiringBehaviorSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,count,1:size(neuronIndividuals_new{i}.trace,1),thresh,[],[],[],conditionfolder,i,binsize,'C',behavcell,countTime1,'count time',firingrate,'firing rate')
                    plottingFiringBehaviorSpatialForSingleData_adapted_ct(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,count,1:size(neuronIndividuals_new{i}.trace,1),thresh,[],[],[],conditionfolder,i,binsize,'C',behavcell,countTime1,'count time',firingrate,'firing rate')
                    close all;

                    HDAC_AD_plottingmergedbehavtrajandevents(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,thresh,i,binsize,'C',behavcell);
                    saveas(gcf,[conditionfolder{i},'/','trajectoryFiringEvent.fig'],'fig');
                    saveas(gcf,[conditionfolder{i},'/','trajectoryFiringEvent.tif'],'tif');
                    saveas(gcf,[conditionfolder{i},'/','trajectoryFiringEvent.eps'],'epsc');
                    close all;

                    countsaveall{1,i}=count;
                    %% count event analysis
                    count_event_analysis;
                    close all;
                    %% count time analysis
                    count_time_analysis;
                    close all;
                    %% firing rate analysis
                    firing_rate_analysis;
                    close all;
                    %% comparsion, individual cells
                    individualcompexcel{1,3+individualcompexcel_leng*(i-1)-1}=nameparts{i};
                    for iiiii=1:length(firingrate)
                            individualcompexcel{iiiii+2,1}=iiiii;
                            ind_count_event_analysis;
                            ind_count_time_analysis;
                            ind_firing_rate_analysis;
                    end
                    %% amplitude analysis
                    amplitude_analysis;
                    %% individual cell amplitude
                    individual_cell_amplitude;
                    %% info-score part
                    info_score_and_place_cell;
                    %% cluster process
                    cluster_process;
                    %% traveling wave analysis         
        %           wavelagtime=determinewavecorrgroup(neuron,groupall{i});
        %           save([conditionfolder2{i},'/','inter_group_cross_corr_lag_time.mat'],'wavelagtime');

                    %% mouse head to object individual cell plotting
                    mouse_head_to_obj_cal;
                    %% mouse no head to object individual cell plotting
                    mouse_not_head_to_obj_cal;
            end
        end
        close all
        %% cluster only on training
        cluster_on_specific_condition;

        %% combined set place cell info
        %    combined_cell_info; 
        %% excel
        exname=['neuron_comparingFiringRate_averageinfo_placecell_data_binsize',num2str(binsize),'.xlsx'];

        %             delete(exname)

        xlswrite(exname,compexcel,'comparsion_objects');
        xlswrite(exname,individualcompexcel,'comparsion_objects_cells');
        xlswrite(exname,ampcompexcel,'amplitude_comparsion_objects');
        xlswrite(exname,infoexcel,'info');
        xlswrite(exname,placecellexcel,'place_cells');
        xlswrite(exname,placecellindexexcel,'place_cell_index');
        xlswrite(exname,cellclusterindexexcel,'cell_cluster');
        xlswrite(exname,mouselookobjectfiringexcel,'mouselookobject_firing_count');
        xlswrite(exname,mouselookobjectfiringrateexcel,'mouselookobject_firing_rate');
        xlswrite(exname,mouselookobjectamplitudeexcel,'mouselookobject_firing_amp');
        xlswrite(exname,mouselookobjectamplituderateexcel,'mouselookobject_firing_amp_norm');
        xlswrite(exname,mouselookobjectcounttimeexcel,'mouselookobject_count_time');
%         xlswrite(exname,pairwisecorr,'pairwise_correlation');
        close all;
    end
end

end

% excelFileName='hdac_virus_b1_data_conclusion_100718_3x3.xlsx';
% excelFileName='hdac_virus_b2_data_conclusion_100718_3x3.xlsx';
% excelFileName='hdac_injection_data_conclusion_100718_3x3.xlsx';
% excelFileName='hdac_injection_data_conclusion_100718_5x5.xlsx';
% excelFileName='hdac_virus_b1_data_conclusion_100718_5x5.xlsx';
% excelFileName='hdac_virus_b2_data_conclusion_100718_5x5.xlsx';
% 
% 
% final_data_collection_ad_new_streamlined;