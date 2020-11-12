function cluster_ensemble_activity_standalone(conditionfolder2,group,thresh,neuronIndividuals_new,i,behavpos,behavtime,maxbehavROI,binsize,countTimeThresh, objects,objname)
    clustered_neuron_ensemble_analysis(neuronIndividuals_new{i},group,behavpos,behavtime,maxbehavROI,binsize,thresh,countTimeThresh, objects,objname,[0 8],[0 8],[0 10],[0 300],[0 100],[0 0.5],[0 0.5],conditionfolder2)
    close all;
