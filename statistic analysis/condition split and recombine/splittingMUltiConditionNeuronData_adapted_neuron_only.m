function neuronIndividuals = splittingMUltiConditionNeuronData_adapted_neuron_only(neuron)
neuronIndividuals = cell(1,length(neuron.num2read)-1);
%     [FileName,PathName,FilterIndex] = uigetfile('.mat','select neuron data');

for i = 2:length(neuron.num2read)
    i
    neuron0 = neuron.copy;
    neuron0.num2read=neuron.num2read;
    if i == 2
        start = 1;
    else
        start = sum(neuron0.num2read(2:i-1))+1;
    end
    neuronIndividuals{i-1} = neuron0;
    neuronIndividuals{i-1}.C = neuron0.C(:,start:sum(neuron0.num2read(2:i)));
    neuronIndividuals{i-1}.C_raw = neuron0.C_raw(:,start:sum(neuron0.num2read(2:i)));
%     neuronIndividuals{i-1}.C_df = neuron0.C_df(:,start:sum(neuron0.num2read(2:i)));
    neuronIndividuals{i-1}.S = neuron0.S(:,start:sum(neuron0.num2read(2:i)));
    neuronIndividuals{i-1}.trace = neuron0.trace(:,start:sum(neuron0.num2read(2:i)));
    neuronIndividuals{i-1}.num2read = neuron0.num2read(i);
end
