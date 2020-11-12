            function compexcel=count_time_analysis(countTime,binsize,objects,colorscale2,compind,objname,conditionfolder,compexcel,nameset,nameparts,i)

            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({countTime},binsize,countTime, objects,'count time',colorscale2,1,compind,objname);
            save([conditionfolder{i},'/','neuron_comparingCountTime_binsize',num2str(binsize),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','countTime');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountingtime_binsize',num2str(binsize),'.fig'],'fig');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountingtime_binsize',num2str(binsize),'.tif'],'tif');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountingtime_binsize',num2str(binsize),'.eps'],'epsc');

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