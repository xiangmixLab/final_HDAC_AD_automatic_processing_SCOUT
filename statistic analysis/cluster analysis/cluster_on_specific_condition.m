for ip=1:num_of_conditions
    if behavcellnodata(one_condition_cluster_index)==0
        mkdir(conditionfolder3{ip});
        [neuron0,group,colorClusters,CM,dataC,dataSC,b,grouptracecorr,~,groupshift]=dynamicsAnalysisNew_parallel_adapted_022118(thresh,neuron,neuronIndividuals_new,[],[],nameparts,ip,conditionfolder3{ip},baseinfoScoreThreshold,one_condition_cluster_index,num2read1,time_lag_period,Fs_msCam);
%         neuronIndividuals_new=importdata('neuronIndividuals_tr_up_test_1.mat');%the cluster process in the later part will damage this data a little bit, so it needs import
%         neuron=importdata(neuronfilename);

        cellclusterindexexcel{1,ip+num_of_conditions+1}=[nameparts{ip},'_training_based_clusters_intra_correlation'];
        cellclusterindexexcel{1,ip+num_of_conditions*2+1}=[nameparts{ip},'_training_based_clusters_cell_group_shift'];
        for iiiii=1:size(grouptracecorr,1)
            cellclusterindexexcel{iiiii+1,ip+num_of_conditions+1}=grouptracecorr(iiiii,ip);
        end
        for iiiii=1:length(groupshift)
            cellclusterindexexcel{iiiii+1,ip+num_of_conditions*2+1}=groupshift(iiiii);
        end
    end
end