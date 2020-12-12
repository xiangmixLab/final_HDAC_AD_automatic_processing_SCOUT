function [avg_pc_dat,avg_npc_dat,all_pc_idx,all_npc_idx]=all_pc_npc_dat(all_neuron_dat,all_pc)


%% pc/npc idx
    all_pc_idx=unique(cell2mat(all_pc'));
    all_npc_idx=[];
    for i=1:size(all_pc,2)
        all_npc_idx=[all_npc_idx;setdiff([1:size(all_neuron_dat,1)],all_pc{i})'];
    end
    all_npc_idx=unique(all_npc_idx);
%% pc/npc dat
    all_pc_dat=[];
    all_npc_dat=[];
    if ~iscell(all_neuron_dat)
        for i=1:size(all_pc,2)
            all_pc_dat=[all_pc_dat;all_neuron_dat(all_pc{i},i)];
            all_npc_dat=[all_npc_dat;all_neuron_dat(setdiff([1:size(all_neuron_dat,1)],all_pc{i}),i)];
        end
    else
        for i=1:size(all_pc,2)
            all_pc_dat=[all_pc_dat;all_neuron_dat{i}(all_pc{i})];
            all_npc_dat=[all_npc_dat;all_neuron_dat{i}(setdiff([1:size(all_neuron_dat,1)],all_pc{i}))];
        end
    end
        
    avg_pc_dat=average_duplicate_neurons(all_pc_dat,all_pc_idx);
    avg_npc_dat=average_duplicate_neurons(all_npc_dat,all_npc_idx);