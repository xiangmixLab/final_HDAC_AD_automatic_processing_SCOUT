%% HDAC AD common processing script

clear all;clc

nameparts_hdac_ad;
foldername_hdac_ad;
behavname_hdac_ad;
timestamp_hdac_ad;
camid_hdac_ad;
numpart_hdac_ad;
num2read_hdac_ad;


% namepartst=nameparts_ad_old;
% foldernamet=foldernamead;
% behavnamet=behavnamead;
% timestampnameallt=timestampnamead;
% mscamid=mscamidad;
% behavcamid=behavcamidad;
% numpartsall=numpartad;
% num2readall=num2readad;

% 
% namepartst=namepartsall_sc;
% foldernamet=foldernamead_sc;
% behavnamet=behavnamead3batch_sc;
% timestampnameallt=timestampnamead3batch_sc;
% mscamid=mscamidad3batch_sc;
% behavcamid=behavcamidad3batch_sc;
% numpartsall=numpartad3batch_sc;
% num2readall=num2readad3batch_sc;

% namepartst=namepartsall;
% foldernamet=foldernamead3batch;
% behavnamet=behavnamead3batch;
% timestampnameallt=timestampnamead3batch;
% mscamid=mscamidad3batch;
% behavcamid=behavcamidad3batch;
% numpartsall=numpartad3batch2;
% num2readall=num2readad3batch;
% 
% namepartst=nameparts_hdac;
% foldernamet=foldernamehdac_virus_b1;
% behavnamet=behavnamehdac_virus_b1;
% timestampnameallt=timestampnamehdac_virus_b1;
% mscamid=mscamidhdac_virus_b1;
% behavcamid=behavcamidhdac_virus_b1;
% numpartsall=numparthdac_virus_b1;
% num2readall=num2readhdac_virus_b1;

% namepartst=nameparts_hdac;
% foldernamet=foldernamehdac_virus_b2;
% behavnamet=behavnamehdac_virus_b2;
% timestampnameallt=timestampnamehdac_virus_b2;
% mscamid=mscamidhdac_virus_b2;
% behavcamid=behavcamidhdac_virus_b2;
% numpartsall=numparthdac_virus_b2;
% num2readall=num2readhdac_virus_b2;



threshSpatial=5; %when plotting using neuron.S, 1 is enough; using trace, 5 maybe
behavled='red';

for ikk=[4:9]    
    
    [neuron,neuronfilename]=read_neuron_data(ikk,foldernamet,2);
    [mscamidt,behavcamidt,numparts,nameparts,timestampname,num2readt,baseinfoScoreThreshold,colorscale1,colorscale2,colorscale3]=HDAC_AD_paramset(mscamid,behavcamid,numpartsall,timestampnameallt,num2readall,namepartst,ikk);    
   
    if ~isempty(num2readt)
        neuron.num2read=num2readt;
    end
    
    
    neuronIndividuals = splittingMUltiConditionNeuronData_adapted_automatic(neuron,neuronfilename,mscamidt,behavcamidt,timestampname);    
    thresh = determiningFiringEventThresh(neuron,'C');    
    
    num_of_conditions=length(nameparts);
    num_of_all_individual_conditions=length(neuronIndividuals);
    
    [conditionfolder,conditionfolder1,conditionfolder2,conditionfolder3,conditionfoldercombine,conditionfoldercombinecluster,trainingindex]= HDAC_AD_foldername_set(nameparts,num_of_conditions,numparts);  
    [behavcell,headorientationcell,smallvelo,behavcellnodata]=HDAC_AD_behavload(behavnamet,num_of_all_individual_conditions,ikk);   
%     [behavcell,neuronIndividuals,headorientationcell]=HDAC_AD_clear_small_velo_points(neuronIndividuals,behavcell,headorientationcell,smallvelo);   
    maxbehavROI=maxposregioncal(behavcell,neuron,neuronIndividuals);%calculate the max movement region for plotting     
    
%     nameset={'1','2','2','2'};
    nameset={'ori','mov','upd','nov'};
    objnamecell=objnamedec(behavcell,numparts,nameset);
    [neuronIndividuals_new,num2read1,timeindex]=HDAC_AD_merge_individual(neuron,neuronfilename,neuronIndividuals,numparts,num_of_conditions);
    
    colorscaleminmax1=zeros(num_of_conditions,2);%search all three/two conditions,find the overall min and max;
    colorscaleminmax2=zeros(num_of_conditions,2);%search all three/two conditions,find the overall min and max;
    colorscaleminmax3=zeros(num_of_conditions,2);%search all three/two conditions,find the overall min and max;
    countsaveall=cell(1,length(conditionfolder));%save all count information for combined ploting session

