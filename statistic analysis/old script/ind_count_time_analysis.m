            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({countTime},binsize,countTime, objects,'count time',colorscale2,0,compind,objname);
            individualcompexcel{iiiii+2,7+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(individualcompexcel{iiiii+2,7+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,7+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,8+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(individualcompexcel{iiiii+2,8+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,8+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,9+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(individualcompexcel{iiiii+2,9+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,9+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,10+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(individualcompexcel{iiiii+2,10+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,10+individualcompexcel_leng*(i-1)}=0;
            end