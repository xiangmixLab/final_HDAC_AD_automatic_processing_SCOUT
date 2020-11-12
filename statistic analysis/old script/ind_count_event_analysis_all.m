            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({count{iiiii}},binsize,countTime, objects,'events',colorscale1,0,compind,objname);
            individualcompexcel{iiiii+2,3+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(individualcompexcel{iiiii+2,3+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,3+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,4+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(individualcompexcel{iiiii+2,4+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,4+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,5+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(individualcompexcel{iiiii+2,5+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,5+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,6+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(individualcompexcel{iiiii+2,6+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,6+individualcompexcel_leng*(i-1)}=0;
            end
