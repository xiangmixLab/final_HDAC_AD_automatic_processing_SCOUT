function neuron=concatenate_neurons(neuron1,neuron2);
neuron=Sources2D;
neuron.C=vertcat(neuron1.C,neuron2.C);
neuron.S=vertcat(neuron1.S,neuron2.S);
neuron.C_raw=vertcat(neuron1.C_raw,neuron2.C_raw);
neuron.combined=vertcat(neuron1.combined,neuron2.combined);
neuron.corr_scores=vertcat(neuron1.corr_scores,neuron2.corr_scores);
neuron.corr_prc=vertcat(neuron1.corr_prc,neuron2.corr_prc);
neuron.dist=vertcat(neuron1.dist,neuron2.dist);
neuron.dist_prc=vertcat(neuron1.dist_prc,neuron2.dist_prc);
neuron.A=horzcat(neuron1.A,neuron2.A);

neuron.centroid=vertcat(neuron1.centroid,neuron2.centroid);
neuron.options=neuron1.options;
