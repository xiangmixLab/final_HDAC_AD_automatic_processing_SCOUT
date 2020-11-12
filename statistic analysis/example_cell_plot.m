function example_cell_plot(foldername,behavname_list,cond_idx,binsize,cellidx,colorscale_m,small_velo)

load([foldername,'\','neuronIndividuals_new.mat']);
load([foldername,'\','thresh_and_ROI.mat'])

figure;

if ~isempty(cond_idx)
    for i=1:length(neuronIndividuals)
        neuron_t{i}=neuronIndividuals_new{cond_idx(i)}.copy;
    end
    for i=1:length(neuronIndividuals)
        neuronIndividuals_new{i}=neuron_t{i}.copy;
    end
end

for i=1:length(neuronIndividuals_new)
    behavname=behavname_list{i};
    load(behavname);
    behavpos=behav.position;
    behavtime=behav.time;

    neuron=neuronIndividuals_new{i}.copy;
    nS=C_to_peakS(neuron.C);
    thresh=3*std(nS,[],2);
    
    [firingRateAll,~,countTimeAll] = calculatingCellSpatialForSingleData_Suoqin(neuron,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron.C,1),thresh,'S',0,0,[0 inf],small_velo);
    
    fr_t{i}=firingRateAll{cellidx};
end

for i=1:length(neuronIndividuals_new)
    max_fr_t(i)=max(max(fr_t{i}));
    min_fr_t(i)=min(min(fr_t{i}));
end

if isempty(colorscale_m)
    colorscale=[min(min_fr_t)+0.1*min(min_fr_t),max(max_fr_t)-0.1*max(max_fr_t)];
else
    colorscale=colorscale_m;
end

for i=1:length(neuronIndividuals_new)
    
    behavname=behavname_list{i};
    load(behavname);
    behavpos=behav.position;
    behavtime=behav.time;

    neuron=neuronIndividuals_new{i}.copy;
    nS=C_to_peakS(neuron.C);
    thresh=3*std(nS,[],2);
    
    [firingRateAll,~,countTimeAll] = calculatingCellSpatialForSingleData_Suoqin(neuron,behavpos,behavtime,maxbehavROI,binsize,1:size(neuron.C,1),thresh,'S',0,0,[0 inf],0);
    
    nC_t=nS(cellidx,:);
    nC_t=resample(nC_t,size(behavpos,1),length(nC_t));
    nS_t=C_to_peakS(nC_t);
    nS_t(nS_t<thresh(cellidx))=0;
    
    subplot(length(neuronIndividuals_new),3,(i-1)*3+1)
    plot(neuron.C(cellidx,:),'color','b');
    hold on;
    plot(nS(cellidx,:),'color','r');
    threshh=0.1*max(nS(cellidx,:));
    plot([1:10:size(nS,2)],ones(1,length([1:10:size(nS,2)]))*threshh,'--','color',[0 0 0.6],'lineWidth',2)
    ylim([0 150])
    
    subplot(length(neuronIndividuals_new),3,(i-1)*3+2)
    plot(behavpos(:,1),behavpos(:,2),'color','k');
    hold on;
    plot(behavpos(nS_t>0,1),behavpos(nS_t>0,2),'.','color','r','MarkerSize',5);
    axis image
    shading flat;
    
    subplot(length(neuronIndividuals_new),3,(i-1)*3+3)
    firingRateAll{cellidx}(countTimeAll{1}==0)=nan;
    pcolor(filter2DMatrices(firingRateAll{cellidx},1));
    axis image
    shading flat;
    colorbar;
    caxis(colorscale);
    colormap(jet);
end
set(gcf,'renderer','painters');    