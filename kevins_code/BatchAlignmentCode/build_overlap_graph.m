function [G,final_letter]=build_overlap_graph(vid_files,batches,shift_val,score_thresh,height,width)
Alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
for i=1:26
    alphabet{i}=Alphabet(i);
end
alphabet1=alphabet;
G=digraph();
%Add initial node so that graph is nonempty
G=addnode(G,'Useless');
overlap_start=shift_val+1;
for i=1:length(vid_files)-1
    load(vid_files{i});
    neuron1=neuron;
    load(vid_files{i+1});
    neuron2=neuron;
    letter_index1=mod(i,length(alphabet1));
    if letter_index1==0
        
        letter1=alphabet1{end};
        alphabet1=python_zip(alphabet1,alphabet);
        letter2=alphabet{1};
    else
        letter2=alphabet1{letter_index1+1};
        letter1=alphabet1{letter_index1};
    end
    
    
    
    
    G=build_linkage_graph_single(neuron1,neuron2,sum(batches(overlap_start:overlap_start+1)),height,width,letter1,letter2,score_thresh,G);
    overlap_start=overlap_start+shift_val;
end
final_letter=letter2;

