for i=10
load(['./Single/',files{i},'single']);
neuron1=neuron;
neuron1.options=links{1}.options;

load(['./Double/',files{i},'double']);
neuron2=neuron;
full_neuron=combine_neurons_after_extraction(neuron1,neuron2,3,.5,[141,315],true);
neuron=full_neuron;
save(['./CombinedExtraction/neuron',num2str(i)],'neuron')
end