function plottingFiringBehaviorSpatialForCombinedData_adapted(neuron,neuronIndividuals,behavpos,behavtime,behavcell,behavROI,firingRateall,segment,threshFiring,threshSpatial,conditionfolder,binsize,nameparts,placecellindexexcel,tempname,timeindex)

%% This function is used to overlay the neuron activity onto behaviors
% Inputs:
%        (1) neuron: a source2D variable, including identified neurons with traces and spatial information, which is obtained by runing cnmfe codes
%        (2) behav: behavior information, which is obtained by using Tristan's code
%        (3) Segment: a vector, e.g,1:10 (display the traces of the first 10 identified neurons)
%         (4) downsampling rate [e.g., by a factor of 2]

% Important parameter in the code: thresh, the threshold above which the neuron is active. By default, it is 10% of the maximum trace value of each neuron

%'axis image' make the cell firing and behav trace plot looks in same ratio. 
experimentName=conditionfolder;
conditionnum=length(neuronIndividuals);

% close all
folderName = [conditionfolder,'/','FiguresFiringBehaviorSpatial'];
if ~exist(folderName,'dir')
    mkdir(folderName);
end
fpath=[folderName '/'];

% figure

downsampling = length(neuron.time)/size(neuron.trace,2);
if downsampling ~= 1
    %     downsampling == 2
    neuron.time = double(neuron.time);
    neuron.time = neuron.time(1:downsampling:end);
end
temp = find(diff(behavtime)<=0);
behavtime(temp+1) = behavtime(temp)+1;
neuron.pos = interp1(behavtime,behavpos,neuron.time); %%

%
% thresh = 0;
% numFig = 10;
% k = 0;kk = 0;
for i = segment
%     kk = kk+1;
%     if mod(kk-1,numFig) == 0
%         ax = figure;
%         set(ax, 'Position', [100, 100, 600, 1000]);
%         k = 0;
%     end
    
    figure;
    set(gcf,'outerposition',get(0,'screensize'));
    %   thresh = (max(neuron.S(i,:))-min(neuron.S(i,:)))*0.1; % the threshold above which the neuron is active
    thresh = threshFiring(i);
%      k = k+1;

%     idx=idx(idx<=length(neuron.pos));% sometimes neuron.S longer than neuron.pos due to behav data extraction
    %% ploting raw trace and its firing
    %     subplot(length(segment),3,3*k-2)
    subplot(conditionnum,3,4)
    %     subplot(5,2,plotPositionFiring)
    plot(neuron.C(i,:), 'b')
    hold on
%      plot(neuron.S(i,:),'r')
    for ii = 2:length(neuron.num2read)-1
        hold on
        line([sum(neuron.num2read(2:ii)) sum(neuron.num2read(2:ii))],get(gca,'YLim'),'LineStyle','--','Color','k','LineWidth',1.5)
    end
    title(['Cell' num2str(i)],'FontSize',12,'FontName','Arial')
    set(gca,'FontSize',12)
    %     plot([0 neuron.num2read],thresh*[1 1],'k--')
    axis tight
    %     xlim([0 neuron.num2read]);
    %     ylim([min([neuron.trace(i,:);neuron.firing(:,i)]) max([neuron.trace(:,i);neuron.firing(:,i)])])
    % ylim([min([ms.trace(:,i)]) max([ms.trace(:,i)])])
    hold off
%     set(gca,'Xtick',[])
%     set(gca,'Xtick',[1 ceil(neuron.num2read/2) neuron.num2read])
    
    %% plotting animal behavior trajectries
    %     subplot(length(segment),3,3*k-1)
    
    
    %     subplot(5,2,plotPositionPos)
%     neun2readind=[1];
%     if length(neuron.num2read)==2
%         neun2readind=[1,neuron.num2read(2)];
%     end
%     if length(neuron.num2read)==3
%         neun2readind=[1,neuron.num2read(2),sum(neuron.num2read(2:3))];
%     end
%     if length(neuron.num2read)==4
%         neun2readind=[1,neuron.num2read(2),sum(neuron.num2read(2:3)),sum(neuron.num2read(2:4))];
%     end
    for i3=1:length(firingRateall)
    subplot(conditionnum,3,3*i3-1)
    plot(neuronIndividuals{i3}.pos(:,1),neuronIndividuals{i3}.pos(:,2),'k')
    hold on
    
    idxt=[];
    if isequal(tempname,'S')||isempty(tempname)
       idxt = neuronIndividuals{i3}.S(i,:)>thresh;
    end
    if isequal(tempname,'trace')
       idxt = neuronIndividuals{i3}.trace(i,:)>thresh;
    end
    if isequal(tempname,'C')
       idxt = neuronIndividuals{i3}.C(i,:)>thresh;
    end

