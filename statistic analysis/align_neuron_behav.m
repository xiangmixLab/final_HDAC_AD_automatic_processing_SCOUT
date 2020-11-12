function neuron_pos=align_neuron_behav(neuron,behavtime,behavpos)


downsampling = length(neuron.time)/size(neuron.C,2);
if downsampling ~= 1
    %     downsampling == 2
    neuron.time = double(neuron.time);
    neuron.time = neuron.time(1:downsampling:end);
    neuron.time = resample(neuron.time,size(neuron.C,2),length(neuron.time));
end
t = find(diff(behavtime)<=0);
while ~isempty(t)
    behavtime(t+1) = behavtime(t)+1;
    t = find(diff(behavtime)<=0);
end
neuron_pos = interp1(behavtime,behavpos,neuron.time); %%
