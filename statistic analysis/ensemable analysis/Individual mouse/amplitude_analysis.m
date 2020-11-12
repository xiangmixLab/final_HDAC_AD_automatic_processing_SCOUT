            function ampcompexcel=amplitude_analysis(amplitude,amplitude_normalized,binsize,countTime,objects,colorscale4,colorscale8,objname,conditionfolder,nameparts,nameset,num2readt,ampcompexcel,i)
            [amplitudeSmoothing,sumamplitudeObject,amplitudeSmoothing2,~,radius,posObjects,~,~,~,sumamplitudeObject_2nd]=comparingFiringRateSingleConditionMultiObjects(amplitude,binsize,countTime, objects,'amplitude',colorscale4,1,1,objname);
            saveas(gcf,[conditionfolder{i},'/','neuron comparingAmplitude_binsize',num2str(binsize),'.fig'],'fig');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingAmplitude_binsize',num2str(binsize),'.tif'],'tif');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingAmplitude_binsize',num2str(binsize),'.eps'],'epsc');
            [amplitudeSmoothing_n,sumamplitudeObject_n,amplitudeSmoothing2_n,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects(amplitude_normalized,binsize,countTime, objects,'amplitude norm',colorscale8,1,1,objname);
            saveas(gcf,[conditionfolder{i},'/','neuron comparingAmplitudeNormalized_binsize',num2str(binsize),'.fig'],'fig');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingAmplitudeNormalized_binsize',num2str(binsize),'.tif'],'tif');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingAmplitudeNormalized_binsize',num2str(binsize),'.eps'],'epsc');

            save([conditionfolder{i},'/','neuron_comparingAmplitude_binsize',num2str(binsize),'data.mat'],'amplitudeSmoothing','sumamplitudeObject','radius','posObjects','countTime');
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
            
            ampcompexcel{3*i,1}=[nameparts{1,i},' sum norm amplitude'];
            ampcompexcel{3*i,2}=sumamplitudeObject_n(contains(objname,nameset{1}));
            if isempty(ampcompexcel{3*i,2})
                ampcompexcel{3*i,2}=0;
            end
            ampcompexcel{3*i,3}=sumamplitudeObject_n(contains(objname,nameset{2}));
            if isempty(ampcompexcel{3*i,3})
                ampcompexcel{3*i,3}=0;
            end
            ampcompexcel{3*i,4}=sumamplitudeObject_n(contains(objname,nameset{3}));
            if isempty(ampcompexcel{3*i,4})
                ampcompexcel{3*i,4}=0;
            end
            ampcompexcel{3*i,5}=sumamplitudeObject_n(contains(objname,nameset{4}));
            if isempty(ampcompexcel{3*i,5})
                ampcompexcel{3*i,5}=0;
            end
            
            ampcompexcel{3*i+1,1}=[nameparts{1,i},' sum amplitude sum surround'];
            ampcompexcel{3*i+1,2}=sumamplitudeObject_2nd(contains(objname,nameset{1}));
            if isempty(ampcompexcel{3*i+1,2})
                ampcompexcel{3*i+1,2}=0;
            end
            ampcompexcel{3*i+1,3}=sumamplitudeObject_2nd(contains(objname,nameset{2}));
            if isempty(ampcompexcel{3*i+1,3})
                ampcompexcel{3*i+1,3}=0;
            end
            ampcompexcel{3*i+1,4}=sumamplitudeObject_2nd(contains(objname,nameset{3}));
            if isempty(ampcompexcel{3*i+1,4})
                ampcompexcel{3*i+1,4}=0;
            end
            ampcompexcel{3*i+1,5}=sumamplitudeObject_2nd(contains(objname,nameset{4}));
            if isempty(ampcompexcel{3*i+1,5})
                ampcompexcel{3*i+1,5}=0;
            end

            ampcompexcel{3*i-1,6}=sum(amplitudeSmoothing(:));
            ampcompexcel{3*i-1,7}=num2readt(i+1);
            ampcompexcel{3*i-1,8}=sum(amplitudeSmoothing(:))/num2readt(i+1);%divide time(frame num)
            ampcompexcel{2,10}=binsize;
            close all;