%% result generation
    for binsize=15
    %% define colormap scale for comparesion and excel data cells
        for i=1:num_of_conditions
            if ~isempty(behavcell{i})
                
                [behavpos,behavtime,objects]=HDAC_AD_behavdata_gen(behavcell,timeindex,i,behavled);
                objname=objnamecell(:,i);
                [compexcel,ampcompexcel,infoexcel,placecellexcel,placecellindexexcel,cellclusterindexexcel,mouselookobjectfiringexcel,mouselookobjectfiringrateexcel,individualcompexcel]=HDAC_AD_excel_cell_generation(nameparts);

                [firingrate,count,countTime] = calculatingCellSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'C');  %%%bin size suggests to be 15
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2]=comparingFiringRateSingleConditionMultiObjects(count,binsize,countTime, objects,'events',colorscale1,0,0,objname);
                [firingRateSmoothing1,sumFiringRateObject1,firingRateSmoothing12]=comparingFiringRateSingleConditionMultiObjects({countTime},binsize,countTime, objects,'events',colorscale2,0,0,objname);
                [firingRateSmoothing11,sumFiringRateObject112,firingRateSmoothing112]=comparingFiringRateSingleConditionMultiObjects(firingrate,binsize,countTime, objects,'events',colorscale3,0,0,objname);
                colorscaleminmax1(i,2)=max(firingRateSmoothing2(:));
                colorscaleminmax1(i,1)=min(firingRateSmoothing2(:));
                colorscaleminmax2(i,1)=min(firingRateSmoothing12(:));
                colorscaleminmax2(i,2)=max(firingRateSmoothing12(:));
                colorscaleminmax3(i,1)=min(firingRateSmoothing112(:));
                colorscaleminmax3(i,2)=max(firingRateSmoothing112(:));
            end
        end
        save('neuronIndividuals_tr_up_test_1.mat', 'neuronIndividuals_new', '-v7.3');

        colorscale1=[min(colorscaleminmax1(:,1)) max(colorscaleminmax1(:,2))];
        colorscale2=[min(colorscaleminmax2(:,1)) max(colorscaleminmax2(:,2))];
        colorscale3=[min(colorscaleminmax3(:,1)) max(colorscaleminmax3(:,2))];

        %% start calculating results
        for i=1:num_of_conditions
            if ~isempty(behavcell{i})
            mkdir(conditionfolder{i});
            mkdir(conditionfolder1{i});

            %% rearrange behav
            [behavpos,behavtime,objects]=HDAC_AD_behavdata_gen(behavcell,timeindex,i,behavled);
            objname=objnamecell(:,i);

            %% rearrange heading obj
            if_mouse_head_toward_object=[headorientationcell{1,timeindex(i)+1}.if_mouse_head_toward_object(1,:)];
            for j=timeindex(i)+1:timeindex(i+1)
                if_mouse_head_toward_object=[if_mouse_head_toward_object;headorientationcell{1,j}.if_mouse_head_toward_object(2:end,:)];
            end

            %% compind
            compind=1;

            %% comparsion and individual plot
            %%calculating firing profile
            [firingrate,count,countTime] = calculatingCellSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'C');  %%%bin size suggests to be 15
           
            %%plot individual{i} movement trace w/ firing events, color coded actvity maps 
            plottingFiringBehaviorSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,count,1:size(neuronIndividuals_new{i}.trace,1),thresh,threshSpatial,conditionfolder,i,binsize,'C',behavcell)
            close all;
            
            HDAC_AD_plottingmergedbehavtrajandevents(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,thresh,i,binsize,'C',behavcell);
            saveas(gcf,[conditionfolder{i},'/','trajectoryFiringEvent.fig'],'fig');
            saveas(gcf,[conditionfolder{i},'/','trajectoryFiringEvent.tif'],'tif');
            saveas(gcf,[conditionfolder{i},'/','trajectoryFiringEvent.eps'],'eps');
            close all;
            
            countsaveall{1,i}=count;
            %%calculating comparsion between objects
            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(count,binsize,countTime, objects,'events',colorscale1,1,compind,objname);
            save([conditionfolder{i},'/','neuron_comparingCountevents_binsize',num2str(binsize),'_average_radius',num2str(radius),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrate','count','countTime');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountevents_binsize',num2str(binsize),'_average_radius',num2str(radius),'.fig'],'fig');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountevents_binsize',num2str(binsize),'_average_radius',num2str(radius),'.tif'],'tif');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountevents_binsize',num2str(binsize),'_average_radius',num2str(radius),'.eps'],'eps');

            compexcel{3*i-1,1}=[nameparts{1,i},' sum count'];

            compexcel{3*i-1,2}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(compexcel{3*i-1,2})
                compexcel{3*i-1,2}=0;
            end
            compexcel{3*i-1,3}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(compexcel{3*i-1,3})
                compexcel{3*i-1,3}=0;
            end
            compexcel{3*i-1,4}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(compexcel{3*i-1,4})
                compexcel{3*i-1,4}=0;
            end
            compexcel{3*i-1,5}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(compexcel{3*i-1,5})
                compexcel{3*i-1,5}=0;
            end

            compexcel{3*i-1,6}=sum(firingRateSmoothing(:));
            compexcel{3*i-1,7}=neuron.num2read(i+1);
            compexcel{3*i-1,8}=sum(firingRateSmoothing(:))/neuron.num2read(i+1);%divide time(frame num)
            compexcel{2,10}=binsize;
            close all;

            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({countTime},binsize,countTime, objects,'count time',colorscale2,1,compind,objname);
            save([conditionfolder{i},'/','neuron_comparingCountingtime_binsize',num2str(binsize),'_average_radius',num2str(radius),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrate','count','countTime');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountingtime_binsize',num2str(binsize),'_average_radius',num2str(radius),'.fig'],'fig');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountingtime_binsize',num2str(binsize),'_average_radius',num2str(radius),'.tif'],'tif');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountingtime_binsize',num2str(binsize),'_average_radius',num2str(radius),'.eps'],'eps');

            compexcel{3*i,1}=[nameparts{1,i},' sum count Time'];

            compexcel{3*i,2}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(compexcel{3*i,2})
                compexcel{3*i,2}=0;
            end
            compexcel{3*i,3}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(compexcel{3*i,3})
                compexcel{3*i,3}=0;
            end
            compexcel{3*i,4}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(compexcel{3*i,4})
                compexcel{3*i,4}=0;
            end
            compexcel{3*i,5}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(compexcel{3*i,5})
                compexcel{3*i,5}=0;
            end
            close all;

            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(firingrate,binsize,countTime, objects,'firing rate',colorscale3,1,compind,objname);
            save([conditionfolder{i},'/','neuron_comparingfiringRate_binsize',num2str(binsize),'_average_radius',num2str(radius),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrate','count','countTime');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingfiringRate_binsize',num2str(binsize),'_average_radius',num2str(radius),'.fig'],'fig');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingfiringRate_binsize',num2str(binsize),'_average_radius',num2str(radius),'.tif'],'tif');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingfiringRate_binsize',num2str(binsize),'_average_radius',num2str(radius),'.eps'],'eps');

            compexcel{3*i+1,1}=[nameparts{1,i},' sum firing rate'];

            compexcel{3*i+1,2}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(compexcel{3*i+1,2})
                compexcel{3*i+1,2}=0;
            end
            compexcel{3*i+1,3}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(compexcel{3*i+1,3})
                compexcel{3*i+1,3}=0;
            end
            compexcel{3*i+1,4}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(compexcel{3*i+1,4})
                compexcel{3*i+1,4}=0;
            end
            compexcel{3*i+1,5}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(compexcel{3*i+1,5})
                compexcel{3*i+1,5}=0;
            end

            close all;

            %% comparsion, individual cells
            for iiiii=1:length(firingrate)
            individualcompexcel{iiiii+2,1}=iiiii;
            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({count{iiiii}},binsize,countTime, objects,'events',colorscale1,0,compind,objname);
            individualcompexcel{iiiii+2,3+14*(i-1)}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(individualcompexcel{iiiii+2,3+14*(i-1)})
                individualcompexcel{iiiii+2,3+14*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,4+14*(i-1)}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(individualcompexcel{iiiii+2,4+14*(i-1)})
                individualcompexcel{iiiii+2,4+14*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,5+14*(i-1)}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(individualcompexcel{iiiii+2,5+14*(i-1)})
                individualcompexcel{iiiii+2,5+14*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,6+14*(i-1)}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(individualcompexcel{iiiii+2,6+14*(i-1)})
                individualcompexcel{iiiii+2,6+14*(i-1)}=0;
            end

            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({countTime},binsize,countTime, objects,'count time',colorscale2,0,compind,objname);
            individualcompexcel{iiiii+2,7+14*(i-1)}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(individualcompexcel{iiiii+2,7+14*(i-1)})
                individualcompexcel{iiiii+2,7+14*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,8+14*(i-1)}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(individualcompexcel{iiiii+2,8+14*(i-1)})
                individualcompexcel{iiiii+2,8+14*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,9+14*(i-1)}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(individualcompexcel{iiiii+2,9+14*(i-1)})
                individualcompexcel{iiiii+2,9+14*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,10+14*(i-1)}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(individualcompexcel{iiiii+2,10+14*(i-1)})
                individualcompexcel{iiiii+2,10+14*(i-1)}=0;
            end

            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(firingrate,binsize,countTime, objects,'firing rate',colorscale3,0,compind,objname);
            individualcompexcel{iiiii+2,11+14*(i-1)}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(individualcompexcel{iiiii+2,3+14*(i-1)})
                individualcompexcel{iiiii+2,11+14*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,12+14*(i-1)}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(individualcompexcel{iiiii+2,12+14*(i-1)})
                individualcompexcel{iiiii+2,12+14*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,13+14*(i-1)}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(individualcompexcel{iiiii+2,13+14*(i-1)})
                individualcompexcel{iiiii+2,13+14*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,14+14*(i-1)}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(individualcompexcel{iiiii+2,14+14*(i-1)})
                individualcompexcel{iiiii+2,14+14*(i-1)}=0';
            end
            end
            
            %% amplitude analysis
            [amplitude_normalized,amplitude,countTime1] = calculatingCellSpatialForSingleData_adapted_amplitude(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'C');  %%%bin size suggests to be 15
            [amplitudeSmoothing,sumamplitudeObject,amplitudeSmoothing2,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(amplitude,binsize,countTime1, objects,'amplitude',[0,0],1,compind,objname);
            saveas(gcf,[conditionfolder{i},'/','neuron comparingAmplitude_binsize',num2str(binsize),'_average_radius',num2str(radius),'.fig'],'fig');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingAmplitude_binsize',num2str(binsize),'_average_radius',num2str(radius),'.tif'],'tif');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingAmplitude_binsize',num2str(binsize),'_average_radius',num2str(radius),'.eps'],'eps');

            ampcompexcel{3*i-1,1}=[nameparts{1,i},' sum amplitude'];
            ampcompexcel{3*i-1,2}=sumamplitudeObject(contains(objname,nameset{1}));
            if isempty(ampcompexcel{3*i-1,2})
                ampcompexcel{3*i-1,2}=0;
            end
            ampcompexcel{3*i-1,3}=sumamplitudeObject(contains(objname,nameset{2}));
            if isempty(ampcompexcel{3*i-1,3})
                ampcompexcel{3*i-1,3}=0;
            end
            ampcompexcel{3*i-1,4}=sumamplitudeObject(contains(objname,nameset{3}));
            if isempty(ampcompexcel{3*i-1,4})
                ampcompexcel{3*i-1,4}=0;
            end
            ampcompexcel{3*i-1,5}=sumamplitudeObject(contains(objname,nameset{4}));
            if isempty(ampcompexcel{3*i-1,5})
                ampcompexcel{3*i-1,5}=0;
            end

            ampcompexcel{3*i-1,6}=sum(amplitudeSmoothing(:));
            ampcompexcel{3*i-1,7}=neuron.num2read(i+1);
            ampcompexcel{3*i-1,8}=sum(amplitudeSmoothing(:))/neuron.num2read(i+1);%divide time(frame num)
            ampcompexcel{2,10}=binsize;
            close all;

