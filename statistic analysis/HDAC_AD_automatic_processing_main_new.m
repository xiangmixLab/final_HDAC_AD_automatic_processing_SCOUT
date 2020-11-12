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
%processingparts(26):distance time relationship

function [objname,num_of_conditions,binsize,in_use_objects]=HDAC_AD_automatic_processing_main_new(namepartst,foldernamet,behavnamet,timestampnameallt,mscamid,behavcamid,numpartsall,num2readall,exp1,processingparts,exceld,behavled,mrange,binsize,threshs,test5minsign,small_velo)

    excelFileNameall={[],[],[],'hdac_virus_b1_data_conclusion_110918_5x5.xlsx','hdac_virus_b2_data_conclusion_110918_5x5.xlsx',[],[],[],[],'hdac_injection_data_conclusion_110918_5x5.xlsx',[],[],['Yanjun_nn_rev_data_conclusion_030219_5x5_',num2str(test5minsign),'min.xlsx'],['Yanjun_nn_rev_reverse_exp_data_conclusion_030219_5x5_',num2str(test5minsign),'min.xlsx'],[],[],'Steve_karoni_data_conclusion_022419_5x5_10min.xlsx','Yanjun_nn_rev_openfield_exp_data_conclusion_031219_5x5.xlsx','Yanjun_nn_rev_circle_square_exp_data_conclusion_031219_5x5.xlsx','Dryland_neuron_exp_data_conclusion_031219_5x5.xlsx'};
    time_lag_period=[10 100 1];%[min(t) max(t)]
    Fs_msCam=15;
    countTimeThresh=[0.1 100000000];
    Smodifier=30;
    for exp=exp1
    %% choose experiment
    % experimental_info;

    %% some parameters
    threshSpatial=10; %when plotting using neuron.S, 1 is enough; using trace, 5 maybe
    threshSpatial_2=10;
    threshSpatial_3=10;
    % behavled='red';
    % countTimeThresh=[0.2,10];
    compind=1;

    %% start
    for ikk=mrange  
    % for ikk=[5:5] 
        if ikk==10&&exp==10
            continue;
        end
        cd(foldernamet{ikk})

        [neuron,neuronfilename]=read_neuron_data(ikk,foldernamet,1);
        [mscamidt,behavcamidt,numparts,nameparts,timestampname,num2readt,baseinfoScoreThreshold,colorscale1,colorscale2,colorscale3]=HDAC_AD_paramset(mscamid,behavcamid,numpartsall,timestampnameallt,num2readall,namepartst,ikk);    

        if ~isempty(num2readt)
            neuron.num2read=num2readt;
        end

        % a special processing to neuron.S (make it: corresponding to each peak; its value is the peak value)
        for nscg=1:size(neuron.S,1)
            [pks,loc]=findpeaks(neuron.C(nscg,:));
            neuron.S(nscg,:)=neuron.S(nscg,:)*0;
            neuron.S(nscg,loc)=pks;
        end
        % another special variable (first crossing of sig. peak)
        first_crossing=[];
        for nscg=1:size(neuron.S,1)
            idx=diff(neuron.C(nscg,:)>0);
            neuron.trace(nscg,:)=[idx==1,0];
        end


        neuronIndividuals = splittingMUltiConditionNeuronData_adapted_automatic(neuron,neuronfilename,mscamidt,behavcamidt,timestampname);    

        thresh = determiningFiringEventThresh_SPEC(neuron,'S',threshs);    

        num_of_conditions=length(nameparts);
        num_of_all_individual_conditions=length(neuronIndividuals);

        [conditionfolder,conditionfolder1,conditionfolder2,conditionfolder3,conditionfolder4,conditionfoldercombine,conditionfoldercombinecluster,one_condition_cluster_index]= HDAC_AD_foldername_set(nameparts,num_of_conditions,numparts);  
        [behavcell,smallvelo,behavcellnodata]=HDAC_AD_behavload(behavnamet,num_of_all_individual_conditions,ikk,exp);   
        maxbehavROI=maxposregioncal(behavcell,neuron,neuronIndividuals);%calculate the max movement region for plotting     

        nameset={'ori','mov','upd','nov'};
        objnamecell=objnamedec(behavcell,numparts,nameset);
        special_experiment_objname;

        [headorientationcell,in_use_objects,unique_obj_name_map]=HDAC_AD_headtoobj(behavcell,num_of_all_individual_conditions,ikk,objnamecell,exp,maxbehavROI);

        [neuronIndividuals_new,num2read1,timeindex]=HDAC_AD_merge_individual(neuron,neuronfilename,neuronIndividuals,numparts,num_of_conditions,exp,test5minsign);
        countsaveall=cell(1,length(conditionfolder));%save all count information for combined ploting session

        time_close_to_obj={};

    %% define colormap scale for comparesion and excel data cells
        [colorscale1,colorscale2,colorscale3,colorscale4,colorscale5,colorscale6,colorscale7,colorscale8,colorscale9]= define_colormap(behavcell,timeindex,behavled,neuronIndividuals_new,maxbehavROI,binsize,thresh,countTimeThresh,num_of_conditions,numparts)    
    %% cell generation
        [compexcel,ampcompexcel,ampcompexcel_sp,infoexcel,placecellexcel,placecellindexexcel,cellclusterindexexcel,mouselookobjectfiringexcel,mouselookobjectfiringrateexcel,mouselookobjectamplitudeexcel,mouselookobjectamplituderateexcel,mouselookobjectcounttimeexcel,individualcompexcel,individualcompexcel_all,individualcompexcel_allS,individualcompexcel_all_fc,individualcompexcel_leng,compexcel_ss,compexcel_fc,individualcompexcel_sp,individualcompexcel_fc]=HDAC_AD_excel_cell_generation(nameparts);
    %% start calculating results
        for i=1:num_of_conditions
             if numparts(i)>0
                mkdir(conditionfolder{i});
                mkdir(conditionfolder1{i});
                %% rearrange behav
                [behavpos,behavtime,objects]=HDAC_AD_behavdata_gen(behavcell,timeindex,i,behavled);
                objname=objnamecell(:,i);

                %% yanjun's nn revision: test use 5 min
                if ((exp==13&&i==4)||(exp==14&&i==3))&&test5minsign==5
                   behavpos=behavpos(1:end/2,:);
                   behavtime=behavtime(1:end/2,:);
                end

                %% what we should know is that, (0,0) of count ,countTime and firingrate is left bottom corner , obj left bottom corner (selectObject converted)
                %% and for behav.position, its (0,0) is on left up 
                %% rearrange heading obj     
                if exp==10||exp==12||exp==13||exp==14
                    if_mouse_head_toward_object=[headorientationcell{1,timeindex(i)+1}.if_mouse_head_toward_object(1,:)];
                    for j=timeindex(i)+1:timeindex(i+1)
                        if_mouse_head_toward_object=[if_mouse_head_toward_object;headorientationcell{1,j}.if_mouse_head_toward_object(2:end,:)];
                    end
                end
                %% calculating firing profile
                [firingrate,count,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.C,1),thresh,'C',[],[],countTimeThresh);
                [firingrateS,countS,~,countTimeS] = calculatingCellSpatialForSingleData_Suoqin(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.C,1),[],'S',[],[],countTimeThresh);
                [firingratetr,counttr,~,countTimetr] = calculatingCellSpatialForSingleData_Suoqin(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.C,1),[],'trace',[],[],countTimeThresh);
                [~,~,~,~,amplitude,amplitude_normalized] = calculatingCellSpatialForSingleData_Suoqin(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'C',[],[],countTimeThresh);  %%%bin size suggests to be 15
                [~,~,~,~,amplitudeS,amplitude_normalizedS] = calculatingCellSpatialForSingleData_Suoqin(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'S',[],[],countTimeThresh);  %%%bin size suggests to be 15                    

