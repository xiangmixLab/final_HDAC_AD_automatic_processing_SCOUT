function neuron0=JS_trim_neurons_overall(obj,spatial_filter_options)
%% update  background for all patches
% input:
%   use_parallel: boolean, do initialization in patch mode or not.
%       default(true); we recommend you to set it false only when you want to debug the code.

%% Author: Pengcheng Zhou, Columbia University, 2017
%% email: zhoupc1988@gmail.com

%% update spatial components for all batches 
disp('SCOUT JS score trim bad footprints');
if spatial_filter_options.JS>0   
    [neuron0,JS_score]=spatial_filter(obj,spatial_filter_options);
end
