            
   function individualcompexcel=individual_cell_amplitude(amplitude,amplitude_normalized,countTime,colorscale4,binsize,objects,compind,objname,nameset,individualcompexcel_leng,individualcompexcel,i)   

            for iiiii=1:length(amplitude)
            % amplitude
            if ~isempty(amplitude{iiiii})
            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({amplitude{iiiii}},binsize,countTime, objects,'amplitude',colorscale4,0,compind,objname);
            individualcompexcel{iiiii+2,15+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(individualcompexcel{iiiii+2,15+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,15+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,16+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(individualcompexcel{iiiii+2,16+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,16+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,17+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(individualcompexcel{iiiii+2,17+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,17+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,18+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(individualcompexcel{iiiii+2,18+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,18+individualcompexcel_leng*(i-1)}=0';
            end
            end
            % amplitude_normalized_by_count_time
            if ~isempty(amplitude_normalized{iiiii})
            [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects]=comparingFiringRateSingleConditionMultiObjects({amplitude_normalized{iiiii}},binsize,countTime, objects,'amplitude',colorscale4,0,compind,objname);
            individualcompexcel{iiiii+2,19+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(individualcompexcel{iiiii+2,19+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,19+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,20+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(individualcompexcel{iiiii+2,20+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,20+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,21+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(individualcompexcel{iiiii+2,21+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,21+individualcompexcel_leng*(i-1)}=0;
            end
            individualcompexcel{iiiii+2,22+individualcompexcel_leng*(i-1)}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(individualcompexcel{iiiii+2,22+individualcompexcel_leng*(i-1)})
                individualcompexcel{iiiii+2,22+individualcompexcel_leng*(i-1)}=0';
            end
            end
            end
