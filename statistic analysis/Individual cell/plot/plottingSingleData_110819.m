function plottingSingleData_110819(neuron,behavpos,behavtime,behavROI,firingRate,labfr1,segment,threshSpatial,conditionfolder,binsize,tempname,object,countTime)

%% This function is used to overlay the neuron activity onto behaviors
% Inputs:
%        (1) neuron: a source2D variable, including identified neurons with traces and spatial information, which is obtained by runing cnmfe codes
%        (2) behav: behavior information, which is obtained by using Tristan's code
%        (3) Segment: a vector, e.g,1:10 (display the traces of the first 10 identified neurons)
%         (4) downsampling rate [e.g., by a factor of 2]

% Important parameter in the code: thresh, the threshold above which the neuron is active. By default, it is 10% of the maximum trace value of each neuron

%'axis image' make the cell firing and behav trace plot looks in same ratio. 

%% save direction name
experimentName=[conditionfolder];
folderName = [conditionfolder,'/','FiguresFiringBehaviorSpatial'];
if ~exist(folderName,'dir')
    mkdir(folderName);
end
fpath=[folderName '/'];

%% downsample neuron time
downsampling = length(neuron.time)/size(neuron.trace,2);
if downsampling ~= 1
    neuron.time = double(neuron.time);
    neuron.time = neuron.time(1:downsampling:end);
end
temp = find(diff(behavtime)<=0);
behavtime(temp+1) = behavtime(temp)+1;
neuron.pos = interp1(behavtime,behavpos,neuron.time); %%


numFig = 10;
k = 0;kk = 0;
plot_row=3;
threshFiring=3*std(neuron.S,[],2);    

for i = 1:size(neuron.C,1)
    
    kk = kk+1;
    if mod(kk-1,numFig) == 0
        ax = figure('visible','off');
        set(ax, 'Position', [100, 100, 1000, 1000]);
        k = 0;
    end
    
    thresh = threshFiring(i);
    k = k+1;
    idx = neuron.S(i,:)>thresh;
    
    %% ploting raw trace and its firing
    subplot(numFig,plot_row,plot_row*k-(plot_row-1))
    
    nC=neuron.C(i,:);
    nS=neuron.S(i,:);
    
    plot(nC,'b')
    hold on
    plot(nS,'r')
    plot([0,length(nS)],[thresh thresh],'--','lineWidth',2)
    title(['Cell' num2str(i)],'FontSize',8,'FontName','Arial')
    set(gca,'FontSize',8)
    axis tight
    hold off
    set(gca,'Xtick',[])
    if mod(kk,numFig) == 0 || kk == max(segment)
        set(gca,'Xtick',[1 ceil(neuron.num2read/2) neuron.num2read])
    end
    
%% plotting animal behavior trajectries
    
    subplot(numFig,plot_row,plot_row*k-(plot_row-2))
    plot(neuron.pos(:,1),neuron.pos(:,2),'k')
    hold on
    idx=idx(1:length(neuron.pos(:,1)));
    plot(neuron.pos(idx,1),neuron.pos(idx,2),'r.','MarkerSize',1)
    plot(0,0);
    plot(behavROI(1,3),behavROI(1,4));
    
    posObjects=object;
    if sum(posObjects)~=0
        for i5 = 1:size(posObjects,1)
            scatter(posObjects(i5,1),max(max(neuron.pos(:,2)))-posObjects(i5,2)+1,binsize*2,'k','filled')
        end
    end

    title(['Cell' num2str(i)],'FontSize',8,'FontName','Arial')
    set(gca,'FontSize',8)
    axis image
    axis ij
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
    
    firingRateSmoothing = filter2DMatrices(ft1, 1);
    firingRateSmoothing(countTime==0)=nan;
    firingRateSmoothing2 = nan(size(firingRateSmoothing)+1);
    firingRateSmoothing2(1:end-1,1:end-1) = firingRateSmoothing;
    
    hand=subplot(numFig,plot_row,plot_row*k-(plot_row-3));

    try
        pcolor(firingRateSmoothing2);
        hold on;
        colormap(jet)
        axis ij;
        axis image
        
        posObjects=round(object./binsize);
        if sum(posObjects)~=0
            for i5 = 1:size(posObjects,1)
                scatter(posObjects(i5,1)+1,size(firingRateSmoothing,1)-posObjects(i5,2)+1,binsize*2,'k','filled')
            end
        end
        
        shading flat;
        title([labfr1],'FontName','Arial','FontSize',8,'FontWeight','bold')

        hold off

        if mod(kk,numFig) ~= 0 
            set(gca,'Xtick',[])
        end
        
        if ~isempty(threshSpatial)
            max_fr=threshSpatial;
        else
            max_fr=max(firingRateSmoothing2(:));
        end
        caxis([0, max_fr]);
        colorbar('position',[0.85,hand.Position(2),0.01,hand.Position(4)]);

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