%                     [firingrate,count,countTime] = calculatingCellSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.C,1),thresh,'C',[],[],countTimeThresh);  %%%bin size suggests to be 15
%                     [firingrateS,countS,countTimeS] = calculatingCellSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.C,1),[],'S',[],[],countTimeThresh);  %%%bin size suggests to be 15
%                     [firingratetr,counttr,countTimetr] = calculatingCellSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.C,1),[],'trace',[],[],countTimeThresh);  %%%bin size suggests to be 15
%                     [amplitude_normalized,amplitude,~] = calculatingCellSpatialForSingleData_adapted_amplitude(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'C',[],[],countTimeThresh);  %%%bin size suggests to be 15
%                     [amplitude_normalizedS,amplitudeS,~] = calculatingCellSpatialForSingleData_adapted_amplitude(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'S',[],[],countTimeThresh);  %%%bin size suggests to be 15                    
% 
                save_single_cell_calculation_result(conditionfolder{i},amplitude_normalized,amplitude,firingrate,count,countTime,firingrateS,countS,countTimeS,amplitude_normalizedS,amplitudeS,objects,behavpos,behavtime,thresh,maxbehavROI,headorientationcell{1,i});                   

                if processingparts(2)==1
                    HDAC_AD_plottingmergedbehavtrajandevents(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,thresh,i,binsize,'C',behavcell,conditionfolder{i});
                    close all;
                end

                countsaveall{1,i}=count;
                %% count event analysis
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
                    compexcel_ss=firing_rate_analysis_single_spike(firingrateS,binsize,countTime,objects,colorscale6,compind,objname,conditionfolder,compexcel_ss,nameset,nameparts,i);
                    compexcel_fc=firing_rate_analysis_first_cross(firingratetr,binsize,countTime,objects,colorscale6,compind,objname,conditionfolder,compexcel_fc,nameset,nameparts,i);
                    close all;
                end
                %% count event analysis single spike
                if processingparts(21)==1
                    compexcel_ss=count_event_analysis_single_spike(countS,binsize,countTime,objects,colorscale5,compind,objname,conditionfolder,compexcel_ss,nameset,nameparts,i);
                    compexcel_fc=count_event_analysis_first_cross(counttr,binsize,countTime,objects,colorscale5,compind,objname,conditionfolder,compexcel_fc,nameset,nameparts,i);
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
                    ampcompexcel=amplitude_analysis(amplitude,amplitude_normalized,binsize,countTime,objects,colorscale4,colorscale8,objname,conditionfolder,nameparts,nameset,num2readt,ampcompexcel,i);
                end
                %% amplitude analysis SINGLE SPIKE
                if processingparts(23)==1
                    ampcompexcel_sp=amplitude_analysis_single_spike(amplitudeS,amplitude_normalizedS,binsize,countTime,objects,colorscale7,colorscale9,objname,conditionfolder,nameparts,nameset,num2readt,ampcompexcel_sp,i);
                end
                %% individual cell amplitude
                if processingparts(8)==1
                    individualcompexcel=individual_cell_amplitude(amplitude,amplitude_normalized,countTime,colorscale4,binsize,objects,compind,objname,nameset,individualcompexcel_leng,individualcompexcel,i);                       
                end
                %% individual cell amplitude single spike
                if processingparts(24)==1
                    individualcompexcel_sp=individual_cell_amplitude(amplitudeS,amplitude_normalizedS,countTime,colorscale7,binsize,objects,compind,objname,nameset,individualcompexcel_leng,individualcompexcel_sp,i);                       
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
                    [placecellexcel,placecellindexexcel,infoexcel,place_cells,Tinfo]=info_score_and_place_cell(neuronIndividuals_new,behavpos,behavtime,maxbehavROI,binsize,countTimeThresh,conditionfolder,conditionfolder1,i,nameparts,thresh,infoexcel,placecellexcel,placecellindexexcel,time_lag_period,Fs_msCam,'C',exp,behavcell{i}.trackLength,small_velo,'neuronIndividuals_new.mat','neuronIndividuals_new');
                    [placecellexcel,placecellindexexcel,infoexcel,place_cells,Tinfo]=info_score_and_place_cell(neuronIndividuals_new,behavpos,behavtime,maxbehavROI,binsize,countTimeThresh,conditionfolder,conditionfolder1,i,nameparts,thresh,infoexcel,placecellexcel,placecellindexexcel,time_lag_period,Fs_msCam,'S',exp,behavcell{i}.trackLength,small_velo,'neuronIndividuals_new.mat','neuronIndividuals_new');
                end
                %% plot individual cells
                if processingparts(1)==1  
                    all_condition_max=150;

