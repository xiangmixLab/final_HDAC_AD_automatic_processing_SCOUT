function cellclusterindexexcel=cluster_process(conditionfolder2,conditionfolder4,thresh,neuron,neuronIndividuals_new,nameparts,i,baseinfoScoreThreshold,num2read1,time_lag_period,Fs_msCam,cellclusterindexexcel,behavpos,behavtime,maxbehavROI,binsize,countTimeThresh, objects,objname,num2readt,num_of_conditions)
                % if behavcellnodata~=1
                mkdir(conditionfolder2{i});
                mkdir(conditionfolder4{i});
%                 if ~isempty(num2readt)
%                     neuron.num2read=num2readt;
%                 end
%                 current cluster range: 1 - 
%                 [neuron0,groupall{i},colorClusters,CM,dataC,dataSC,b,~,uniform_score,~,dis_mat]=dynamicsAnalysisNew_parallel_adapted_022118(thresh,neuron,neuronIndividuals_new,[],[],nameparts,i,conditionfolder2{i},baseinfoScoreThreshold,0,num2read1,time_lag_period,Fs_msCam);
                [group{i},~,~,~,~,~,~,uniform_score,~,dis_mat]=dynamicsAnalysisNew_parallel_adapted_040519(neuron,neuronIndividuals_new,nameparts,i,conditionfolder2{i},0,num2read1);
%                 neuronIndividuals_new=importdata('neuronIndividuals_new.mat');%the cluster process in the later part will damage this data a little bit, so it needs import
%                 neuron=importdata(neuronfilename);
               
                cellclusterindexexcel{1,i+1}=[nameparts{1,i},'_cell_clusters'];
                for iiiii=1:length(group{i})
                    cellclusterindexexcel{iiiii+1,1}=iiiii;
                    cellclusterindexexcel{iiiii+1,i+1}=group{i}(iiiii);
                end
                cellclusterindexexcel{1,i+3*num_of_conditions+1}=[nameparts{1,i},'_heatmap_uniform_score_kl'];               
                cellclusterindexexcel{iiiii+1,i+3*num_of_conditions+1}=uniform_score(1);
                cellclusterindexexcel{1,i+3*num_of_conditions+4}=[nameparts{1,i},'_heatmap_uniform_score_intra-inter ratio'];               
                cellclusterindexexcel{iiiii+1,i+3*num_of_conditions+4}=uniform_score(2);
                cellclusterindexexcel{1,i+3*num_of_conditions+7}=[nameparts{1,i},'_intragroup_distance'];               
                cellclusterindexexcel{iiiii+1,i+3*num_of_conditions+7}=mean(cell2mat(dis_mat(:,1)));
                cellclusterindexexcel{1,i+3*num_of_conditions+10}=[nameparts{1,i},'_intergroup_distance'];               
                cellclusterindexexcel{iiiii+1,i+3*num_of_conditions+10}=mean(cell2mat(dis_mat(:,2)));   
%                 
                load([conditionfolder2{i},'\','variables_clustering_0.35PC.mat']);
                clustered_neuron_ensemble_analysis(neuronIndividuals_new{i},group{i},behavpos,behavtime,maxbehavROI,binsize,thresh,countTimeThresh, objects,objname,[0 8],[0 8],[0 10],[0 300],[0 100],[0 0.5],[0 0.5],conditionfolder2{i})

                close all;
