function neuron0=trunk_rotate_data_neuron_simple(C,S,time,rotate_t)

C1=trunk_rotate_data(C,rotate_t*15,'left');
S1=trunk_rotate_data(S,rotate_t*15,'left');
neuron0.C=C1;
neuron0.S=S1;
neuron0.time=time;
