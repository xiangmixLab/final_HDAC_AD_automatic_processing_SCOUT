function plottingFiringBehaviorSpatialForSingleData_adapted_ct(neuron,behavpos,behavtime,behavROI,firingRate,segment,threshFiring,threshSpatial,threshSpatial_2,threshSpatial_3,conditionfolder,sectionindex,binsize,tempname,behavcell,firingRate2,labfr2,firingRate3,labfr3,place_cells,TinfoPerSecond)

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
folderName = [conditionfolder{sectionindex},'/','FiguresFiringBehaviorSpatial_countTime'];
% if ~exist(folderName,'dir')
    mkdir(folderName);
% end
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

maxfr1=0;
maxfr2=0;
maxfr3=0;

radius=3;
% for i=1:size(firingRate,2)
%     ft1=firingRate{i};
%     ft3=firingRate3{i};
%     ft1(isnan(ft1))=0;
%     ft1(ft1==inf)=0;
%     ft3(isnan(ft3))=0;
%     ft3(ft3==inf)=0;
%     f = ones(2*radius-1)/sum(sum(ones(2*radius-1))); % this is average
%     ft1=conv2(ft1,f,'same');
%     ft3=conv2(ft3,f,'same');
% %     ft1 = filter2DMatrices(ft1, 1);
% %     ft3 = filter2DMatrices(ft3, 1);
%     if max(max(ft1))>maxfr1
%         maxfr1=max(max(ft1));
%     end
%     if max(max(ft3))>maxfr3
%         maxfr3=max(max(ft3));
%     end
% end

% display_corr=0;%make display looks better
% 
% maxfr1=maxfr1-display_corr;
% maxfr3=maxfr3-display_corr;

plot_row=4;
    
for i = segment
    kk = kk+1;
    if mod(kk-1,numFig) == 0
        ax = figure;
        set(ax, 'Position', [100, 100, 1000, 1000]);
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
    subplot(numFig,plot_row,plot_row*k-(plot_row-1))
    %     subplot(5,2,plotPositionFiring)
    plot(neuron.C(i,:), 'b')
    hold on
%     plot(neuron.S(i,:),'r')
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
    
    subplot(numFig,plot_row,plot_row*k-(plot_row-2))
        axis image
        axis ij;
    %     subplot(5,2,plotPositionPos)
    plot(neuron.pos(:,1),neuron.pos(:,2),'k')
    hold on
    idx=idx(1:length(neuron.pos(:,1)));
    plot(neuron.pos(idx,1),neuron.pos(idx,2),'r.')
    plot(0,0);
    plot(behavROI(1,3),behavROI(1,4));
    
    posObjects=ceil(behavcell{1,sectionindex}.object);
    if sum(posObjects)~=0
        for i5 = 1:size(posObjects,1)
            scatter(posObjects(i5,1),max(max(neuron.pos(:,2)))-posObjects(i5,2)+1,binsize*2,'k','filled')
        end
    end

    title(['Cell' num2str(i)],'FontSize',8,'FontName','Arial')
    set(gca,'FontSize',8)
    axis image
        axis ij;
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
    ft1=firingRate{i};
    ft1(isnan(ft1))=0;
    ft1(ft1==inf)=0;
    
    if ~isempty(threshSpatial)
        maxCount = threshSpatial;
    else
        maxCount=maxfr1;
    end
    
%     firingRateSmoothing = filter2DMatrices(ft1, 1);
    f = ones(2*radius-1)/sum(sum(ones(2*radius-1))); % this is average
    firingRateSmoothing=conv2(ft1,f,'same');
    firingRateSmoothing2 = nan(size(firingRateSmoothing)+1);
    firingRateSmoothing2(1:end-1,1:end-1) = firingRateSmoothing;
    %      subplot(length(segment),3,3*k)
    hand=subplot(numFig,plot_row,plot_row*k-(plot_row-3));

    try
        pcolor(firingRateSmoothing2);
        hold on;
        colormap(jet)
        caxis([0,max(firingRateSmoothing2(:))]);
        axis ij;
        axis image
%         colorbar('eastoutside');
        % set(gca, 'color', 'w', 'ydir', 'reverse')
        
        posObjects=ceil(behavcell{1,sectionindex}.object./binsize);
        if sum(posObjects)~=0
            for i5 = 1:size(posObjects,1)
                scatter(posObjects(i5,1)+1,size(firingRateSmoothing,1)-posObjects(i5,2)+1,binsize*2,'k','filled')
            end
        end
        
        shading flat;
%         axis square
%         axis image
        % axis off
        title(['event count'],'FontName','Arial','FontSize',8,'FontWeight','bold')
        hold off
        colorbar('position',[0.75,hand.Position(2),0.01,hand.Position(4)]);
        if mod(kk,numFig) ~= 0 
            set(gca,'Xtick',[])
        end
%         if mod(kk,numFig) == 0 || i==segment(length(segment))
% %             colorbar('eastoutside');
%             if mod(kk,numFig) == 0
%                 colorbar('position',[0.55,hand.Position(2),0.02,hand.Position(4)]);
%             end
%             if i==segment(length(segment))
%                 colorbar('position',[0.55,hand.Position(2),0.02,hand.Position(4)]);
%             end
%         end
    catch
        continue;
    end
    
    %% plot cell count time 
    if isempty(firingRate2{i})
        for iii=1:length(firingRate2)
            if ~isempty(firingRate2{1,iii})          
                [mm,nn]=size(firingRate2{1,iii});
                break;
            end
        end
        firingRate2{i}=zeros(mm,nn);
    end
    ft2=firingRate2{i};
    ft2(isnan(ft2))=0;
    ft2(ft2==inf)=0;
    
