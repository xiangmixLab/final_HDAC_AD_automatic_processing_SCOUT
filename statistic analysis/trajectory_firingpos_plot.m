function trajectory_firingpos_plot(behav,neuron,behavROI,cell_idx,thresh,binsize)


idx = neuron.S(cell_idx,:)>thresh;

downsampling = length(neuron.time)/size(neuron.C,2);
if downsampling ~= 1
    neuron.time = double(neuron.time);
    neuron.time = neuron.time(1:downsampling:end);
end
temp = find(diff(behav.time)<=0);
behav.time(temp+1) = behav.time(temp)+1;
neuron.pos = interp1(behav.time,behav.position,neuron.time); %%

plot(neuron.pos(:,1),neuron.pos(:,2),'k')
hold on
idx=idx(1:length(neuron.pos(:,1)));
plot(neuron.pos(idx,1),neuron.pos(idx,2),'r.','MarkerSize',5)
plot(0,0);
plot(behavROI(1,3),behavROI(1,4));

posObjects=round(behav.object);
if isempty(find(posObjects==0))
    for i5 = 1:size(posObjects,1)
        scatter(posObjects(i5,1),max(max(neuron.pos(:,2)))-posObjects(i5,2)+1,binsize*2,'k','filled')
    end
end

axis ij
shading flat;
axis image
axis off

