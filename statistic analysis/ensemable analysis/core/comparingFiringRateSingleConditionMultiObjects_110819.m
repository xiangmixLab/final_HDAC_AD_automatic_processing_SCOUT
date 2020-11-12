function [firingRateSmoothing2,sumFiringRateObject,sumFiringRate_smooth,sumFiringRate,radius,posObjects,sumFiringRateObject_individual,sumFiringRate_conv,sumCountTimeObject,sumFiringRateObject_2nd] = comparingFiringRateSingleConditionMultiObjects_110819(firingRate,binsize,countTime, pos,measures,colorscale,plotting,addindex,objname,segments)
%maxCount = 4;                                                                                                                                                                                                                                        (firingRate,binsize,countTime, pos,variables,colorscale,plotting,addindex,objname)

sumFRO2nd_range=1;
if ~exist('segments','var') || isempty(segments)
    segments = 1:length(firingRate);
end

if length(firingRate)>1
firingRate = firingRate(segments);
end
posObjects = ceil(pos./binsize);
radius = 3;

[sumFiringRateObject_individual,sumFiringRate,sumFiringRate_conv] = calculatingSumFiringRate(firingRate,radius,countTime,posObjects);

cellnum=0;
for i=1:size(firingRate,2)
    if ~isempty(firingRate{i})
        cellnum=cellnum+1;
    end
end

if cellnum>0
sumFiringRate=sumFiringRate/cellnum;
sumFiringRate_conv=sumFiringRate_conv/cellnum;
end

sumFiringRateObject = zeros(1,size(posObjects,1));
sumFiringRateObject_2nd=zeros(1,size(posObjects,1));
sumCountTimeObject=zeros(1,size(posObjects,1));

if sum(posObjects(:))~=0
    for i = 1:size(posObjects,1)
        sumFiringRateObject(1,i) = sumFiringRate_conv(size(sumFiringRate_conv,1)-posObjects(i,2)+1,posObjects(i,1));
        sumCountTimeObject(1,i)=countTime(size(sumFiringRate_conv,1)-posObjects(i,2)+1,posObjects(i,1));
        sumFiringRate(size(sumFiringRate_conv,1)-posObjects(i,2)+1,posObjects(i,1)) = sumFiringRateObject(1,i);
        sumFiringRateObject_2nd(i) = nansum(nansum(sumFiringRate_conv(size(sumFiringRate,1)-posObjects(i,2)+1-sumFRO2nd_range:size(sumFiringRate,1)-posObjects(i,2)+1+sumFRO2nd_range,posObjects(i,1)-sumFRO2nd_range:posObjects(i,1)+sumFRO2nd_range)));%old hdac use this, selectObject is not in the same cooridation sys with behav.position
    end
    sumFiringRateObject(isnan(sumFiringRateObject)) = 0;
else
    sumFiringRateObject=nan(1,size(posObjects,1));
end
%% the following if controls what map looks like
if 1
    sumFiringRate11=sumFiringRate;
    sumFiringRate_smooth = filter2DMatrices(sumFiringRate11, 1);
else
    sumFiringRate_smooth = sumFiringRate_conv;
end
firingRateSmoothing2 = nan(size(sumFiringRate_smooth)+1);
firingRateSmoothing2(1:end-1,1:end-1) = sumFiringRate_smooth;


if plotting==1
    
    folderName = 'FiguresCellSpatial';
    if ~exist(folderName,'dir')
        mkdir(folderName);
    end
    
    figure;
    
    subplot(1,2,1)
    pcolor(firingRateSmoothing2);
    colormap(jet)
    colorbar;
    if ~isempty(colorscale)
        caxis([min(colorscale) max(max(colorscale),max(sumFiringRate_smooth(:)))]);
    else
    end
    axis ij
    shading flat;
    axis image
    axis off
    hold on
    if sum(posObjects(:))~=0
        for i = 1:size(posObjects,1)
            hold on
            scatter(posObjects(i,1),size(sumFiringRate,1)-posObjects(i,2)+1,binsize*5,'k','filled')
            if addindex==1
                text(posObjects(i,1),size(sumFiringRate,1)-posObjects(i,2)-2,[objname{i}],'FontSize',14);
            end
            
        end
    end
    
    subplot(1,2,2)
    b=bar([1:size(sumFiringRateObject,2)],sumFiringRateObject,'FaceColor','flat');hold on
    Objectstitle=cell(1,size(posObjects,1));
    if sum(posObjects(:))~=0
        for i=1:size(posObjects,1)
            Objectstitle{i}=objname{i};
        end
    else
        Objectstitle{1}=['No Object'];
    end
    set(gca,'Xticklabel',Objectstitle,'FontName','Arial','FontSize',8)
    ylabel(['Sum of ',measures],'FontSize',10,'FontName','Arial')
    
end


function [sumFiringRateObject,sumFiringRate,sumFiringRate_conv] = calculatingSumFiringRate(firingRate,radius,countTime,posObjects)
if cellfun(@length,firingRate)==0
    firingRate={zeros(size(countTime))};
    disp('firingrate not exist');
end
f = ones(2*radius-1);% this is sum
% f = ones(2*radius-1)/sum(sum(ones(2*radius-1))); % this is average
idx = find(cellfun(@length,firingRate));
sumFiringRate = zeros(size(firingRate{idx(1)}));
sumFiringRate_conv = zeros(size(firingRate{idx(1)}));
sumFiringRateObject = zeros(length(firingRate),size(posObjects,1));

for i = 1:length(firingRate)
    if length(firingRate)>1
        if isempty(firingRate{i})
            continue;
        end
        firingRate{i}(isnan(firingRate{i})) = nan;
        firingRate{i}(firingRate{i}==inf) = nan;
        firingRate{i}(countTime==0) = nan;
        sumFiringRate_conv = sumFiringRate_conv + nanconv(firingRate{i},f);
        sumFiringRate = sumFiringRate + firingRate{i};
        for o = 1:size(posObjects,1)
            if sum(sum(posObjects))>0
                fr=nanconv(firingRate{i},f);
                sumFiringRateObject(i,o) = fr(size(sumFiringRate_conv,1)-posObjects(o,2)+1,posObjects(o,1));
                
            else
                sumFiringRateObject(i,o)=0;
            end
        end
    else
        if isempty(firingRate{i})
            continue;
        end
        firingRate{i}(isnan(firingRate{i})) = 0;
        firingRate{i}(firingRate{i}==inf) = 0;
        firingRate{i}(countTime==0) = nan;
        firingRate1t = firingRate{i};
        firingRate1t(firingRate1t==0)=nan;
        sumFiringRate = sumFiringRate + firingRate{i};
        sumFiringRate_conv=sumFiringRate_conv + nanconv(firingRate1t,f);
        sumFiringRate_conv(isnan(sumFiringRate_conv))=0;
        for o = 1:size(posObjects,1)
            if sum(sum(posObjects))>0
                fr = nanconv(firingRate{i},f);
                sumFiringRateObject(i,o) = fr(size(sumFiringRate_conv,1)-posObjects(o,2)+1,posObjects(o,1));%old hdac use this, selectObject is not in the same cooridation sys with behav.position
            else
                sumFiringRateObject(i,o)=0;
            end
        end
    end
end
sumFiringRate(countTime == 0) = NaN;



