function [Score,linking_neuron]=find_min_link_scores(i,j,Metric1,Metric2)

Possible_Scores=(Metric1(i,:)+Metric2(:,j)')/2;
[Score,linking_neuron]=min(Possible_Scores);

