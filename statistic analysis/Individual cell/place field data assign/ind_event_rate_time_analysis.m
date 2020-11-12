  function  individualcompexcel=ind_event_rate_time_analysis(count,countTime,firingrate,binsize,objects,colorscale1,colorscale2,colorscale3,compind,objname,nameset,individualcompexcel_leng,individualcompexcel,i)            

  for iiiii=1:length(firingrate)
            individualcompexcel{iiiii+2,1}=iiiii;

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
  end
