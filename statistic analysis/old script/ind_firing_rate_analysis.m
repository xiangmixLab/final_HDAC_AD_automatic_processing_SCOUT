            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({firingrate{iiiii}},binsize,countTime, objects,'firing rate',colorscale3,0,compind,objname);
            individualcompexcel{iiiii+2,11+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(individualcompexcel{iiiii+2,3+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,11+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,12+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(individualcompexcel{iiiii+2,12+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,12+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,13+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(individualcompexcel{iiiii+2,13+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,13+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,14+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(individualcompexcel{iiiii+2,14+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,14+individualcompexcel_leng*(i-1)}=0';
            end

%             