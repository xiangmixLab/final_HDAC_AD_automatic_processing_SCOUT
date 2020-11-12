function neuron=eliminate_nonexistent(neuron)
indices=(sum(neuron.A,1)==0)'|sum(neuron.S,2)==0;

try
    neuron.P.kernel_pars(indices)=[];

end
try
    neuron.P.sn_neuron=[];
end
save('neuron_temp.mat','neuron');
neuron.A(:,indices)=[];
neuron.C(indices,:)=[];
neuron.C_raw(indices,:)=[];
neuron.S(indices,:)=[];
delete('neuron_temp.mat')