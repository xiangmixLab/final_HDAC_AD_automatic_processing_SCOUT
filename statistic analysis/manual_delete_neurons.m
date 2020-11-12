function neuron_del=manual_delete_neurons(neuron,del_idx)

neuron_del=neuron.copy;

neuron_del.A(:,del_idx)=[];
neuron_del.C(del_idx,:)=[];
neuron_del.S(del_idx,:)=[];
neuron_del.trace(del_idx,:)=[];
neuron_del.C_df(del_idx,:)=[];
neuron_del.Coor(del_idx)=[];
neuron_del.centroid(del_idx,:)=[];
