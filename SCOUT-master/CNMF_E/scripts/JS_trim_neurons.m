function JS_trim_neurons(obj,spatial_filter_options)
%% update  background for all patches
% input:
%   use_parallel: boolean, do initialization in patch mode or not.
%       default(true); we recommend you to set it false only when you want to debug the code.

%% Author: Pengcheng Zhou, Columbia University, 2017
%% email: zhoupc1988@gmail.com

%% update spatial components for all batches 
disp('SCOUT JS score trim bad footprints');
nbatches = length(obj.batches); 

for mbatch=1:nbatches
    batch_k = obj.batches{mbatch}; 
    neuron_k = batch_k.neuron; 
    
    fprintf('\n processing batch %d/%d\n', mbatch, nbatches); 

    % update background
    if spatial_filter_options.JS>0        
        [neuron_k,JS_score]=spatial_filter(neuron_k,spatial_filter_options);
    end
    
    batch_k.neuron = neuron_k; 
    obj.batches{mbatch} = batch_k; 
end