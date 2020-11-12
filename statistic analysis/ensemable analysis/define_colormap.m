function [colorscale1,colorscale2,colorscale3,colorscale4,colorscale5,colorscale6,colorscale7,colorscale8,colorscale9]= define_colormap(behavcell,timeindex,behavled,neuronIndividuals_new,maxbehavROI,binsize,thresh,countTimeThresh,num_of_conditions,numparts)    
       
     for i=1:length(neuronIndividuals_new)
            if numparts(i)>0
            [behavpos,behavtime,objects]=HDAC_AD_behavdata_gen(behavcell,timeindex,i,behavled);
%             [firingrate,count,countTime] = calculatingCellSpatialForSingleData_adapted(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'C',[],[],countTimeThresh);  %%%bin size suggests to be 15
            [firingrate,count,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.C,1),thresh,'C',[],[],countTimeThresh);
            [~,~,~,~,amplitude,amplitude_normalized] = calculatingCellSpatialForSingleData_Suoqin(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'C',[],[],countTimeThresh);  %%%bin size suggests to be 15
            [firingrateS,countS,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.C,1),thresh,'S',[],[],countTimeThresh);
            [~,~,~,~,amplitudeS,amplitude_normalizedS] = calculatingCellSpatialForSingleData_Suoqin(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'S',[],[],countTimeThresh);  %%%bin size suggests to be 15

                %% colormap continue
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,sumFiringRate]=comparingFiringRateSingleConditionMultiObjects(count,binsize,countTime, objects,'events',[],0,0,{});
                [firingRateSmoothing1,sumFiringRateObject1,firingRateSmoothing12,sumFiringRate2]=comparingFiringRateSingleConditionMultiObjects({countTime},binsize,countTime, objects,'events',[],0,0,{});
                [firingRateSmoothing11,sumFiringRateObject112,firingRateSmoothing112,sumFiringRate3]=comparingFiringRateSingleConditionMultiObjects(firingrate,binsize,countTime, objects,'events',[],0,0,{});
                [firingRateSmoothingS]=comparingFiringRateSingleConditionMultiObjects(countS,binsize,countTime, objects,'events',[],0,0,{});
                [firingRateSmoothingSS]=comparingFiringRateSingleConditionMultiObjects(firingrateS,binsize,countTime, objects,'events',[],0,0,{});

                colorscaleminmax1(i,2)=max(firingRateSmoothing2(:));
                colorscaleminmax1(i,1)=min(firingRateSmoothing2(:));
                colorscaleminmax2(i,1)=min(firingRateSmoothing12(:));
                colorscaleminmax2(i,2)=max(firingRateSmoothing12(:));
                colorscaleminmax3(i,1)=min(firingRateSmoothing112(:));
                colorscaleminmax3(i,2)=max(firingRateSmoothing112(:));
                colorscaleminmax5(i,1)=min(firingRateSmoothingS(:));
                colorscaleminmax5(i,2)=max(firingRateSmoothingS(:));
                colorscaleminmax6(i,1)=min(firingRateSmoothingSS(:));
                colorscaleminmax6(i,2)=max(firingRateSmoothingSS(:));
                
%                 [amplitude_normalized,amplitude,countTime1] = calculatingCellSpatialForSingleData_adapted_amplitude(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,'C',[],[],countTimeThresh);  %%%bin size suggests to be 15
                [amplitudeSmoothing,sumamplitudeObject,amplitudeSmoothing2,sumFiringRate4]=comparingFiringRateSingleConditionMultiObjects(amplitude,binsize,countTime, objects,'amplitude',[0,0],0,0,{});
                [amplitudeSmoothingS]=comparingFiringRateSingleConditionMultiObjects(amplitudeS,binsize,countTime, objects,'amplitude',[0,0],0,0,{});
                [amplitudeSmoothingr,sumamplitudeObject,amplitudeSmoothing2,sumFiringRate4]=comparingFiringRateSingleConditionMultiObjects(amplitude_normalized,binsize,countTime, objects,'amplitude',[0,0],0,0,{});
                [amplitudeSmoothingrS]=comparingFiringRateSingleConditionMultiObjects(amplitude_normalizedS,binsize,countTime, objects,'amplitude',[0,0],0,0,{});

                colorscaleminmax4(i,1)=min(amplitudeSmoothing2(:));
                colorscaleminmax4(i,2)=max(amplitudeSmoothing2(:));
                colorscaleminmax7(i,1)=min(amplitudeSmoothingS(:));
                colorscaleminmax7(i,2)=max(amplitudeSmoothingS(:));        
                colorscaleminmax8(i,1)=min(amplitudeSmoothingr(:));
                colorscaleminmax8(i,2)=max(amplitudeSmoothingr(:));     
                colorscaleminmax9(i,1)=min(amplitudeSmoothingrS(:));
                colorscaleminmax9(i,2)=max(amplitudeSmoothingrS(:));                
            end
        end
%         save('neuronIndividuals_tr_up_test_1.mat', 'neuronIndividuals_new', '-v7.3');

        colorscale1=[min(colorscaleminmax1(:,1)) max(colorscaleminmax1(:,2))];
        colorscale2=[min(colorscaleminmax2(:,1)) max(colorscaleminmax2(:,2))];
        colorscale3=[min(colorscaleminmax3(:,1)) max(colorscaleminmax3(:,2))+2];
        colorscale4=[min(colorscaleminmax4(:,1)) max(colorscaleminmax4(:,2))];
        colorscale5=[min(colorscaleminmax5(:,1)) max(colorscaleminmax5(:,2))];
        colorscale6=[min(colorscaleminmax6(:,1)) max(colorscaleminmax6(:,2))];
        colorscale7=[min(colorscaleminmax7(:,1)) max(colorscaleminmax7(:,2))];
        colorscale8=[min(colorscaleminmax8(:,1)) max(colorscaleminmax8(:,2))];
        colorscale9=[min(colorscaleminmax9(:,1)) max(colorscaleminmax9(:,2))];        