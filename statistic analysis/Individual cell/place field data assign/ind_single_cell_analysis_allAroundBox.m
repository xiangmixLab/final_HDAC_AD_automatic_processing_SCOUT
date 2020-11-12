            function [individualcompexcel_all,individualcompexcel_all_S,individualcompexcel_all_tr]=ind_single_cell_analysis_allAroundBox(count,binsize,countTime,firingrate,amplitude,amplitude_normalized,countS,countTimeS,firingrateS,amplitudeS,counttr,firingratetr,objects,compind,objname,colorscale1,colorscale2,colorscale3,colorscale4,individualcompexcel_all,individualcompexcel_all_S,individualcompexcel_all_tr,individualcompexcel_leng,i)

            for iiiii=1:length(firingrate)
                individualcompexcel_all{iiiii+2,1}=iiiii;
                individualcompexcel_all_S{iiiii+2,1}=iiiii;
                individualcompexcel_all_tr{iiiii+2,1}=iiiii;
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({count{iiiii}},binsize,countTime, objects,'events',colorscale1,0,compind,objname);
                individualcompexcel_all{iiiii+2,3+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));%actually it is not smoothed
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({countTime},binsize,countTime, objects,'count time',colorscale2,0,compind,objname);
                individualcompexcel_all{iiiii+2,7+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({firingrate{iiiii}},binsize,countTime, objects,'firing rate',colorscale3,0,compind,objname);
                individualcompexcel_all{iiiii+2,11+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));
                % amplitude
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({amplitude{iiiii}},binsize,countTime, objects,'amplitude',colorscale4,0,compind,objname);
                individualcompexcel_all{iiiii+2,13+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));
                % amplitude_normalized_by_count_time
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({amplitude_normalized{iiiii}},binsize,countTime, objects,'amplitude',colorscale4,0,compind,objname);
                individualcompexcel_all{iiiii+2,15+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));

                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({countS{iiiii}},binsize,countTime, objects,'events',colorscale1,0,compind,objname);
                individualcompexcel_all_S{iiiii+2,3+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));%actually it is not smoothed
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({countTime},binsize,countTime, objects,'count time',colorscale2,0,compind,objname);
                individualcompexcel_all_S{iiiii+2,7+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({firingrateS{iiiii}},binsize,countTime, objects,'firing rate',colorscale3,0,compind,objname);
                individualcompexcel_all_S{iiiii+2,11+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({amplitudeS{iiiii}},binsize,countTime, objects,'amplitude',colorscale4,0,compind,objname);
                individualcompexcel_all_S{iiiii+2,13+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));

                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({counttr{iiiii}},binsize,countTime, objects,'events',colorscale1,0,compind,objname);
                individualcompexcel_all_tr{iiiii+2,3+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));%actually it is not smoothed
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({countTime},binsize,countTime, objects,'count time',colorscale2,0,compind,objname);
                individualcompexcel_all_tr{iiiii+2,7+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));
                [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({firingratetr{iiiii}},binsize,countTime, objects,'firing rate',colorscale3,0,compind,objname);
                individualcompexcel_all_tr{iiiii+2,11+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));
                
                
            end
