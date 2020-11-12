function neuron0=trim_neurons(neuron,del_idx)

neuron0=neuron.copy;
try
neuron0.A(:,del_idx)=[];
catch
end

try
neuron0.C(del_idx,:)=[];
catch
end

try
neuron0.C_raw(del_idx,:)=[];
catch
end

try
neuron0.S(del_idx,:)=[];
catch
end

try
neuron0.Coor(del_idx)=[];
catch
end

try
neuron0.centroid(del_idx,:)=[];
catch
end

try
neuron0.A_prev(del_idx,:)=[];
catch
end

try
neuron0.C_prev(del_idx,:)=[];
catch
end

try
neuron0.trace(del_idx,:)=[];
catch
end

try
neuron0.trace_raw(del_idx,:)=[];
catch
end

try
neuron0.C_df(del_idx,:)=[];
catch
end

try
neuron0.Df(del_idx,:)=[];
catch
end

    