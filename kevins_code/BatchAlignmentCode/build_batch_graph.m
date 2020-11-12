function [G,final_letter]=build_batch_graph(neurons,score_thresh,overlap,height,width,corr_type,dist_meas)
Alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
for i=1:26
    alphabet{i}=Alphabet(i);
end
alphabet1=alphabet;
G=digraph();
%Add initial node so that graph is nonempty
G=addnode(G,'Useless');

total_neuron=neurons;
for i=1:length(total_neuron)-1
    letter_index1=mod(i,length(alphabet1));
    if letter_index1==0
        
        letter1=alphabet1{end};
        alphabet1=python_zip(alphabet1,alphabet);
        letter2=alphabet{1};
    else
        letter2=alphabet1{letter_index1+1};
        letter1=alphabet1{letter_index1};
    end
    
    
    
    
    G=build_batch_graph_single(total_neuron{i},total_neuron{i+1},overlap,height,width,letter1,letter2,score_thresh,G,corr_type,dist_meas);
end
final_letter=letter2;

