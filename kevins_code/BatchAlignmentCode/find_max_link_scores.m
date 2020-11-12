function [Score,linking_neuron]=find_max_link_scores(i,j,Metric1,Metric2)

Possible_Scores=(Metric1(i,:)+Metric2(:,j)')/2;
[Score,linking_neuron]=max(Possible_Scores);


