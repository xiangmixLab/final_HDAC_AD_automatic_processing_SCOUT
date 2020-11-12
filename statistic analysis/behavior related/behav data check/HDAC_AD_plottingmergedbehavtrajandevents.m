%PLOT TRAJ AND FIRING EVENTS OF CURRENT CONDITION
function HDAC_AD_plottingmergedbehavtrajandevents(neuron,behavpos,behavtime,behavROI,threshFiring,sectionindex,binsize,tempname,behavcell,conditionfolder)

downsampling = length(neuron.time)/size(neuron.trace,2);
if downsampling ~= 1
    %     downsampling == 2
    neuron.time = double(neuron.time);
    neuron.time = neuron.time(1:downsampling:end);
end
temp = find(diff(behavtime)<=0);
behavtime(temp+1) = behavtime(temp)+1;
neuron.pos = interp1(behavtime,behavpos,neuron.time); %%

idxall=zeros(1,size(neuron.C,2));
for i=1:size(threshFiring,1)
    thresh=threshFiring(i);
    idx = neuron.S(i,:)>thresh;
    if isequal(tempname,'S')||isempty(tempname)
       idx = neuron.S(i,:)>thresh;
    end
    if isequal(tempname,'trace')
       idx = neuron.trace(i,:)>thresh;
    end
    if isequal(tempname,'C')
       idx = neuron.C(i,:)>thresh;
    end
    idxall=idxall+idx;
end

idxall1=idxall>0;

figure;
plot(neuron.pos(:,1),neuron.pos(:,2),'k')
axis ij;
hold on
idxall1=idxall1(1:length(neuron.pos(:,1)));
numm=idxall/max(idxall(:));
for j=1:length(idxall1)
    if idxall1(j)==1         
        plot(neuron.pos(j,1),neuron.pos(j,2),'.','color',[numm(j),0,0],'MarkerSize',numm(j)*32);
    end
end
plot(0,0);
plot(behavROI(1,3),behavROI(1,4));

posObjects=ceil(behavcell{1,sectionindex}.object);
if sum(posObjects)~=0
    for i5 = 1:size(posObjects,1)
        scatter(posObjects(i5,1),max(max(neuron.pos(:,2)))-posObjects(i5,2)+1,binsize*15,'k','filled')
    end
end

title(['trajectory and firing'],'FontSize',8,'FontName','Arial')
set(gca,'FontSize',8)
axis image
%         xlim([min(neuron.pos(:,1)) max(neuron.pos(:,1))]);
%         ylim([min(neuron.pos(:,2)) max(neuron.pos(:,2))]);
%     plot(ms.pos(idx2,1),ms.pos(idx2,2),'r.')
hold off
saveas(gcf,[conditionfolder,'/','trajectoryFiringEvent.fig'],'fig');
saveas(gcf,[conditionfolder,'/','trajectoryFiringEvent.tif'],'tif');
saveas(gcf,[conditionfolder,'/','trajectoryFiringEvent.eps'],'epsc');
