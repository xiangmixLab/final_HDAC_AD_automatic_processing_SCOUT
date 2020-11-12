function neuron_all=get_all_neurons(folderName,neuronName)

neuron_all={};
for i=1:length(folderName)
    load([folderName{i},'\',neuronName]);
    for j=1:length(neuronIndividuals_new)
        neuron_all{i,j}=neuronIndividuals_new{j}.copy;
    end
end