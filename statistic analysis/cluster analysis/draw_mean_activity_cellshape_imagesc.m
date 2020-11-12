%get the necessary variables from "draw_mean_activity_mouseC.m"

%%%% cell footprint
day=1;
%imagesc(max(reshape(neuronIndividuals{1,day}.A, neuronIndividuals{1,day}.imageSize(1), neuronIndividuals{1,day}.imageSize(2),[]),[],3))
%tmp is a matrix: (neuronIndividuals{1,day}.imageSize(1) x
%neuronIndividuals{1,day}.imageSize(2)) * 75 (number of neurons)
tmp=neuronIndividuals{1,day}.A;
%tmp2 is a 3-way array
tmp2=reshape(tmp, neuronIndividuals{1,day}.imageSize(1), neuronIndividuals{1,day}.imageSize(2),[]);
%tmp3 is matirx: neuronIndividuals{1,day}.imageSize(1) x neuronIndividuals{1,day}.imageSize(2)
tmp3=max(tmp2,[],3);
imagesc(max(tmp2,[],3))
set(gca,'YDir','normal') %reverse the y-axis

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% heat map of mean neural activity
tmpcolor=jet(100);
top=max([max(big_hab) max(shockbox_hab)  max(big_learn) max(shockbox_learn) max(big_ext) max(shockbox_ext) max(big_relearn) max(shockbox_relearn) max(shock_learn) max(shock_relearn)]);

%A_color is a matrix with three columns
A_color=zeros(neuronIndividuals{1,day}.imageSize(1)*neuronIndividuals{1,day}.imageSize(2),3);
A_color(:,3)=tmpcolor(1,3);



%%%%%%% bigbox
for cell=1:75
 Ai=neuronIndividuals{1,day}.A(:,cell);
 ind=find(Ai>0);%the pixels at which a neuron shows up
 for i=1:length(ind)
  A_color(ind(i),:)=tmpcolor(ceil(100*sqrt(big_hab(cell)/top)),:);
 end
end
%reshape A to a 3-way array and draw the image
subplot(3,4,1)
imagesc(reshape(A_color, neuronIndividuals{1,day}.imageSize(1), neuronIndividuals{1,day}.imageSize(2),3));
set(gca,'YDir','normal') %reverse the y-axis
title("Habituation"); 

for cell=1:75
 Ai=neuronIndividuals{1,day}.A(:,cell);
 ind=find(Ai>0);%the pixels at which a neuron shows up
 for i=1:length(ind)
  A_color(ind(i),:)=tmpcolor(ceil(100*sqrt(big_learn(cell)/top)),:);
 end
end
%reshape A to a 3-way array and draw the image
subplot(3,4,2)
imagesc(reshape(A_color, neuronIndividuals{1,day}.imageSize(1), neuronIndividuals{1,day}.imageSize(2),3));
set(gca,'YDir','normal') %reverse the y-axis
title("Learning"); 

for cell=1:75
 Ai=neuronIndividuals{1,day}.A(:,cell);
 ind=find(Ai>0);%the pixels at which a neuron shows up
 for i=1:length(ind)
  A_color(ind(i),:)=tmpcolor(ceil(100*sqrt(big_ext(cell)/top)),:);
 end
end
%reshape A to a 3-way array and draw the image
subplot(3,4,3)
imagesc(reshape(A_color, neuronIndividuals{1,day}.imageSize(1), neuronIndividuals{1,day}.imageSize(2),3));
set(gca,'YDir','normal') %reverse the y-axis
title("Extinction"); 

for cell=1:75
 Ai=neuronIndividuals{1,day}.A(:,cell);
 ind=find(Ai>0);%the pixels at which a neuron shows up
 for i=1:length(ind)
  A_color(ind(i),:)=tmpcolor(ceil(100*sqrt(big_relearn(cell)/top)),:);
 end