%             %% info-score part
%             [firingrateAll,countAll,countTime] = calculatingCellSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'C');  %%%bin size suggests to be 15
%             close all;
%             %%Calculate mean firing rate for all neurons
%             MeanFiringRateAll=zeros(size(firingrateAll,2),1);
%             for ii=1:size(firingrateAll,2)
%                 MeanFiringRateAll(ii,1)= sum(sum(countAll{1,ii}))/sum(sum(countTime));
%             end
%             %%Calculate the info score
%             [infoPerSecond, infoPerSpike] = comparisonSpatialInfo_adapt(firingrateAll, countTime,1);
%             save(['spatialInfoScore_',conditionfolder1{i}(1:end-16),'_binsize',num2str(binsize),'.mat'],'infoPerSecond','infoPerSpike');
%             saveas(gcf,[conditionfolder1{i},'/','neuron infoscore_binsize',num2str(binsize),'.fig'],'fig');
%             saveas(gcf,[conditionfolder1{i},'/','neuron infoscore_binsize',num2str(binsize),'.tif'],'tif');
%             saveas(gcf,[conditionfolder1{i},'/','neuron infoscore_binsize',num2str(binsize),'.eps'],'eps');
% 
%             infoexcel{i+1,1}=conditionfolder{i}(1:findstr(conditionfolder{i},'_results')-1);
%             infoexcel{i+1,2}=mean(infoPerSecond);
%             if isnan(infoexcel{i+1,2})
%                infoexcel{i+1,2}='NaN';
%             end
%             infoexcel{i+1,3}=mean(infoPerSpike);
%             if isnan(infoexcel{i+1,3})
%                infoexcel{i+1,3}='NaN';
%             end   
% 
%             %% id place cell
%             thresh1 = determiningFiringEventThresh(neuronIndividuals_new{i},'C'); %determine the neuron firing threshold
%             occThresh = 1; nboot = 100;
%             % randomly generate the dealt t for permuting the spikes
%             deltaTall = randi([10,round(max(neuronIndividuals_new{i}.time)/1000)],nboot,1)*1000; % unit: ms
%             [place_cells,TinfoPerSecond,infoScoreThreshold,h11,hv,infoScore_debug] = permutingSpike_adapt(i,neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,thresh1,deltaTall,occThresh,nboot,binsize,baseinfoScoreThreshold,i,'C');
%             if i==1%all condition will use the info Score Threshold of the first condition
%                 baseinfoScoreThreshold=infoScoreThreshold;
%             end
%             infoScore=[infoPerSecond, infoPerSpike];
%             save(['place_cells_info_',conditionfolder1{i}(1:end-16),'_binsize',num2str(binsize),'.mat'], 'place_cells', 'TinfoPerSecond', 'infoScore','infoScoreThreshold');
%             saveas(gcf,[conditionfolder1{i},'/','neuron placement cells distribution_binsize',num2str(binsize),'.fig'],'fig');
%             saveas(gcf,[conditionfolder1{i},'/','neuron placement cells distribution_binsize',num2str(binsize),'.tif'],'tif');
%             saveas(gcf,[conditionfolder1{i},'/','neuron placement cells distribution_binsize',num2str(binsize),'.eps'],'eps');
% 
%             placecellexcel{i+1,1}=conditionfolder{i}(1:findstr(conditionfolder{i},'_results')-1);
%             placecellexcel{i+1,2}=infoScoreThreshold;
%             if isnan(placecellexcel{i+1,2})
%                placecellexcel{i+1,2}='NaN';
%             end
%             placecellexcel{i+1,3}=length(place_cells);
%             if isnan(placecellexcel{i+1,3})
%                placecellexcel{i+1,3}='NaN';
%             end   
%             placecellexcel{i+1,4}=length(place_cells)/length(TinfoPerSecond.neuron);
%             if isnan(placecellexcel{i+1,4})
%                placecellexcel{i+1,4}='NaN';
%             end   
% 
%             placecellindexexcel{1,i+1}=[nameparts{1,i},'_place_cells'];
%             for iiiii=1:length(TinfoPerSecond.neuron)
%                 placecellindexexcel{iiiii+1,1}=iiiii;
%                 if sum(double(place_cells(place_cells==iiiii)))>0
%                     placecellindexexcel{iiiii+1,i+1}=1;
%                 else
%                     placecellindexexcel{iiiii+1,i+1}=0;
%                 end
%             end
%             %% cluster process
%             if behavcellnodata~=1
%                 mkdir(conditionfolder2{i});
%                 [neuron0,groupall{i},colorClusters,CM,dataC,dataSC,b]=dynamicsAnalysisNew_parallel_adapted_022118(thresh,neuron,neuronIndividuals_new,infoScore,[],nameparts,i,conditionfolder2{i},baseinfoScoreThreshold,0);
%                 neuronIndividuals_new=importdata('neuronIndividuals_tr_up_test_1.mat');%the cluster process in the later part will damage this data a little bit, so it needs import
%                 neuron=importdata(neuronfilename);
% 
%                 cellclusterindexexcel{1,i+1}=[nameparts{1,i},'_cell_clusters'];
%                 for iiiii=1:length(groupall{i})
%                     cellclusterindexexcel{iiiii+1,1}=iiiii;
%                     cellclusterindexexcel{iiiii+1,i+1}=groupall{i}(iiiii);
%                 end
%             end
%             close all;
           
            %% travelling wave cross correlation