%                         load([conditionfolder1{i},'\','place_cells_info_',conditionfolder1{i}(1:end-16),'_binsize',num2str(binsize),'_','C','.mat']);
%                         plottingFiringBehaviorSpatialForSingleData_adapted_1_hmap(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,count,'event',1:size(neuron.C,1),thresh,[],conditionfolder,i,binsize,'C',behavcell,place_cells,countTime,all_condition_max)                        
%                         plottingFiringBehaviorSpatialForSingleData_adapted_1_hmap(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,firingrate,'firingRate',1:size(neuron.C,1),thresh,[],conditionfolder,i,binsize,'C',behavcell,place_cells,countTime,all_condition_max)                        
%                         plottingFiringBehaviorSpatialForSingleData_adapted_1_hmap(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,amplitude,'amplitude',1:size(neuron.C,1),thresh,[],conditionfolder,i,binsize,'C',behavcell,place_cells,countTime,all_condition_max)                        
%                         plottingFiringBehaviorSpatialForSingleData_adapted_1_hmap(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,amplitude_normalized,'amplitude norm',1:size(neuron.C,1),thresh,[],conditionfolder,i,binsize,'C',behavcell,place_cells,countTime,all_condition_max)                        

                    load([conditionfolder1{i},'\','place_cells_info_',conditionfolder1{i}(1:end-16),'_binsize',num2str(binsize),'_','S','.mat']);                        
%                         plottingFiringBehaviorSpatialForSingleData_adapted_1_hmap(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,countS,'event',1:size(neuron.C,1),thresh,[],conditionfolder,i,binsize,'S',behavcell,place_cells,countTime,all_condition_max)
                    plottingFiringBehaviorSpatialForSingleData_adapted_1_hmap(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,firingrateS,'firingRate',1:size(neuron.C,1),thresh,[],conditionfolder,i,binsize,'S',behavcell,place_cells,countTime,all_condition_max)
%                         plottingFiringBehaviorSpatialForSingleData_adapted_1_hmap(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,amplitudeS,'amplitude',1:size(neuron.C,1),thresh,[],conditionfolder,i,binsize,'S',behavcell,place_cells,countTime,all_condition_max)                      
                    plottingFiringBehaviorSpatialForSingleData_adapted_1_hmap(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,amplitude_normalizedS,'amplitude norm',1:size(neuron.C,1),thresh,[],conditionfolder,i,binsize,'S',behavcell,place_cells,countTime,all_condition_max)                      
%                        plottingFiringBehaviorSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,counttr,1:size(neuronIndividuals_new{i}.trace,1),thresh,[],countTime,[],conditionfolder,i,binsize,'trace',behavcell,[],[],firingratetr,'firing rate',place_cells,Tinfo)
%                         plottingFiringBehaviorSpatialForSingleData_adapted_ct(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,count,1:size(neuronIndividuals_new{i}.trace,1),thresh,[],[],[],conditionfolder,i,binsize,'C',behavcell,countTime1,'count time',firingrate,'firing rate',place_cells,TinfoPerSecond)
                    close all;
                end
                %% cluster process
                if processingparts(10)==1
                    cellclusterindexexcel=cluster_process(conditionfolder2,conditionfolder4,thresh,neuron,neuronIndividuals_new,nameparts,i,baseinfoScoreThreshold,num2read1,time_lag_period,Fs_msCam,cellclusterindexexcel,behavpos,behavtime,maxbehavROI,binsize,countTimeThresh, objects,objname,num2readt,num_of_conditions);
                end
                %% cluster process parts
                if processingparts(25)==1
                    cluster_process_part;
                end
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

                if processingparts(26)==1
                    [distance_time_relationship_obj,time_close_to_obj(i,:)]=HDAC_AD_distance_time_relationship(headorientationcell{i},behavpos,in_use_objects,exp,conditionfolder,i,ikk);
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

            %% time close to obj modify
            for cc1=1:size(time_close_to_obj,1)
                for cc2=1:size(time_close_to_obj,2)
                    if isempty(time_close_to_obj{cc1,cc2})
                        time_close_to_obj{cc1,cc2}=0;
                    end
                end
            end
            %% excel
            exname=['neuron_comparingFiringRate_averageinfo_placecell_data_binsize',num2str(binsize),'.xlsx'];

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
            if processingparts(26)==1
            xlswrite(exname,time_close_to_obj,'time_close_to_obj');
            end
            close all
            save('processinginfo.mat','nameparts','foldernamet','behavnamet','timestampnameallt','mscamid','behavcamid','numpartsall','exp1','processingparts','exceld','behavled')
        end    
    end

    if exceld==1
    excelFileName=excelFileNameall{exp};
    final_data_collection_ad_new_streamlined;
    end

