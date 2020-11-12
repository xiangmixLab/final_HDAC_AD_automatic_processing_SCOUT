function plottingFiringBehaviorSpatialForSingleData_mousehead2ob_adapted(neuron,behavpos,behavtime,behavROI,firingRate,segment,threshFiring,threshSpatial,conditionfolder,sectionindex,binsize,tempname,mousetoob,objectname)

%% This function is used to overlay the neuron activity onto behaviors
% Inputs:
%        (1) neuron: a source2D variable, including identified neurons with traces and spatial information, which is obtained by runing cnmfe codes
%        (2) behav: behavior information, which is obtained by using Tristan's code
%        (3) Segment: a vector, e.g,1:10 (display the traces of the first 10 identified neurons)
%         (4) downsampling rate [e.g., by a factor of 2]

% Important parameter in the code: thresh, the threshold above which the neuron is active. By default, it is 10% of the maximum trace value of each neuron

%'axis image' make the cell firing and behav trace plot looks in same ratio. 
experimentName=[conditionfolder{sectionindex}];

% close all
folderName = [conditionfolder{sectionindex},'/','FiguresFiringBehaviorSpatial_mouseLookObject','/',objectname];
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
numFig = 10;
k = 0;kk = 0;
for i = segment
    kk = kk+1;
    if mod(kk-1,numFig) == 0
        ax = figure;
        set(ax, 'Position', [100, 100, 600, 1000]);
        k = 0;
    end
    
    
    %   thresh = (max(neuron.S(i,:))-min(neuron.S(i,:)))*0.1; % the threshold above which the neuron is active
    thresh = threshFiring(i);
     k = k+1;
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
%     idx=idx(idx<=length(neuron.pos));% sometimes neuron.S longer than neuron.pos due to behav data extraction
    %% ploting raw trace and its firing
    %     subplot(length(segment),3,3*k-2)
    subplot(numFig,3,3*k-2)
    %     subplot(5,2,plotPositionFiring)
    plot(neuron.C(i,:), 'b')
    hold on
    plot(neuron.S(i,:),'r')
    title(['Cell' num2str(i)],'FontSize',8,'FontName','Arial')
    set(gca,'FontSize',8)
    %     plot([0 neuron.num2read],thresh*[1 1],'k--')
    axis tight
    %     xlim([0 neuron.num2read]);
    %     ylim([min([neuron.trace(i,:);neuron.firing(:,i)]) max([neuron.trace(:,i);neuron.firing(:,i)])])
    % ylim([min([ms.trace(:,i)]) max([ms.trace(:,i)])])
    hold off
    set(gca,'Xtick',[])
    if mod(kk,numFig) == 0 || kk == max(segment)
        set(gca,'Xtick',[1 ceil(neuron.num2read/2) neuron.num2read])
    end
    
    %% plotting animal behavior trajectries
    %     subplot(length(segment),3,3*k-1)
    firingRateSmoothing = filter2DMatrices(firingRate{i}, 1);
    firingRateSmoothing2 = nan(size(firingRateSmoothing)+1);
    firingRateSmoothing2(1:end-1,1:end-1) = firingRateSmoothing;
    
    subplot(numFig,3,3*k-1)
    %     subplot(5,2,plotPositionPos)
    plot(neuron.pos(:,1),neuron.pos(:,2),'k')
    hold on
    idx=idx(1:length(neuron.pos(:,1)));
    idx(mousetoob==0)=0;
    plot(neuron.pos(idx,1),neuron.pos(idx,2),'r.')
    plot(0,0);
    plot(behavROI(1,3),behavROI(1,4));
    title(['Cell' num2str(i)],'FontSize',8,'FontName','Arial')
    set(gca,'FontSize',8)
    axis image
%         xlim([min(neuron.pos(:,1)) max(neuron.pos(:,1))]);
%         ylim([min(neuron.pos(:,2)) max(neuron.pos(:,2))]);
    %     plot(ms.pos(idx2,1),ms.pos(idx2,2),'r.')
    hold off
    set(gca,'Xtick',[])
    if mod(kk,numFig) == 0 || kk == max(segment)
        set(gca,'Xtick',[1 ceil(neuron.num2read/2) neuron.num2read])
    end
    
    %% plot cell firing map
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
    firingRateSmoothing2 = nan(size(firingRateSmoothing)+1);
    firingRateSmoothing2(1:end-1,1:end-1) = firingRateSmoothing;
    %      subplot(length(segment),3,3*k)
    hand=subplot(numFig,3,3*k);

    try
        pcolor(firingRateSmoothing2);
        colormap(jet)
        caxis([0,max(maxCount)])
        axis image
%         colorbar('eastoutside');
        % set(gca, 'color', 'w', 'ydir', 'reverse')
        shading flat;
%         axis square
%         axis image
        % axis off
        title(['Cell #', num2str(i)],'FontName','Arial','FontSize',8,'FontWeight','bold')
        hold off

        if mod(kk,numFig) ~= 0 
            set(gca,'Xtick',[])
        end
        if mod(kk,numFig) == 0 || i==segment(length(segment))
%             colorbar('eastoutside');
            if mod(kk,numFig) == 0
                colorbar('position',[0.9,hand.Position(2),0.02,hand.Position(4)]);
            end
            if i==segment(length(segment))
                colorbar('position',[0.9,hand.Position(2),0.02,hand.Position(4)]);
            end
        end
    catch
        continue;
    end
    if mod(kk,numFig) == 0 || kk == max(segment)
        saveas(gcf,fullfile(fpath,strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'.fig')))
        saveas(gcf,fullfile(fpath,strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'.tif')))
        saveas(gcf,fullfile(fpath,strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'.eps')))
    end
end
%     saveas(gcf,fullfile(fpath,strcat('CellFiringBeaviorSpatial','.tif')))
%     saveas(gcf,fullfile(fpath,strcat('CellFiringBeaviorSpatial','.fig')))