%     idxt=idx;
%     idxt([1:neun2readind(i3),neun2readind(i3+1):end])=0;
%     if length(neuron.num2read)==2||length(neuron.num2read)==3||length(neuron.num2read)==4
%     
%     plot(neuron.pos(idx(1:neuron.num2read(2)),1),neuron.pos(idx(1:neuron.num2read(2)),2),'r.')
%     end
%     if length(neuron.num2read)==3||length(neuron.num2read)==4
%     plot(neuron.pos(idx(neuron.num2read(2):sum(neuron.num2read(2:3))),1),neuron.pos(idx(neuron.num2read(2):sum(neuron.num2read(2:3))),2),'g.')
%     end
%     if length(neuron.num2read)==4
%     plot(neuron.pos(idx(sum(neuron.num2read(2:3)):sum(neuron.num2read(2:4))),1),neuron.pos(idx(sum(neuron.num2read(2:3)):sum(neuron.num2read(2:4))),2),'b.')
%     end
% 
%     plot(neuron.pos(idx,1),neuron.pos(idx,2),'r.','MarkerSize',15)
    plot(neuronIndividuals{i3}.pos(idxt,1),neuronIndividuals{i3}.pos(idxt,2),'r.','MarkerSize',15)
    posObjects=ceil(behavcell{1,timeindex(i3)}.object./binsize)*binsize;
        if sum(posObjects)~=0
            for i5 = 1:size(posObjects,1)
                scatter(posObjects(i5,1),posObjects(i5,2)+1,binsize*5,'k','filled')
                text(posObjects(i5,1),posObjects(i5,2)-2,[num2str(i5)]);
            end
        end

    
    plot(0,0);
    plot(behavROI(1,3),behavROI(1,4));
    titlename=['Cell#', num2str(i),' ',nameparts{1,i3}];
    if length(firingRateall)<=6
    if placecellindexexcel{i+1,i3+1}==1
        titlename=[titlename '(place cell)'];
    end
    if placecellindexexcel{i+1,i3+1}==0
        titlename=[titlename '(not place cell)'];
    end
    title(titlename,'FontSize',8,'FontName','Arial')
    end
    
    set(gca,'FontSize',8)
    axis image
%         xlim([min(neuron.pos(:,1)) max(neuron.pos(:,1))]);
%         ylim([min(neuron.pos(:,2)) max(neuron.pos(:,2))]);
    %     plot(ms.pos(idx2,1),ms.pos(idx2,2),'r.')
    hold off
%     set(gca,'Xtick',[])
%     set(gca,'Xtick',[1 ceil(neuron.num2read/2) neuron.num2read])
    end
    
    %% plot cell firing map
    for i3=1:length(firingRateall)
        firingRate=firingRateall{1,i3};
        
    if isempty(firingRate{i})
        for iii=1:length(firingRate)
            if ~isempty(firingRate{1,iii})          
                [mm,nn]=size(firingRate{1,iii});
                break;
            end
        end
        firingRate{i}=zeros(mm,nn);
    end
    
    maxCount = threshSpatial;
    firingRateSmoothing = filter2DMatrices(firingRate{i}, 1);
%     firingRateSmoothing2 = nan(size(firingRateSmoothing)+1);
%     firingRateSmoothing2(1:end-1,1:end-1) = firingRateSmoothing;
    %      subplot(length(segment),3,3*k)
    hand=subplot(conditionnum,3,3*i3);

    try
        pcolor(firingRateSmoothing);
        colormap(jet)
        caxis([0,max(maxCount)])
%         axis ij
        axis image
%         colorbar('eastoutside');
        % set(gca, 'color', 'w', 'ydir', 'reverse')
        shading flat;
%         axis square
%         axis image
        % axis off
        hold on;
        posObjects=ceil(behavcell{1,timeindex(i3)}.object./binsize);
        if sum(posObjects)~=0
            for i5 = 1:size(posObjects,1)
                scatter(posObjects(i5,1),posObjects(i5,2)+1,binsize*5,'k','filled')
                text(posObjects(i5,1),posObjects(i5,2),[num2str(i5)]);
            end
        end
        
        titlename=['Cell#', num2str(i),' ',nameparts{1,i3}];
        
        if length(firingRateall)<=6
        if placecellindexexcel{i+1,i3+1}==1
            titlename=[titlename '(place cell)'];
        end
        if placecellindexexcel{i+1,i3+1}==0
            titlename=[titlename '(not place cell)'];
        end
         title(titlename,'FontName','Arial','FontSize',8,'FontWeight','bold')
        end
        
       
        hold off

        colorbar('position',[0.9,hand.Position(2),0.02,hand.Position(4)]);
    catch
        continue;
    end
    end
        saveas(gcf,fullfile(fpath,strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'.fig')))
        saveas(gcf,fullfile(fpath,strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'.tif')))
        saveas(gcf,fullfile(fpath,strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'.eps')),'epsc')
end
%     saveas(gcf,fullfile(fpath,strcat('CellFiringBeaviorSpatial','.tif')))
%     saveas(gcf,fullfile(fpath,strcat('CellFiringBeaviorSpatial','.fig')))

