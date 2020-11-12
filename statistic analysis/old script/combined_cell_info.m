            mkdir(conditionfoldercombine);
            if behavcellnodata==0||ikk~=8
            neuronconcatenated = concatenateMUltiConditionNeuronData_adapted(neuron,maxbehavROI,maxbehavROI,neuronIndividuals,[],[],[]);
            [behavposc,behavtimec,objects]=HDAC_AD_behavdata_gen(behavcell,timeindex,i,behavled);

%             orientation2object1={};
%             
%                 
%                 for j=1:length(behavcell)
%                     if ~isempty(behavcell{1,j})
%                         for i002=1:size(headorientationcell{1,j}.if_mouse_head_toward_object,2)
%                             orientation2object1{1,i002}=[orientation2object1{1,i002}; headorientationcell{1,j}.if_mouse_head_toward_object(2:end,i002)];
%                         end
%                     end
%                 end


            behavcellc=behavcell{1};
            behavcellc.position=behavposc;
            behavcellc.time=behavtimec;

            %plot single cell firing change across conditions
            plottingFiringBehaviorSpatialForCombinedData_adapted(neuronconcatenated,neuronIndividuals_new,behavposc,behavtimec,behavcell,maxbehavROI,countsaveall,1:size(neuronconcatenated.trace,1),thresh,threshSpatial,conditionfoldercombine,binsize,nameparts,placecellindexexcel,'C',timeindex(2:end))
            close;
            %calculating info-score
            [firingrateAll,countAll,countTime] = calculatingCellSpatialForSingleData_adapted(neuronconcatenated,behavposc,behavtimec,maxbehavROI,binsize,1:size(neuronconcatenated.trace,1),thresh,'C');  %%%bin size suggests to be 15
            close all;
            MeanFiringRateAll=zeros(size(firingrateAll,2),1);
            for ii=1:size(firingrateAll,2)
                MeanFiringRateAll(ii,1)= sum(sum(countAll{1,ii}))/sum(sum(countTime));
            end

            [infoPerSecond, infoPerSpike] = comparisonSpatialInfo_adapt(firingrateAll, countTime,1);
            save(['spatialInfoScore_',conditionfoldercombine(1:end-16),'_binsize',num2str(binsize),'.mat'],'infoPerSecond','infoPerSpike');
            saveas(gcf,[conditionfoldercombine,'/','neuron infoscore_binsize',num2str(binsize),'.fig'],'fig');
            saveas(gcf,[conditionfoldercombine,'/','neuron infoscore_binsize',num2str(binsize),'.tif'],'tif');
            saveas(gcf,[conditionfoldercombine,'/','neuron infoscore_binsize',num2str(binsize),'.eps'],'tif');


            infoexcel{5,1}='total neuron profile';
            infoexcel{5,2}=mean(infoPerSecond);
            if isnan(infoexcel{5,2})
               infoexcel{5,2}='NaN';
            end
            infoexcel{5,3}=mean(infoPerSpike);
            if isnan(infoexcel{5,3})
               infoexcel{5,3}='NaN';
            end   

            thresh1 = determiningFiringEventThresh(neuronconcatenated,'C'); %determine the neuron firing threshold
            occThresh = 1; nboot = 100;
            % randomly generate the dealt t for permuting the spikes
            deltaTall = randi([10,round(max(neuronconcatenated.time)/1000)],nboot,1)*1000; % unit: ms
            % deltaTall = randi([20,880],nboot,1)*1000;

            [place_cells,TinfoPerSecond,infoScoreThreshold,h11,hv,infoScore_debug] = permutingSpike_adapt(1,neuronconcatenated,behavposc,behavtimec,maxbehavROI,thresh1,deltaTall,occThresh,nboot,binsize,0,1,'C');

            infoScore=[infoPerSecond, infoPerSpike];
            save(['place_cells_info_',conditionfoldercombine(1:end-16),'_binsize',num2str(binsize),'.mat'], 'place_cells', 'TinfoPerSecond', 'infoScore','infoScoreThreshold');
            saveas(gcf,[conditionfoldercombine,'/','neuron placement cells distribution_binsize',num2str(binsize),'.fig'],'fig');
            saveas(gcf,[conditionfoldercombine,'/','neuron placement cells distribution_binsize',num2str(binsize),'.tif'],'tif');
            saveas(gcf,[conditionfoldercombine,'/','neuron placement cells distribution_binsize',num2str(binsize),'.eps'],'epsc');

            mkdir(conditionfoldercombinecluster);
            neuronconcatenated.num2read=neuronconcatenated.num2read(1);
            [neuron0 ,groupc,colorClusters,CM,dataC,dataSC,b]=dynamicsAnalysisNew_parallel_adapted_022118(thresh,neuronconcatenated,{neuronconcatenated},infoScore,{behavcellc},conditionfoldercombinecluster,1,conditionfoldercombinecluster,baseinfoScoreThreshold,0,num2read1);    

            cellclusterindexexcel{1,num_of_conditions*3+2}=[conditionfoldercombinecluster,'_clusters'];
            for iiiii=1:length(groupc)
                cellclusterindexexcel{iiiii+1,num_of_conditions*3+2}=groupc(iiiii);
            end

            else
                pairwisecorr=cell(2,length(DC));
                for i03=1:length(DC)
                    pairwisecorr{1,i03}=nameparts{i03};
                end
                infoexcel{5,1}='total neuron profile';

            end

            % all neuron intra_correlation figure & data
            DE = zeros(1,2);
            DC = zeros(1,length(neuronIndividuals_new));
            for i02 = 1:1
                for k = 1:length(neuronIndividuals_new)
                    d = pdist(neuronIndividuals_new{k}.C,'correlation');
                    d(isnan(d))=[];
                    DC(i02,k) = mean(1-d(:));
                end
            end
            figure;
            b = bar(DC,'FaceColor','flat');
            set(gca,'XtickLabel',{'baseline','training','test'},'FontName','Arial','FontSize',10);
            ylabel('Avg pairwise correlations','FontSize',10)
            title('Avg pairwise correlations')

            saveas(gcf,['Avg pairwise correlations','.fig'],'fig');
            saveas(gcf,['Avg pairwise correlations','.tif'],'tif');
            saveas(gcf,['Avg pairwise correlations','.eps'],'epsc');

            pairwisecorr=cell(2,length(DC));
            for i03=1:length(DC)
                pairwisecorr{1,i03}=nameparts{i03};
                pairwisecorr{2,i03}=DC(i03);
            end