%             wavelagtime=determinewavecorrgroup(neuron,groupall{i});
%             save([conditionfolder2{i},'/','inter_group_cross_corr_lag_time.mat'],'wavelagtime');
            %% mouse head to object individual cell plotting
            if sum(objects)~=0
                if numparts(1)==0
                    kk=1;
                else
                    kk=0;
                end
                
                for i001=1:size(objects,1)
                    [firingratemouob,countmouob1,countTimemouob1] = calculatingCellSpatialForSingleData_adapted_mouob(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'C',if_mouse_head_toward_object(:,i001));  %%%bin size suggests to be 15
                    for iiiii=1:length(countmouob1)
                        mouselookobjectfiringexcel{iiiii+1,1}=iiiii;

                        ct=count{iiiii};
                        if isempty(ct)
                            ct=zeros(size(countTime));
                        end
                        ct(isnan(ct)) = 0;
                        ct(ct==inf) = 0;
                        cellcountconv=conv2(ct,ones(5),'same');
                        posObjects=ceil(behavcell{1,timeindex(i)+1}.object./binsize);
% %                         cellcountobj=zeros(1,4);
                        for i221 = 1:size(posObjects,1)
                            if isequal(objname{i221,1},nameset{1})
                                cellcountobj =cellcountconv(posObjects(i221,2),posObjects(i221,1));
                                mouselookobjectfiringexcel{iiiii+1,5*(i-1+kk)+3+1-1}=sum(sum(countmouob1{iiiii}))+cellcountobj;%we already indicate the obj nearby points in behav files so no need to add them again
                            end
                            if isequal(objname{i221,1},nameset{2})
                                cellcountobj =cellcountconv(posObjects(i221,2),posObjects(i221,1));
                                mouselookobjectfiringexcel{iiiii+1,5*(i-1+kk)+3+2-1}=sum(sum(countmouob1{iiiii}))+cellcountobj;%we already indicate the obj nearby points in behav files so no need to add them again
                            end
                            if isequal(objname{i221,1},nameset{3})
                                cellcountobj =cellcountconv(posObjects(i221,2),posObjects(i221,1));
                                mouselookobjectfiringexcel{iiiii+1,5*(i-1+kk)+3+3-1}=sum(sum(countmouob1{iiiii}))+cellcountobj;%we already indicate the obj nearby points in behav files so no need to add them again
                            end
                            if isequal(objname{i221,1},nameset{4})
                                cellcountobj =cellcountconv(posObjects(i221,2),posObjects(i221,1));
                                mouselookobjectfiringexcel{iiiii+1,5*(i-1+kk)+3+4-1}=sum(sum(countmouob1{iiiii}))+cellcountobj;%we already indicate the obj nearby points in behav files so no need to add them again
                            end                      
                        end

                        mouselookobjectfiringrateexcel{iiiii+1,1}=iiiii;
                        ct=firingrate{iiiii};
                        if isempty(ct)
                            ct=zeros(size(countTime));
                        end
                        ct(isnan(ct)) = 0;
                        ct(ct==inf) = 0;
                        cellcountconvr=conv2(ct,ones(5),'same');
                        posObjects=ceil(behavcell{1,timeindex(i)+1}.object./binsize);