end
%reshape A to a 3-way array and draw the image
subplot(3,4,4)
imagesc(reshape(A_color, neuronIndividuals{1,day}.imageSize(1), neuronIndividuals{1,day}.imageSize(2),3));
set(gca,'YDir','normal') %reverse the y-axis
title("Relearning"); 

%%%%%%% Shock Box
for cell=1:75
 Ai=neuronIndividuals{1,day}.A(:,cell);
 ind=find(Ai>0);%the pixels at which a neuron shows up
 for i=1:length(ind)
  A_color(ind(i),:)=tmpcolor(ceil(100*sqrt(shockbox_hab(cell)/top)),:);
 end
end
%reshape A to a 3-way array and draw the image
subplot(3,4,5)
imagesc(reshape(A_color, neuronIndividuals{1,day}.imageSize(1), neuronIndividuals{1,day}.imageSize(2),3));
set(gca,'YDir','normal') %reverse the y-axis

for cell=1:75
 Ai=neuronIndividuals{1,day}.A(:,cell);
 ind=find(Ai>0);%the pixels at which a neuron shows up
 for i=1:length(ind)
  A_color(ind(i),:)=tmpcolor(ceil(100*sqrt(shockbox_learn(cell)/top)),:);
 end
end
%reshape A to a 3-way array and draw the image
subplot(3,4,6)
imagesc(reshape(A_color, neuronIndividuals{1,day}.imageSize(1), neuronIndividuals{1,day}.imageSize(2),3));
set(gca,'YDir','normal') %reverse the y-axis

for cell=1:75
 Ai=neuronIndividuals{1,day}.A(:,cell);
 ind=find(Ai>0);%the pixels at which a neuron shows up
 for i=1:length(ind)
  A_color(ind(i),:)=tmpcolor(ceil(100*sqrt(shockbox_ext(cell)/top)),:);
 end
end
%reshape A to a 3-way array and draw the image
subplot(3,4,7)
imagesc(reshape(A_color, neuronIndividuals{1,day}.imageSize(1), neuronIndividuals{1,day}.imageSize(2),3));
set(gca,'YDir','normal') %reverse the y-axis

for cell=1:75
 Ai=neuronIndividuals{1,day}.A(:,cell);
 ind=find(Ai>0);%the pixels at which a neuron shows up
 for i=1:length(ind)
  A_color(ind(i),:)=tmpcolor(ceil(100*sqrt(shockbox_relearn(cell)/top)),:);
 end
end
%reshape A to a 3-way array and draw the image
subplot(3,4,8)
imagesc(reshape(A_color, neuronIndividuals{1,day}.imageSize(1), neuronIndividuals{1,day}.imageSize(2),3));
set(gca,'YDir','normal') %reverse the y-axis

%%%%%% shock 
for cell=1:75
 Ai=neuronIndividuals{1,day}.A(:,cell);
 ind=find(Ai>0);%the pixels at which a neuron shows up
 for i=1:length(ind)
  A_color(ind(i),:)=tmpcolor(ceil(100*sqrt(shock_learn(cell)/top)),:);
 end
end
%reshape A to a 3-way array and draw the image
subplot(3,4,10)
imagesc(reshape(A_color, neuronIndividuals{1,day}.imageSize(1), neuronIndividuals{1,day}.imageSize(2),3));
set(gca,'YDir','normal') %reverse the y-axis


for cell=1:75
 Ai=neuronIndividuals{1,day}.A(:,cell);
 ind=find(Ai>0);%the pixels at which a neuron shows up
 for i=1:length(ind)
  A_color(ind(i),:)=tmpcolor(ceil(100*sqrt(shock_relearn(cell)/top)),:);
 end
end
%reshape A to a 3-way array and draw the image
subplot(3,4,12)
imagesc(reshape(A_color, neuronIndividuals{1,day}.imageSize(1), neuronIndividuals{1,day}.imageSize(2),3));
set(gca,'YDir','normal') %reverse the y-axis



