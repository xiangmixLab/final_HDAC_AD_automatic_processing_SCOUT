function neuronIndividuals = splittingMUltiConditionNeuronData_adapted_2_automatic(neuron,filename,neuronIndividualsori,num)
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
% save('neuronIndividuals_tr_up_test.mat','neuronIndividuals','-v7.3')

% add the time information
% fid=fopen('N:\Miniature Scope Imaging Data\6_16_2016\C57_CAV2Cre_CA1_DIOGCaMP6_Sub_open with bedding_4th\timestamp.dat','r');
%%title={'training','update','test'};
timeindex=zeros(1,length(num));
for i01=1:length(num)
    timeindex(1,i01)=timeindex(1,i01)+sum(num(1:i01));
    if num(i01)==0
        timeindex(1,i01:end)=timeindex(1,i01:end)+1;
    end
end
% timeindex=[num1,num1+num2,num1+num2+num3];
timeindex=timeindex(timeindex~=0);
timeindex=[0,timeindex];

for i = 1:length(neuronIndividuals)
time=[0];
for j=timeindex(i)+1:timeindex(i+1)
time=[time;neuronIndividualsori{j}.time(2:end)+max(time)];
end
neuronIndividuals{i}.time = time;
end

% save('neuronIndividuals_tr_up_test.mat','neuronIndividuals','-v7.3')
%Code for checking time points 
% fid=fopen('Y:\Steve\miniscope_imaging\0216\trial3\timestamp.dat','r');
% timedata = textscan(fid, '%d%d%d%d', 'HeaderLines', 1);
% t = timedata{3}(timedata{1} == 1);t(1) = 0;
% figure;hist(diff(double(t)),100)
% t2 = timedata{3}(timedata{1} == 0);t2(1) = 0;
% figure;hist(diff(double(t2)),100)
