function neuronIndividuals = splittingMUltiConditionNeuronData_adapted_automatic(neuron,filename,mscamid,behavcamid,timestampname)
neuronIndividuals = cell(1,length(neuron.num2read)-1);
%     [FileName,PathName,FilterIndex] = uigetfile('.mat','select neuron data');

for i = 2:length(neuron.num2read)
    i
    neuron0 = neuron.copy;
    neuron0.num2read=neuron.num2read;
    if i == 2
        start = 1;
    else
        start = sum(neuron0.num2read(2:i-1))+1;
    end
    neuronIndividuals{i-1} = neuron0;
    neuronIndividuals{i-1}.C = neuron0.C(:,start:sum(neuron0.num2read(2:i)));
    neuronIndividuals{i-1}.C_raw = neuron0.C_raw(:,start:sum(neuron0.num2read(2:i)));
%     neuronIndividuals{i-1}.C_df = neuron0.C_df(:,start:sum(neuron0.num2read(2:i)));
    neuronIndividuals{i-1}.S = neuron0.S(:,start:sum(neuron0.num2read(2:i)));
    neuronIndividuals{i-1}.trace = neuron0.trace(:,start:sum(neuron0.num2read(2:i)));
    neuronIndividuals{i-1}.num2read = neuron0.num2read(i);
end
% save('neuronIndividuals.mat', 'neuronIndividuals','-v7.3')

% add the time information
% fid=fopen('N:\Miniature Scope Imaging Data\6_16_2016\C57_CAV2Cre_CA1_DIOGCaMP6_Sub_open with bedding_4th\timestamp.dat','r');
%%title={'training','update','test'};
mscamid=mscamid(~isnan(mscamid));
behavcamid=behavcamid(~isnan(behavcamid));

for i = 1:length(neuronIndividuals)

if ~isempty(timestampname{1,i})
fid=fopen(timestampname{1,i},'r');
mscamindex=mscamid(1,i);
behavindex=behavcamid(1,i);
timedata = textscan(fid, '%d%d%d%d', 'HeaderLines', 1);
t = timedata{3}(timedata{1} == mscamindex);t(1) = 0;   %% make sure the miniscope is for USB port 1 %%behav cam port 0
%%othewise %%t = timedata{3}(timedata{1} == 0);t(1) = 0;
idxt = find(diff(t)<=0);
t(idxt+1) = t(idxt)+1;
% the first is trainning and the second is testing
neuronIndividuals{i}.time = double(t);
end
end
% save('neuronIndividuals.mat', 'neuronIndividuals','-v7.3')%Code for checking time points 
% fid=fopen('Y:\Steve\miniscope_imaging\0216\trial3\timestamp.dat','r');
% timedata = textscan(fid, '%d%d%d%d', 'HeaderLines', 1);
% t = timedata{3}(timedata{1} == 1);t(1) = 0;
% figure;hist(diff(double(t)),100)
% t2 = timedata{3}(timedata{1} == 0);t2(1) = 0;
% figure;hist(diff(double(t2)),100)
