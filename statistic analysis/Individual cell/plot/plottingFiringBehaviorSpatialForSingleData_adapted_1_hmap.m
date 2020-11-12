function plottingFiringBehaviorSpatialForSingleData_adapted_1_hmap(neuron,behavpos,behavtime,behavROI,firingRate,labfr1,segment,threshFiring,threshSpatial,conditionfolder,sectionindex,binsize,tempname,behavcell,place_cells,countTime,all_condition_max)

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
folderName = [conditionfolder{sectionindex},'/','FiguresFiringBehaviorSpatial'];
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

maxfr1=0;
maxfr2=0;
maxfr3=0;

radius=3;
% maxft11=zeros(1,size(firingRate,2));
% maxft13=zeros(1,size(firingRate,2));
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
%     if ~isempty(ft1)
%         maxft11(1,i)=max(max(ft1));
%         if max(max(ft1))>maxfr1
%             maxfr1=max(max(ft1));
%         end
%     end
%     if ~isempty(ft3)
%         maxft13(1,i)=max(max(ft3));
%         if max(max(ft3))>maxfr3
%             maxfr3=max(max(ft3));
%         end
%     end
% end

% display_corr=0;%make display looks better
% 
% maxfr1=maxfr1-display_corr;
% maxfr3=maxfr3-display_corr;

plot_row=3;
    
for i = segment
    
    kk = kk+1;
    if mod(kk-1,numFig) == 0
        ax = figure('visible','off');
        set(ax, 'Position', [100, 100, 1000, 1000]);
        k = 0;
    end
    
    
    %   thresh = (max(neuron.S(i,:))-min(neuron.S(i,:)))*0.1; % the threshold above which the neuron is active
    thresh = threshFiring(i);
     k = k+1;
    idx = neuron.S(i,:)>thresh;
    if isequal(tempname,'S')||isempty(tempname)
       idx = neuron.S(i,:)>thresh;
       max_pk=max(neuron.S(:));
    end
    if isequal(tempname,'trace')
       idx = neuron.trace(i,:)>thresh;
       max_pk=max(neuron.trace(:));
    end
    if isequal(tempname,'C')
       idx = neuron.C(i,:)>thresh;
       max_pk=max(neuron.C(:));
    end
%     idx=idx(idx<=length(neuron.pos));% sometimes neuron.S longer than neuron.pos due to behav data extraction
    %% ploting raw trace and its firing
    %     subplot(length(segment),3,3*k-2)
    subplot(numFig,plot_row,plot_row*k-(plot_row-1))
    %     subplot(5,2,plotPositionFiring)
    
    nC=neuron.C(i,:);
%     nC(nC<thresh)=0;
    nS=neuron.S(i,:);
%     nS(nC<thresh)=0;
    
    plot(nC, 'b')
    hold on
    plot(nS,'r')
    plot([0,length(nS)],[thresh thresh],'--','lineWidth',2)
    title(['Cell' num2str(i)],'FontSize',8,'FontName','Arial')
    set(gca,'FontSize',8)
    %     plot([0 neuron.num2read],thresh*[1 1],'k--')
    axis tight
    ylim([0 all_condition_max]);
%     ylim([0 max_pk]);% temporally added
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
    
    subplot(numFig,plot_row,plot_row*k-(plot_row-2))
    %     subplot(5,2,plotPositionPos)
    plot(neuron.pos(:,1),neuron.pos(:,2),'k')
    hold on
    idx=idx(1:length(neuron.pos(:,1)));
    plot(neuron.pos(idx,1),neuron.pos(idx,2),'r.','MarkerSize',1)
    plot(0,0);
    plot(behavROI(1,3),behavROI(1,4));
    
    posObjects=round(behavcell{1,sectionindex}.object);
    if sum(posObjects)~=0
        for i5 = 1:size(posObjects,1)
            scatter(posObjects(i5,1),max(max(neuron.pos(:,2)))-posObjects(i5,2)+1,binsize*2,'k','filled')
        end
    end

    title(['Cell' num2str(i)],'FontSize',8,'FontName','Arial')
    set(gca,'FontSize',8)
    axis image
     axis ij
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
%     ft1(ft1==0)=nan;
    
    if ~isempty(threshSpatial)
        maxCount = threshSpatial;
    else
        maxCount=maxfr1;
    end
    
%         firingRateSmoothing = filter2DMatrices(firingRate{i}, 1);
%     firingRateSmoothing2 = nan(size(firingRateSmoothing)+1);
%     firingRateSmoothing2(1:end-1,1:end-1) = firingRateSmoothing;
    firingRateSmoothing = filter2DMatrices(ft1, 1);
%     f = ones(2*radius-1)/sum(sum(ones(2*radius-1))); % this is average
%     firingRateSmoothing=nanconv(ft1,f);
    firingRateSmoothing(countTime==0)=nan;
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
        
        posObjects=round(behavcell{1,sectionindex}.object./binsize);
        if sum(posObjects)~=0
            for i5 = 1:size(posObjects,1)
                scatter(posObjects(i5,1)+1,size(firingRateSmoothing,1)-posObjects(i5,2)+1,binsize*2,'k','filled')
            end
        end
        
        shading flat;
%         axis square
%         axis image
        % axis off
        title([labfr1],'FontName','Arial','FontSize',8,'FontWeight','bold')
%         if ~isempty(find(place_cells==i))
%             title({'event count','(place cell)',['infoScore:',num2str(TinfoPerSecond.infoPerSecond(TinfoPerSecond.neuron==i))]},'FontName','Arial','FontSize',8,'FontWeight','bold')
%         else
%             title({'event count','(not place cell)',['infoScore:',num2str(TinfoPerSecond.infoPerSecond(TinfoPerSecond.neuron==i)),')']},'FontName','Arial','FontSize',8,'FontWeight','bold')
%         end
        if ~isempty(find(place_cells==i))
            title({labfr1,'(place cell)'},'FontName','Arial','FontSize',8,'FontWeight','bold')
        else
            title({labfr1,'(not place cell)'},'FontName','Arial','FontSize',8,'FontWeight','bold')
        end

        hold off

        if mod(kk,numFig) ~= 0 
            set(gca,'Xtick',[])
        end
        
        colorbar('position',[0.75,hand.Position(2),0.01,hand.Position(4)]);

    catch
        continue;
    end
    
    set(gcf,'renderer','painters');
    if mod(kk,numFig) == 0 || kk == max(segment)
        saveas(gcf,fullfile(fpath,strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'_',labfr1,tempname,'.fig')))
        saveas(gcf,fullfile(fpath,strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'_',labfr1,tempname,'.tif')))
        saveas(gcf,fullfile(fpath,strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'_',labfr1,tempname,'.eps')),'epsc')
        close all;
        disp(['fin ',strcat(experimentName,'_CellFiringBeaviorSpatial_',num2str(i),'_binsize',num2str(binsize),'_',labfr1,tempname,'.fig')])
    end   
end
%     saveas(gcf,fullfile(fpath,strcat('CellFiringBeaviorSpatial','.tif')))
%     saveas(gcf,fullfile(fpath,strcat('CellFiringBeaviorSpatial','.fig')))

