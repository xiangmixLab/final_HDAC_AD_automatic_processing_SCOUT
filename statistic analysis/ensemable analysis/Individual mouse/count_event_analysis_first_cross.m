            function compexcel=count_event_analysis_first_cross(count,binsize,countTime,objects,colorscale1,compind,objname,conditionfolder,compexcel,nameset,nameparts,i)
            
            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(count,binsize,countTime, objects,'events',colorscale1,1,compind,objname);
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountevent_first_cross_binsize',num2str(binsize),'.fig'],'fig');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountevent_first_cross_binsize',num2str(binsize),'.tif'],'tif');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountevent_first_cross_binsize',num2str(binsize),'.eps'],'epsc');


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
 compexcel{2,10}=binsize;