function neuronboot=neuron_shuffle_yj(neuron,time0,S0,trace0,C0,thresh,deltaT)
    neuron.time = time0; 
    neuron.S = S0; 
    neuron.C = C0;
    neuron.trace = trace0;
    neuronboot = neuron.copy;
    timeboot = (1:length(neuronboot.time)) + deltaT;
    idx = timeboot > length(neuronboot.time);
    timeboot(idx) = timeboot(idx) - length(neuronboot.time);
    [~,index] = sort(timeboot);
    neuronboot.S = neuronboot.S(:,index);
    neuronboot.trace = neuronboot.trace(:,index);
    neuronboot.C = neuronboot.C(:,index);
%     timeboot = (1:length(neuronboot.time)) + deltaT; % timeboot calculation from YJ after sfn2019 (10/28/19)
%     idx = timeboot > length(neuronboot.time);
%     timeboot(idx) = timeboot(idx) - length(neuronboot.time);
%     [~,index] = sort(timeboot);
    