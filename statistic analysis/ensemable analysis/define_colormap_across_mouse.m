        for i=1:num_of_conditions
            if numparts(i)>0
                %% colormap continue
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,sumFiringRate]=comparingFiringRateSingleConditionMultiObjects(count_all_m_all_c(:,i)',binsize,countTime, objects,'events',[0 0],0,0,objname);
                [firingRateSmoothing1,sumFiringRateObject1,firingRateSmoothing12,sumFiringRate2]=comparingFiringRateSingleConditionMultiObjects(countT_all_m_all_c(:,i)',binsize,countTime, objects,'events',[0 0],0,0,objname);
                [firingRateSmoothing11,sumFiringRateObject112,firingRateSmoothing112,sumFiringRate3]=comparingFiringRateSingleConditionMultiObjects(firingr_all_m_all_c(:,i)',binsize,countTime, objects,'events',[0 0],0,0,objname);
                colorscaleminmax1(i,2)=max(sumFiringRate(:));
                colorscaleminmax1(i,1)=min(sumFiringRate(:));
                colorscaleminmax2(i,1)=min(sumFiringRate2(:));
                colorscaleminmax2(i,2)=max(sumFiringRate2(:));
                colorscaleminmax3(i,1)=min(sumFiringRate3(:));
                colorscaleminmax3(i,2)=max(sumFiringRate3(:));
                
                [amplitudeSmoothing,sumamplitudeObject,amplitudeSmoothing2,sumFiringRate4]=comparingFiringRateSingleConditionMultiObjects(amplitude_all_m_all_c(:,i)',binsize,countTime1, objects,'amplitude',[0,0],0,0,objname);
                colorscaleminmax4(i,1)=min(sumFiringRate4(:));
                colorscaleminmax4(i,2)=max(sumFiringRate4(:));
            end
        end
        save('neuronIndividuals_tr_up_test_1.mat', 'neuronIndividuals_new', '-v7.3');

        colorscale1=[min(colorscaleminmax1(:,1)) max(colorscaleminmax1(:,2))];
        colorscale2=[min(colorscaleminmax2(:,1)) max(colorscaleminmax2(:,2))];
        colorscale3=[min(colorscaleminmax3(:,1)) max(colorscaleminmax3(:,2))];
        colorscale4=[min(colorscaleminmax4(:,1)) max(colorscaleminmax4(:,2))];