%                         cellcountobjr=zeros(1,4);
%                         for i221 = 1:size(posObjects,1)
%                             cellcountobjr(1,i221) =cellcountconvr(size(cellcountconvr,1)-posObjects(i221,2)+1,posObjects(i221,1));
%                         end
                        rateobj1=countmouob1{iiiii}./countTimemouob1;
                        rateobj1(isnan(rateobj1))=0;
                        rateobj1(rateobj1==inf)=0;
                        for i221 = 1:size(posObjects,1)
                            if isequal(objname{i001,1},nameset{1})
                                cellcountobjr =cellcountconvr(posObjects(i221,2),posObjects(i221,1));
                                mouselookobjectfiringrateexcel{iiiii+1,5*(i-1+kk)+3+1-1}=sum(sum(rateobj1))+cellcountobjr;%we already indicate the obj nearby points in behav files so no need to add them again
                            end
                            if isequal(objname{i001,1},nameset{2})
                                cellcountobjr =cellcountconvr(posObjects(i221,2),posObjects(i221,1));
                                mouselookobjectfiringrateexcel{iiiii+1,5*(i-1+kk)+3+2-1}=sum(sum(rateobj1))+cellcountobjr;%we already indicate the obj nearby points in behav files so no need to add them again
                            end
                            if isequal(objname{i001,1},nameset{3})
                                cellcountobjr =cellcountconvr(posObjects(i221,2),posObjects(i221,1));
                                mouselookobjectfiringrateexcel{iiiii+1,5*(i-1+kk)+3+3-1}=sum(sum(rateobj1))+cellcountobjr;%we already indicate the obj nearby points in behav files so no need to add them again
                            end
                            if isequal(objname{i001,1},nameset{4})
                                cellcountobjr =cellcountconvr(posObjects(i221,2),posObjects(i221,1));
                                mouselookobjectfiringrateexcel{iiiii+1,5*(i-1+kk)+3+4-1}=sum(sum(rateobj1))+cellcountobjr;%we already indicate the obj nearby points in behav files so no need to add them again
                            end                     
                        end
                        
                    end
                end
            end
            %% show mouse head direction to object points
            if sum(objects)~=0
                figure;
                plot(behavpos(:,1),behavpos(:,2));
                hold on 
                color1={'.r','.b','.g','.m'};
                for i001=1:size(objects,1)
                    plot(behavpos(if_mouse_head_toward_object(:,i001)==1,1),behavpos(if_mouse_head_toward_object(:,i001)==1,2),color1{i001},'MarkerSize',20);
                    posObjects=ceil(behavcell{1,timeindex(i)+1}.object./binsize)*binsize;
