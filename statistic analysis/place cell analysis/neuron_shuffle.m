function neuronboot=neuron_shuffle(neuron,time0,S0,trace0,C0,thresh,deltaT)
    neuron.time = time0; 
    neuron.S = S0; 
    neuron.trace = trace0;
    neuron.C = C0;
 
    neuronboot = neuron.copy;
    timeboot = neuronboot.time;
    idx = find(sum(neuron.S > repmat(thresh,1,size(neuron.S,2))));
    timeboot(idx) = time0(idx)+deltaT;
    index = timeboot > max(time0);
    timeboot(index) = timeboot(index)-max(time0);
    [timeboot,index] = sort(timeboot);
%     index=randperm([size(neuron.S,2)]);
    neuronboot.time = timeboot;
%     timeboot = (1:length(neuronboot.time)) + deltaT; % timeboot calculation from YJ after sfn2019 (10/28/19)
%     idx = timeboot > length(neuronboot.time);
%     timeboot(idx) = timeboot(idx) - length(neuronboot.time);
%     [~,index] = sort(timeboot);
    
    neuronboot.S = neuronboot.S(:,index);
    neuronboot.trace = neuronboot.trace(:,index);
    neuronboot.C = neuronboot.C(:,index);