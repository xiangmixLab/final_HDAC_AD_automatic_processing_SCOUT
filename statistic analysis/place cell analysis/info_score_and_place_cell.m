            %%%"trace" now is the first cross position, not the original one
            %%%"trace" now is the first cross position, not the original one
            %%%"trace" now is the first cross position, not the original one
            function [placecellexcel,placecellindexexcel,infoexcel,place_cells,Tinfo]=info_score_and_place_cell(neuronIndividuals_new,behavpos,behavtime,maxbehavROI,binsize,countTimeThresh,conditionfolder,conditionfolder1,i,nameparts,thresh,infoexcel,placecellexcel,placecellindexexcel,time_lag_period,Fs_msCam,temp,exp,tracklength,small_velo,nfilename,varname)
            
            [firingrateAll,countAll,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.S,1),thresh,temp,[],[],[0.1 inf],small_velo);
           
            %061019 after smoothing we can get something like place field
%             for tk=1:length(firingrateAll)
%                 if ~isempty(firingrateAll{tk})
%                     firingrateAll{tk}=filter2DMatrices(firingrateAll{tk}, 1);
%                 end
%             end
            close all;
            
            %%Calculate mean firing rate for all neurons
            MeanFiringRateAll=zeros(size(firingrateAll,2),1);
            for ii=1:size(firingrateAll,2)
                MeanFiringRateAll(ii,1)= sum(sum(countAll{1,ii}))/sum(sum(countTime));
            end
            
            %%Calculate the info score
            [infoPerSecond, infoPerSpike] = comparisonSpatialInfo_adapt(firingrateAll, countAll, countTime,0.1,conditionfolder1{i},binsize);
            

            infoexcel{i+1,1}=conditionfolder{i}(1:findstr(conditionfolder{i},'_results')-1);
            infoexcel{i+1,2}=mean(infoPerSecond);
            if isnan(infoexcel{i+1,2})
               infoexcel{i+1,2}='NaN';
            end
            infoexcel{i+1,3}=mean(infoPerSpike);
            if isnan(infoexcel{i+1,3})
               infoexcel{i+1,3}='NaN';
            end   

            %% id place cell
%             thresh1 = determiningFiringEventThresh(neuronIndividuals_new{i},'S'); %determine the neuron firing threshold
%             occThresh = 0.2;% less than 0.2 sec will be get rid off
%             occThresh = 0.1;% less than 1 sec will be get rid off
%             nboot = 100;
            % randomly generate the dealt t for permuting the spikes
%             deltaTall = randi([10,round(max(neuronIndividuals_new{i}.time)/1000)],nboot,1)*1000; % unit: ms
%             deltaTall = randi([10,590],nboot,1)*1000; % unit: ms
           
%             [place_cells,Tinfo] = permutingSpike_ori(neuron,behav,thresh,deltaTall,occThresh,nboot);
%             [place_cells,Tinfo,infoScoreThreshold,h11,hv,infoScore_debug] = permutingSpike_adapt(i,neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,thresh,deltaTall,occThresh,nboot,binsize,[],i,temp,time_lag_period,Fs_msCam,conditionfolder1{i});
%             [place_cells,Tinfo,infoScoreThreshold,h11,hv,infoScore_debug] = permutingSpike_adapt_ori(i,neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,thresh,deltaTall,occThresh,nboot,binsize,conditionfolder1{i});
            %             if i==1%all condition will use the info Score Threshold of the first condition
%                 baseinfoScoreThreshold=infoScoreThreshold;
%             end
            [place_cells,infoScoreThreshold,infoScoreSecondboot, infoScoreSpikeboot,infoScoreSecond, infoScoreSpike,Tinfo] = permutingSpike_adapt_051719(nfilename,i,neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,thresh,temp,[],[],[],binsize,[],[],'spk',conditionfolder1,small_velo,varname);
            infoScore=[infoPerSecond, infoPerSpike];
            
            placecellexcel{i+1,1}=conditionfolder{i}(1:findstr(conditionfolder{i},'_results')-1);
            placecellexcel{i+1,2}=infoScoreThreshold;
            if isnan(placecellexcel{i+1,2})
               placecellexcel{i+1,2}='NaN';
            end
            placecellexcel{i+1,3}=length(place_cells);
            if isnan(placecellexcel{i+1,3})
               placecellexcel{i+1,3}='NaN';
            end   
            placecellexcel{i+1,4}=length(place_cells)/length(Tinfo.neuron);
            if isnan(placecellexcel{i+1,4})
               placecellexcel{i+1,4}='NaN';
            end   

            placecellindexexcel{1,i+1}=[nameparts{1,i},'_place_cells'];
            for iiiii=1:length(Tinfo.neuron)
                placecellindexexcel{iiiii+1,1}=iiiii;
                if sum(double(place_cells(place_cells==iiiii)))>0
                    placecellindexexcel{iiiii+1,i+1}=1;
                else
                    placecellindexexcel{iiiii+1,i+1}=0;
                end
            end
            placecellindexexcel{1,i+4}=[nameparts{1,i},'_info_score'];
            for iiiii=1:length(Tinfo.neuron)
                placecellindexexcel{iiiii+1,i+4}=Tinfo.infoScore(Tinfo.neuron==iiiii);
            end