%                      neuronCactivity=sum(neuronIndividuals_new{i}.C>thresh,1)>0;
                    if sum(posObjects)~=0
                        objectrange=((behavpos(:,1)-posObjects(i001,1)).^2+(behavpos(:,2)-posObjects(i001,2)).^2).^0.5<15;
                        plot(behavpos(if_mouse_head_toward_object(:,i001)==1,1),behavpos(if_mouse_head_toward_object(:,i001)==1,2),color1{i001},'MarkerSize',20);
                        plot(behavpos(objectrange,1),behavpos(objectrange,2),color1{i001},'MarkerSize',75);
                        scatter(posObjects(i001,1),posObjects(i001,2)+1,binsize*5,'k','filled')
%                         text(posObjects(i001,1),posObjects(i001,2)-5,[num2str(i001)]);
                    end

                    plot(0,0);
                    title('Positions mouse look at objects');
                    saveas(gcf,[conditionfolder{i},'/','mouse_head_to_object_loc',num2str(binsize),'.fig'],'fig');
                    saveas(gcf,[conditionfolder{i},'/','mouse_head_to_object_loc',num2str(binsize),'.tif'],'tif');
                    saveas(gcf,[conditionfolder{i},'/','mouse_head_to_object_loc',num2str(binsize),'.eps'],'eps');
                end
            end
            end
        end
