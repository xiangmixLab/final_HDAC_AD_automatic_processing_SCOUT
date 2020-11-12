%% clustered neuron ensemble analysis
function clustered_neuron_ensemble_analysis(neuron,group,behavpos,behavtime,maxbehavROI,binsize,thresh,countTimeThresh, objects,objname,colorscale1,colorscale2,colorscale3,colorscale4,colorscale5,colorscale6,colorscale7,cfolder)
    
    unique_group=unique(group);
    conditionfolder=[cfolder,'\','cluster_ensemble_analysis'];
    mkdir([cfolder,'\','cluster_ensemble_analysis'])
    for i=1:length(unique_group)
        neuron0=Sources2D;
        neuron0.C=neuron.C(group==unique_group(i),:);
        neuron0.S=neuron.S(group==unique_group(i),:);
        neuron0.time=neuron.time;
        
        [firingrate,count,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuron0,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron0.C,1),thresh,'C',[],[],countTimeThresh);
        [firingrateS,countS,~,countTimeS] = calculatingCellSpatialForSingleData_Suoqin(neuron0,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron0.S,1),[],'S',[],[],countTimeThresh);
        [~,~,~,~,amp,amprate] = calculatingCellSpatialForSingleData_Suoqin(neuron0,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron0.C,1),thresh,'C',[],[],countTimeThresh);  %%%bin size suggests to be 15
        [~,~,~,~,ampS,amprateS] = calculatingCellSpatialForSingleData_Suoqin(neuron0,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron0.C,1),thresh,'S',[],[],countTimeThresh);  %%%bin size suggests to be 15

%         [firingrate,count,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuron0,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron0.C,1),thresh,'C',[],[],countTimeThresh);
%         [amprate,amp,countTime] = calculatingCellSpatialForSingleData_adapted_amplitude(neuron0,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron0.C,1),thresh,'C',[],[],countTimeThresh);
%         [firingrateS,countS,countTimeS] = calculatingCellSpatialForSingleData_adapted(neuron0,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron0.S,1),thresh,'S',[],[],countTimeThresh);

        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(count,binsize,countTime, objects,'events',colorscale1,1,1,objname);
        save([conditionfolder,'/','cluster',num2str(i),'_neuron_comparingCountevents_binsize',num2str(binsize),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrate','count','countTime');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingCountevents_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingCountevents_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingCountevents_binsize',num2str(binsize),'.eps'],'epsc');

        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({countTime},binsize,countTime, objects,'bin time',colorscale2,1,1,objname);
        save([conditionfolder,'/','cluster',num2str(i),'_neuron_comparingCountTime_binsize',num2str(binsize),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrate','count','countTime');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingCountTime_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingCountTime_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingCountTime_binsize',num2str(binsize),'.eps'],'epsc');

        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(firingrate,binsize,countTime, objects,'firing rate',colorscale3,1,1,objname);
        save([conditionfolder,'/','cluster',num2str(i),'_neuron_comparingfiringRate_binsize',num2str(binsize),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrate','count','countTime');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingfiringRate_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingfiringRate_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingfiringRate_binsize',num2str(binsize),'.eps'],'epsc');
        
        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(amp,binsize,countTime, objects,'amplitude',colorscale4,1,1,objname);
        save([conditionfolder,'/','cluster',num2str(i),'_neuron_comparingAmplitude_binsize',num2str(binsize),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrate','count','countTime');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingAmplitude_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingAmplitude_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingAmplitude_binsize',num2str(binsize),'.eps'],'epsc');

        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(amprate,binsize,countTime, objects,'amplitude norm',colorscale4,1,1,objname);
        save([conditionfolder,'/','cluster',num2str(i),'_neuron_comparingAmplitudeRate_binsize',num2str(binsize),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrate','count','countTime');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingAmplitudeRate_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingAmplitudeRate_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingAmplitudeRate_binsize',num2str(binsize),'.eps'],'epsc');

        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(countS,binsize,countTime, objects,'countS',colorscale5,1,1,objname);
        save([conditionfolder,'/','cluster',num2str(i),'_neuron_comparingCountevents_S_binsize',num2str(binsize),'data_S.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrateS','countS','countTime');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingCountevents_S_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingCountevents_S_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingCountevents_S_binsize',num2str(binsize),'.eps'],'epsc');

        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(firingrateS,binsize,countTime, objects,'firing rate S',colorscale6,1,1,objname);
        save([conditionfolder,'/','cluster',num2str(i),'_neuron_comparingfiringRate_S_binsize',num2str(binsize),'data_S.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrateS','countS','countTime');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingfiringRate_S_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingfiringRate_S_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingfiringRate_S_binsize',num2str(binsize),'.eps'],'epsc');
    
        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(ampS,binsize,countTime, objects,'amplitudeS',colorscale4/5,1,1,objname);
        save([conditionfolder,'/','cluster',num2str(i),'_neuron_comparingAmplitude_S_binsize',num2str(binsize),'data_S.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrateS','countS','countTime');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingAmplitude_S_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingAmplitude_S_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingAmplitude_S_binsize',num2str(binsize),'.eps'],'epsc');

        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(amprateS,binsize,countTime, objects,'amp rate S',colorscale4/5,1,1,objname);
        save([conditionfolder,'/','cluster',num2str(i),'_neuron_comparingAmplitudeRate_S_binsize',num2str(binsize),'data_S.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrateS','countS','countTime');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingAmplitudeRate_S_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingAmplitudeRate_S_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[conditionfolder,'/','cluster',num2str(i),'_neuron comparingAmplitudeRate_S_binsize',num2str(binsize),'.eps'],'epsc');

    end