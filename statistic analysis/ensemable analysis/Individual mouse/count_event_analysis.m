            function compexcel=count_event_analysis(count,firingrate,binsize,countTime, objects,colorscale1,compind,objname,conditionfolder,compexcel,nameset,nameparts,num2readt,i)

            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects,~,~,~,sumFiringRateObject_2nd]=comparingFiringRateSingleConditionMultiObjects(count,binsize,countTime, objects,'events',colorscale1,1,compind,objname);
            save([conditionfolder{i},'/','neuron_comparingCountevents_binsize',num2str(binsize),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingrate','count','countTime');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountevents_binsize',num2str(binsize),'.fig'],'fig');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountevents_binsize',num2str(binsize),'.tif'],'tif');
            saveas(gcf,[conditionfolder{i},'/','neuron comparingCountevents_binsize',num2str(binsize),'.eps'],'epsc');

            compexcel{50,15}=[' cell num'];
            compexcel{50,16}=max(size(count,1),size(count,2));
            
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
            
            compexcel{3*i-1+length(nameparts)*3+1,1}=[nameparts{1,i},' sum count sum surrounding'];

            compexcel{3*i-1+length(nameparts)*3+1,2}=sumFiringRateObject_2nd(contains(objname,nameset{1}));
            if isempty(compexcel{3*i-1+length(nameparts)*3+1,2})
                compexcel{3*i-1+length(nameparts)*3+1,2}=0;
            end
            compexcel{3*i-1+length(nameparts)*3+1,3}=sumFiringRateObject_2nd(contains(objname,nameset{2}));
            if isempty(compexcel{3*i-1+length(nameparts)*3+1,3})
                compexcel{3*i-1+length(nameparts)*3+1,3}=0;
            end
            compexcel{3*i-1+length(nameparts)*3+1,4}=sumFiringRateObject_2nd(contains(objname,nameset{3}));
            if isempty(compexcel{3*i-1+length(nameparts)*3+1,4})
                compexcel{3*i-1+length(nameparts)*3+1,4}=0;
            end
            compexcel{3*i-1+length(nameparts)*3+1,5}=sumFiringRateObject_2nd(contains(objname,nameset{4}));
            if isempty(compexcel{3*i-1+length(nameparts)*3+1,5})
                compexcel{3*i-1+length(nameparts)*3+1,5}=0;
            end

            compexcel{3*i-1,6}=sum(firingRateSmoothing(:));
            compexcel{3*i-1,7}=num2readt(i+1);
            compexcel{3*i-1,8}=sum(firingRateSmoothing(:))/num2readt(i+1);%divide time(frame num)
            compexcel{2,10}=binsize;