%         %% cluster only on training
%             for ip=1:num_of_conditions
%                 if behavcellnodata~=1
%                     mkdir(conditionfolder3{ip});
%                     [neuron0,group,colorClusters,CM,dataC,dataSC,b,grouptracecorr,groupshift]=dynamicsAnalysisNew_parallel_adapted_022118(thresh,neuron,neuronIndividuals_new,infoScore,[],nameparts,ip,conditionfolder3{ip},baseinfoScoreThreshold,trainingindex);
%                     neuronIndividuals_new=importdata('neuronIndividuals_tr_up_test_1.mat');%the cluster process in the later part will damage this data a little bit, so it needs import
%                     neuron=importdata(neuronfilename);
% 
%                     cellclusterindexexcel{1,ip+num_of_conditions+1}=[nameparts{ip},'_training_based_clusters_intra_correlation'];
%                     cellclusterindexexcel{1,ip+num_of_conditions*2+1}=[nameparts{ip},'_training_based_clusters_cell_group_shift'];
%                     for iiiii=1:size(grouptracecorr,1)
%                         cellclusterindexexcel{iiiii+1,ip+num_of_conditions+1}=grouptracecorr(iiiii,ip);
%                     end
%                     for iiiii=1:length(groupshift)
%                         cellclusterindexexcel{iiiii+1,ip+num_of_conditions*2+1}=groupshift(iiiii);
%                     end
%                 end
%             end
% 
% 
%         % combined set place cell info
%             mkdir(conditionfoldercombine);
%             if behavcellnodata==0
%             neuronconcatenated = concatenateMUltiConditionNeuronData_adapted(neuron,maxbehavROI,maxbehavROI,neuronIndividuals,[],[],[]);
%             [behavposc,behavtimec,objects]=HDAC_AD_behavdata_gen(behavcell,timeindex,i,behavled);
% 
% %             orientation2object1={};
% %             
% %                 
% %                 for j=1:length(behavcell)
% %                     if ~isempty(behavcell{1,j})
% %                         for i002=1:size(headorientationcell{1,j}.if_mouse_head_toward_object,2)
% %                             orientation2object1{1,i002}=[orientation2object1{1,i002}; headorientationcell{1,j}.if_mouse_head_toward_object(2:end,i002)];
% %                         end
% %                     end
% %                 end
% 
% 
%             behavcellc=behavcell{1};
%             behavcellc.position=behavposc;
%             behavcellc.time=behavtimec;
% 
%             %plot single cell firing change across conditions
%             plottingFiringBehaviorSpatialForCombinedData_adapted(neuronconcatenated,neuronIndividuals_new,behavposc,behavtimec,behavcell,maxbehavROI,countsaveall,1:size(neuronconcatenated.trace,1),thresh,threshSpatial,conditionfoldercombine,binsize,nameparts,placecellindexexcel,'C',timeindex(2:end))
%             close;
%             %calculating info-score
%             [firingrateAll,countAll,countTime] = calculatingCellSpatialForSingleData_adapted(neuronconcatenated,behavposc,behavtimec,maxbehavROI,binsize,1:size(neuronconcatenated.trace,1),thresh,'C');  %%%bin size suggests to be 15
%             close all;
%             MeanFiringRateAll=zeros(size(firingrateAll,2),1);
%             for ii=1:size(firingrateAll,2)
%                 MeanFiringRateAll(ii,1)= sum(sum(countAll{1,ii}))/sum(sum(countTime));
%             end
% 
%             [infoPerSecond, infoPerSpike] = comparisonSpatialInfo_adapt(firingrateAll, countTime,1);
%             save(['spatialInfoScore_',conditionfoldercombine(1:end-16),'_binsize',num2str(binsize),'.mat'],'infoPerSecond','infoPerSpike');
%             saveas(gcf,[conditionfoldercombine,'/','neuron infoscore_binsize',num2str(binsize),'.fig'],'fig');
%             saveas(gcf,[conditionfoldercombine,'/','neuron infoscore_binsize',num2str(binsize),'.tif'],'tif');
%             saveas(gcf,[conditionfoldercombine,'/','neuron infoscore_binsize',num2str(binsize),'.eps'],'tif');
% 
% 
%             infoexcel{5,1}='total neuron profile';
%             infoexcel{5,2}=mean(infoPerSecond);
%             if isnan(infoexcel{5,2})
%                infoexcel{5,2}='NaN';
%             end
%             infoexcel{5,3}=mean(infoPerSpike);
%             if isnan(infoexcel{5,3})
%                infoexcel{5,3}='NaN';
%             end   
% 
%             thresh1 = determiningFiringEventThresh(neuronconcatenated,'C'); %determine the neuron firing threshold
%             occThresh = 1; nboot = 100;
%             % randomly generate the dealt t for permuting the spikes
%             deltaTall = randi([10,round(max(neuronconcatenated.time)/1000)],nboot,1)*1000; % unit: ms
%             % deltaTall = randi([20,880],nboot,1)*1000;
% 
%             [place_cells,TinfoPerSecond,infoScoreThreshold,h11,hv,infoScore_debug] = permutingSpike_adapt(1,neuronconcatenated,behavposc,behavtimec,maxbehavROI,thresh1,deltaTall,occThresh,nboot,binsize,0,1,'C');
% 
%             infoScore=[infoPerSecond, infoPerSpike];
%             save(['place_cells_info_',conditionfoldercombine(1:end-16),'_binsize',num2str(binsize),'.mat'], 'place_cells', 'TinfoPerSecond', 'infoScore','infoScoreThreshold');
%             saveas(gcf,[conditionfoldercombine,'/','neuron placement cells distribution_binsize',num2str(binsize),'.fig'],'fig');
%             saveas(gcf,[conditionfoldercombine,'/','neuron placement cells distribution_binsize',num2str(binsize),'.tif'],'tif');
%             saveas(gcf,[conditionfoldercombine,'/','neuron placement cells distribution_binsize',num2str(binsize),'.eps'],'eps');
% 
%             mkdir(conditionfoldercombinecluster);
%             neuronconcatenated.num2read=neuronconcatenated.num2read(1);
%             [neuron0,groupc,colorClusters,CM,dataC,dataSC,b]=dynamicsAnalysisNew_parallel_adapted_022118(thresh,neuronconcatenated,{neuronconcatenated},infoScore,{behavcellc},conditionfoldercombinecluster,1,conditionfoldercombinecluster,baseinfoScoreThreshold,0);    
% 
%             cellclusterindexexcel{1,num_of_conditions*3+2}=[conditionfoldercombinecluster,'_clusters'];
%             for iiiii=1:length(groupc)
%                 cellclusterindexexcel{iiiii+1,num_of_conditions*3+2}=groupc(iiiii);
%             end
% 
%             else
%                 pairwisecorr=cell(2,length(DC));
%                 for i03=1:length(DC)
%                     pairwisecorr{1,i03}=nameparts{i03};
%                 end
%                 infoexcel{5,1}='total neuron profile';
% 
%             end
% 
%             % all neuron intra_correlation figure & data
%             DE = zeros(1,2);
%             DC = zeros(1,length(neuronIndividuals_new));
%             for i02 = 1:1
%                 for k = 1:length(neuronIndividuals_new)
%                     d = pdist(neuronIndividuals_new{k}.C,'correlation');
%                     d(isnan(d))=[];
%                     DC(i02,k) = mean(1-d(:));
%                 end
%             end
%             figure;
%             b = bar(DC,'FaceColor','flat');
%             set(gca,'XtickLabel',{'baseline','training','test'},'FontName','Arial','FontSize',10);
%             ylabel('Avg pairwise correlations','FontSize',10)
%             title('Avg pairwise correlations')
% 
%             saveas(gcf,['Avg pairwise correlations','.fig'],'fig');
%             saveas(gcf,['Avg pairwise correlations','.tif'],'tif');
%             saveas(gcf,['Avg pairwise correlations','.eps'],'eps');
% 
%             pairwisecorr=cell(2,length(DC));
%             for i03=1:length(DC)
%                 pairwisecorr{1,i03}=nameparts{i03};
%                 pairwisecorr{2,i03}=DC(i03);
%             end

            %% excel
            exname=['neuron_comparingFiringRate_averageinfo_placecell_data_binsize',num2str(binsize),'.xlsx'];

%             delete(exname)

            xlswrite(exname,compexcel,'comparsion_objects');
            xlswrite(exname,individualcompexcel,'comparsion_objects_cells');
            xlswrite(exname,ampcompexcel,'amplitude_comparsion_objects');
%             xlswrite(exname,infoexcel,'info');
%             xlswrite(exname,placecellexcel,'place_cells');
%             xlswrite(exname,placecellindexexcel,'place_cell_index');
%             xlswrite(exname,cellclusterindexexcel,'cell_cluster');
            xlswrite(exname,mouselookobjectfiringexcel,'mouselookobject_firing_count');
            xlswrite(exname,mouselookobjectfiringrateexcel,'mouselookobject_firing_rate');
%             xlswrite(exname,pairwisecorr,'pairwise_correlation');
            close all;
        % 

     end
end