%     firingRateSmoothing = filter2DMatrices(ft2, 1);
    firingRateSmoothing=ft2;
    firingRateSmoothing2 = nan(size(firingRateSmoothing)+1);
    firingRateSmoothing2(1:end-1,1:end-1) = firingRateSmoothing;
    
    if ~isempty(threshSpatial_2)
        maxCount = threshSpatial_2;
    else
        for io1=1:1
            ftt2=firingRateSmoothing;
            ftt2(isnan(ftt2))=0;
            ftt2(ftt2==inf)=0;
            if max(max(ftt2))>maxfr2
                maxfr2=max(max(ftt2));
            end
         end
         maxCount=maxfr2;
    end
    

    %      subplot(length(segment),3,3*k)
    hand=subplot(numFig,plot_row,plot_row*k-(plot_row-4));

    try
        pcolor(firingRateSmoothing2);
        hold on;
        colormap(jet)
        caxis([0,max(firingRateSmoothing2(:))]);
        axis ij;
        axis image
%         colorbar('eastoutside');
        % set(gca, 'color', 'w', 'ydir', 'reverse')
        
        posObjects=ceil(behavcell{1,sectionindex}.object./binsize);
        if sum(posObjects)~=0
            for i5 = 1:size(posObjects,1)
                scatter(posObjects(i5,1)+1,size(firingRateSmoothing,1)-posObjects(i5,2)+1,binsize*2,'k','filled')
            end
        end
        
        shading flat;
%         axis square
%         axis image
        % axis off
        title([labfr2],'FontName','Arial','FontSize',8,'FontWeight','bold')
        hold off
        colorbar('position',[0.90,hand.Position(2),0.01,hand.Position(4)]);
        if mod(kk,numFig) ~= 0 
            set(gca,'Xtick',[])
        end
%         if mod(kk,numFig) == 0 || i==segment(length(segment))
% %             colorbar('eastoutside');
%             if mod(kk,numFig) == 0
%                 colorbar('position',[0.73,hand.Position(2),0.02,hand.Position(4)]);
%             end
%             if i==segment(length(segment))
%                 colorbar('position',[0.73,hand.Position(2),0.02,hand.Position(4)]);
%             end
%         end
    catch
        continue;
    end
    
%      %% plot cell firing map 3 (firing rate by default, change the parameter outside to change this)
%     if isempty(firingRate3{i})
%         for iii=1:length(firingRate3)
%             if ~isempty(firingRate3{1,iii})          
%                 [mm,nn]=size(firingRate3{1,iii});
%                 break;
%             end
%         end
%         firingRate3{i}=zeros(mm,nn);
%     end
%     ft3=firingRate3{i};
%     ft3(isnan(ft3))=0;
%     ft3(ft3==inf)=0;
%     
%     if ~isempty(threshSpatial_3)
%         maxCount = threshSpatial_3;
%     else
%          maxCount=maxfr3;
%     end
%     
%     firingRateSmoothing = filter2DMatrices(ft3, 1);
%     firingRateSmoothing2 = nan(size(firingRateSmoothing)+1);
%     firingRateSmoothing2(1:end-1,1:end-1) = firingRateSmoothing;
%     %      subplot(length(segment),3,3*k)
%     hand=subplot(numFig,plot_row,plot_row*k-(plot_row-4));
% 
%     try
%         pcolor(firingRateSmoothing2);
%         hold on;
%         colormap(jet)
%         caxis([0,max(maxCount)]);
% %         axis ij;
%         axis image
% %         colorbar('eastoutside');
%         % set(gca, 'color', 'w', 'ydir', 'reverse')
%         
%         posObjects=ceil(behavcell{1,sectionindex}.object./binsize);
%         if sum(posObjects)~=0
%             for i5 = 1:size(posObjects,1)
%                 scatter(posObjects(i5,1)+1,posObjects(i5,2)+1,binsize*2,'k','filled')
%             end
%         end
%         
%         shading flat;
% %         axis square
% %         axis image
%         % axis off
%         title([labfr3],'FontName','Arial','FontSize',8,'FontWeight','bold')
%         hold off
% 
%         if mod(kk,numFig) ~= 0 
%             set(gca,'Xtick',[])
%         end
%         if mod(kk,numFig) == 0 || i==segment(length(segment))
% %             colorbar('eastoutside');
%             if mod(kk,numFig) == 0
%                 colorbar('position',[0.9,hand.Position(2),0.02,hand.Position(4)]);
%             end
%             if i==segment(length(segment))
%                 colorbar('position',[0.9,hand.Position(2),0.02,hand.Position(4)]);
%             end
%         end
%     catch
%         continue;
%     end
        set(gcf,'renderer','painters');
    if mod(kk,numFig) == 0 || kk == max(segment)
        saveas(gcf,fullfile(fpath,strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'_ct.fig')))
        saveas(gcf,fullfile(fpath,strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'_ct.tif')))
        saveas(gcf,fullfile(fpath,strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'_ct.eps')),'epsc')
    end
end
%     saveas(gcf,fullfile(fpath,strcat('CellFiringBeaviorSpatial','.tif')))
%     saveas(gcf,fullfile(fpath,strcat('CellFiringBeaviorSpatial','.fig')))

