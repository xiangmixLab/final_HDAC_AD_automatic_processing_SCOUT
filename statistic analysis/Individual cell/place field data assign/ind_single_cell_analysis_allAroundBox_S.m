            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({countS{iiiii}},binsize,countTime, objects,'events',colorscale1,0,compind,objname);
            individualcompexcel_all_S{iiiii+2,3+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));%actually it is not smoothed
            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({countTimeS},binsize,countTime, objects,'count time',colorscale2,0,compind,objname);
            individualcompexcel_all_S{iiiii+2,7+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));
            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({firingrateS{iiiii}},binsize,countTime, objects,'firing rate',colorscale3,0,compind,objname);
            individualcompexcel_all_S{iiiii+2,11+individualcompexcel_leng*(i-1)}=sum(firingRateSmoothing(:));

