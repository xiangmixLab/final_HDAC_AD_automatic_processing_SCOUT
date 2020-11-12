function [neuronIndividuals_ndir,neuronIndividuals_pdir] = splittingMUltiConditionNeuronData_adapted_automatic_dirspec(neuron,filename,mscamid,behavcamid,timestampname,dir)

neuronIndividuals_ndir = cell(1,length(neuron.num2read)-1);
neuronIndividuals_pdir = cell(1,length(neuron.num2read)-1);

%     [FileName,PathName,FilterIndex] = uigetfile('.mat','select neuron data');

dir_resample=dir;

for i = 2:length(neuron.num2read)
    disp(['direction modify ',num2str(i)])
    neuron0 = neuron.copy;
    neuron0.num2read=neuron.num2read;
    if i == 2
        start = 1;
    else
        start = sum(neuron0.num2read(2:i-1))+1;
    end
    
    %% resample directional vec
    dir_resample{i-1}=resample(double(dir_resample{i-1}),length(start:sum(neuron0.num2read(2:i))),length(dir_resample{i-1}));
    dir_resample{i-1}=logical(dir_resample{i-1});
    
    %% get neural response negative dir
    neuronIndividuals_ndir{i-1} = neuron0;
    neuronIndividuals_ndir{i-1}.C = neuron0.C(:,start:sum(neuron0.num2read(2:i)));
    neuronIndividuals_ndir{i-1}.C_raw = neuron0.C_raw(:,start:sum(neuron0.num2read(2:i)));
    neuronIndividuals_ndir{i-1}.C_df = neuron0.C_df(:,start:sum(neuron0.num2read(2:i)));
    neuronIndividuals_ndir{i-1}.S = neuron0.S(:,start:sum(neuron0.num2read(2:i)));
    neuronIndividuals_ndir{i-1}.trace = neuron0.trace(:,start:sum(neuron0.num2read(2:i)));
    
    %% resample neural response negative dir
    neuronIndividuals_ndir{i-1}.C=neuronIndividuals_ndir{i-1}.C(:,~dir_resample{i-1});
    neuronIndividuals_ndir{i-1}.C_raw=neuronIndividuals_ndir{i-1}.C_raw(:,~dir_resample{i-1});
    neuronIndividuals_ndir{i-1}.C_df=neuronIndividuals_ndir{i-1}.C_df(:,~dir_resample{i-1});
    neuronIndividuals_ndir{i-1}.S=neuronIndividuals_ndir{i-1}.S(:,~dir_resample{i-1});    
    neuronIndividuals_ndir{i-1}.trace=neuronIndividuals_ndir{i-1}.trace(:,~dir_resample{i-1}); 
    neuronIndividuals_ndir{i-1}.num2read=size(neuronIndividuals_ndir{i-1}.C,2);
    
    %% get neural response positive dir
    neuron1 = neuron.copy;
    neuron1.num2read=neuron.num2read;
    
    
    neuronIndividuals_pdir{i-1} = neuron1;
    neuronIndividuals_pdir{i-1}.C = neuron1.C(:,start:sum(neuron1.num2read(2:i)));
    neuronIndividuals_pdir{i-1}.C_raw = neuron1.C_raw(:,start:sum(neuron1.num2read(2:i)));
    neuronIndividuals_pdir{i-1}.C_df = neuron1.C_df(:,start:sum(neuron1.num2read(2:i)));
    neuronIndividuals_pdir{i-1}.S = neuron1.S(:,start:sum(neuron1.num2read(2:i)));
    neuronIndividuals_pdir{i-1}.trace = neuron1.trace(:,start:sum(neuron1.num2read(2:i)));
    
    %% resample neural response positive dir
    neuronIndividuals_pdir{i-1}.C=neuronIndividuals_pdir{i-1}.C(:,dir_resample{i-1});
    neuronIndividuals_pdir{i-1}.C_raw=neuronIndividuals_pdir{i-1}.C_raw(:,dir_resample{i-1});
    neuronIndividuals_pdir{i-1}.C_df=neuronIndividuals_pdir{i-1}.C_df(:,dir_resample{i-1});
    neuronIndividuals_pdir{i-1}.S=neuronIndividuals_pdir{i-1}.S(:,dir_resample{i-1});    
    neuronIndividuals_pdir{i-1}.trace=neuronIndividuals_pdir{i-1}.trace(:,dir_resample{i-1});
    neuronIndividuals_pdir{i-1}.num2read=size(neuronIndividuals_pdir{i-1}.C,2);
end


mscamid=mscamid(~isnan(mscamid));
behavcamid=behavcamid(~isnan(behavcamid));

for i = 1:length(neuronIndividuals_ndir)

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
        
        dir{i}=resample(double(dir{i}),length(t),length(dir{i}));
        dir{i}=logical(dir{i});
        
        neuronIndividuals_ndir{i}.time = double(t(~dir{i}));
        neuronIndividuals_pdir{i}.time = double(t(dir{i}));
    end
end
% save('neuronIndividuals.mat', 'neuronIndividuals','-v7.3')%Code for checking time points 
% fid=fopen('Y:\Steve\miniscope_imaging\0216\trial3\timestamp.dat','r');
% timedata = textscan(fid, '%d%d%d%d', 'HeaderLines', 1);
% t = timedata{3}(timedata{1} == 1);t(1) = 0;
% figure;hist(diff(double(t)),100)
% t2 = timedata{3}(timedata{1} == 0);t2(1) = 0;
% figure;hist(diff(double(t2)),100)
