function ntemp=neuron_binrange_generation(behav,neuron,maxbehavROI,object_bin,bin_radius,binsize)


behavpos=behav.position;
behavtime=behav.time;

% resample bin-behav to follow the neuron dat
behavpos_resample=align_neuron_behav(neuron,behavtime,behavpos);

% behav dat binarize
behavpos_bin_resample=binarize_behavpos(behavpos_resample,binsize,maxbehavROI);

% get all 5x5 neighborhood bins of each obj (really include surrounding
% regions of obj if the obj is 2.8*2.8cm)
all_bin=[];

for u=-bin_radius:bin_radius
    for v=-bin_radius:bin_radius
        all_bin=[all_bin;object_bin(1)+u,object_bin(2)+v]; % left is 2, right is 1
    end
end

% determine neuron time points when mice inside obj range
idx_bin=zeros(length(behavpos_bin_resample),1);
for k=1:length(behavpos_bin_resample)
    for l=1:size(all_bin,1)
        if sum(abs(behavpos_bin_resample(k,:)-all_bin(l,:)))==0
            idx_bin(k,1)=1;
        end
    end
end

% generate close-to-obj neuron dat
ntemp.C=neuron.C(:,logical(idx_bin));
