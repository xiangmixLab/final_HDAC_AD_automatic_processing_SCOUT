function neuronIndividuals = concatenateMUltiConditionNeuronData_adapted(neuron,PathName,FileName,neuronIndividualsori,num1,num2,num3)
neuronIndividuals = neuron;
%     [FileName,PathName,FilterIndex] = uigetfile('.mat','select neuron data');

% add the time information
% fid=fopen('N:\Miniature Scope Imaging Data\6_16_2016\C57_CAV2Cre_CA1_DIOGCaMP6_Sub_open with bedding_4th\timestamp.dat','r');
%%title={'training','update','test'};
time=[0];

for i = 1:length(neuronIndividualsori)
time=[time;neuronIndividualsori{i}.time(2:end)+max(time)];
end

neuronIndividuals.time = time;

%Code for checking time points 
% fid=fopen('Y:\Steve\miniscope_imaging\0216\trial3\timestamp.dat','r');
% timedata = textscan(fid, '%d%d%d%d', 'HeaderLines', 1);
% t = timedata{3}(timedata{1} == 1);t(1) = 0;
% figure;hist(diff(double(t)),100)
% t2 = timedata{3}(timedata{1} == 0);t2(1) = 0;
% figure;hist(diff(double(t2)),100)
