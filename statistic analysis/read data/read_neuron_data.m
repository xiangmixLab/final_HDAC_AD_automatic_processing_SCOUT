%HDAC_AD_auto read neuron data
function [neuron,neuronfilename] = read_neuron_data(ikk,foldernamet,chosenind)

fntt=dir(['*final_result.mat']);
% load([fnt1.name]);
fnt1=fntt(chosenind);
neuron=importdata([fnt1.name]);
neuronfilename=fnt1.name;
