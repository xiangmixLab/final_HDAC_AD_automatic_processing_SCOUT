function neuron0=trunk_shuffle_data_neuron_simple(C,S,time)

C1=trunk_shuffle_data_pre_split(C);
S1=trunk_shuffle_data_pre_split(S);
neuron0.C=C1;
neuron0.S=S1;
neuron0.time=time;
