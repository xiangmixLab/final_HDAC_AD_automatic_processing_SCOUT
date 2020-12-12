function [all_pc_idx,all_npc_idx]=all_pc_npc_idx_with_duplicate(all_pc)

    all_pc_idx=cell2mat(all_pc');
    all_npc_idx=[];
    for i=1:size(all_pc,2)
        all_npc_idx=[all_npc_idx;setdiff([1:all_neuron_num],all_pc{i})];
    end
