function dat1=suoqin_shuffle_data(dat,ntime,nE,thresh,deltaTal1)

    deltaT = deltaTal1(nE);
    neuron.time = ntime; 
    neuron.S = dat; 
 
    neuronboot = neuron;
    timeboot = neuronboot.time;
    idx = find(sum(neuron.S > repmat(thresh,1,size(neuron.S,2))));
    timeboot(idx) = ntime(idx)+deltaT;
    index = timeboot > max(ntime);
    timeboot(index) = timeboot(index)-max(ntime);
    [timeboot,index] = sort(timeboot);
%     index=randperm([size(neuron.S,2)]);
    
     dat1 = neuronboot.S(:,index);
   