%hdac_ad_auto merge the individual conditions

function [neuronIndividuals_new,num2read1,timeindex]=HDAC_AD_merge_individual(neuron,neuronfilename,neuronIndividuals,numparts,num_of_conditions,exp,test5minsign)

%% change back to original all sections: baseline, training, testing
num2read1=zeros(1,num_of_conditions+1);
num2read1(1)=neuron.num2read(1);
pos=2;
for i01=2:num_of_conditions+1
%     num2read1(i01)=sum(neuron.num2read(2+sum(numparts(1:i01-2)):sum(numparts(1:i01-1))+1));
    if numparts(i01-1)==0
        num2read1(i01)=neuron.num2read(pos);
        pos=pos+1;
    end
    if numparts(i01-1)>0
        for j=1:numparts(i01-1)
            num2read1(i01)=num2read1(i01)+neuron.num2read(pos);
            pos=pos+1;
        end
    end
end
neuron.num2read=num2read1;
neuronIndividuals_new = splittingMUltiConditionNeuronData_adapted_2_automatic(neuron,neuronfilename,neuronIndividuals,numparts);

timeindex=zeros(1,length(numparts));
for i01=1:length(numparts)
    timeindex(1,i01)=timeindex(1,i01)+sum(numparts(1:i01));
    if numparts(i01)==0
        timeindex(1,i01:end)=timeindex(1,i01:end)+1;
    end
end
timeindex=timeindex(timeindex~=0);
timeindex=[0,timeindex];

save('neuronIndividuals_new.mat','neuronIndividuals_new','-v7.3');
