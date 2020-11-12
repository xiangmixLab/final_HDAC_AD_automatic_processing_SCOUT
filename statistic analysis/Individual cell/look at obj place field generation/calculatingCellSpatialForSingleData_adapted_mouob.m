function [firingRateAll,countAll,countTime] = calculatingCellSpatialForSingleData_adapted_mouob(neuron,behavpos,behavtime,behavROI,binsize,Segment,threshold,temp,moutoob,intensity,plotting,range1,countTimeThresh)
%% Inputs:
%     neuron: a source2D variable, including identified neurons with traces and spatial information, which is obtained by runing cnmfe codes
%     behav: behavior information, which is obtained by using Tristan's code
% Segment: a vector, e.g,1:10 (display the traces of the first 10 identified neurons)
% threshold:the threshold above which the neuron is active, e.g.,0.1
% temp:judge whether the neuron is active using neuron.trace or neuron.S; temp = 'trace' ot temp = 'S'
% downsampling: if downsampling = true, then do downsampling for neuron.time; default is false
% intensity: if intensity = true, then diplay the peak map; otherwise display the heatmap of firating rate; default is false
%%% example usage: e.g.1. plottingCellSpatialForSingleData(neuron,behav,1:5)
%%%                e.g.2, plottingCellSpatialForSingleData(neuron,behav,1:5,0.1,'trace',true,true)
%%%                e.g.3, plottingCellSpatialForSingleData(neuron,behav,1:5,0.1,'trace')
if ~exist('plotting','var') || isempty(plotting)     
    plotting = false; 
end
if ~exist('intensity','var') || isempty(intensity)     
    intensity = false; 
end
if ~exist('temp','var') || isempty(temp)     
    temp = 'S'; 
end
if ~exist('threshold','var') || isempty(threshold)     
    threshold = 0.1; 
end
if ~exist('Segment','var') || isempty(Segment)     
    Segment = 1:size(neuron.trace,1); 
end
if ~exist('binsize','var') || isempty(binsize)
    binsize = 15;%attention: value has been 5, 10, 15
end


%close all
%     % temporal downsampling
% if downsampling
%     downsamplingFactor = 2;
%     neuron.time = neuron.time(1:downsamplingFactor:end);
%     neuron.time = double(neuron.time(1:neuron.num2read));
%     d=diff(behav.time);
%     t=find(d<=0);
%     behav.time(t+1)=behav.time(t)+1;
%     neuron.pos = interp1(behav.time,behav.position,neuron.time);
% end

downsampling = length(neuron.time)/size(neuron.C,2);
if downsampling ~= 1
%     downsampling == 2
neuron.time = double(neuron.time);
neuron.time = neuron.time(1:downsampling:end);
end
t = find(diff(behavtime)<=0);
behavtime(t+1) = behavtime(t)+1;
neuron.pos = interp1(behavtime,behavpos,neuron.time); %%


folderName = 'FiguresCellSpatial';
if ~exist(folderName,'dir')
    mkdir(folderName)
end
fpath=[folderName];
global ts pos1 pos2
num = length(Segment);
% binsize = 10;%% for OLM task 15

% binsize = 5;%%memory update 4 obj

%pos1 = 0:10:ceil(max(neuron.pos(:,1)));pos2 = 0:10:ceil(max(neuron.pos(:,2)));
% pos1 = 0:binsize:ceil(max(neuron.pos(:,1)));
% pos2 = 0:binsize:ceil(max(neuron.pos(:,2)));
pos1 = 0:binsize:ceil(behavROI(:,3));%we changed to ROI
pos2 = 0:binsize:ceil(behavROI(:,4));
% pos1 = 0:binsize:ceil(behavROI(:,3)*210/behavROI(:,3));%we changed to ROI
% pos2 = 0:binsize:ceil(behavROI(:,4)*210/behavROI(:,3));

%pos1 = [0    15    30    45    60    75    90   105   120   135   150 165   180   195];
%pos2 = [0    15    30    45    60    75    90   105   120   135   150   165   180   195   210   225   240   255];
% if max(pos1) < max(neuron.pos(:,1))
%     pos1 = [pos1 max(pos1)+binsize];
% end
% if max(pos2) < max(neuron.pos(:,2))
%     pos2 = [pos2 max(pos2)+binsize];
% end


[xpos1,ypos2] = meshgrid(pos1, pos2);
countTime = zeros(length(pos1),length(pos2));
ts = 1;
while ts < length(behavtime)
%     ts
    [~,idxxi] = find(pos1 <= behavpos(ts,1), 1, 'last');
    [~,idyyi] = find(pos2 <= behavpos(ts,2), 1, 'last');
    for j = ts+1:length(behavtime)
        [~,idxxj] = find(pos1 <= behavpos(j,1), 1, 'last');
        [~,idyyj] = find(pos2 <= behavpos(j,2), 1, 'last');
        if idxxj == idxxi & idyyj == idyyi
            countTime(idxxi,idyyi) = countTime(idxxi,idyyi)+behavtime(j)-behavtime(j-1);
        else
            ts = j;
            break;
        end
    end
    if ts < j
        break;
    end
end
countTime = countTime'/1000; %purpose? convert to milisec
% countTime = countTime';
% figure
% imagesc(countTime);
% % pcolor(xpos1,ypos2,countTime);
% % set(h,'EdgeColor','none')
% caxis ([0,max(countTime(:))])
% newmap = jet(256);
% newmap(1,:) = [1 1 1];
% colormap(newmap);
% colorbar
% figure
% countTime2 = nan(size(countTime)+1);
% countTime2(1:end-1,1:end-1) = countTime;
% countTime2(countTime2 == 0) = NaN;
% pcolor(countTime2);
% colormap(jet)
% colorbar;
% set(gca, 'color', 'w', 'ydir', 'reverse')
% shading flat;
% % shading interp
% axis image

%maxCount = zeros(1,num);
 maxCount = 3; %add this line when you obtain the maximum of maxCount after running once
% firingRateAll = zeros(length(pos1),length(pos2),num);
% countAll = zeros(length(pos1),length(pos2),num);
firingRateAll = cell(1,num);
countAll = cell(1,num);
for k = 1:num
    
    if strcmpi(temp,'trace')
        if max(threshold) < 1
        thresh = (max(neuron.trace(Segment(k),:))-0)*threshold; % the threshold above which the neuron is active
        else
            thresh = threshold(Segment(k));
        end
        idx = neuron.trace(Segment(k),:)>thresh;
    elseif strcmpi(temp,'S')
        if max(threshold) < 1
        thresh = (max(neuron.trace(Segment(k),:))-0)*threshold; % the threshold above which the neuron is active
        else
            thresh = threshold(Segment(k));
        end
        idx = neuron.S(Segment(k),:)>thresh;
     elseif strcmpi(temp,'C')
        if max(threshold) < 1
        thresh = (max(neuron.C(Segment(k),:))-0)*threshold; % the threshold above which the neuron is active
        else
            thresh = threshold(Segment(k));
        end
        idx = neuron.C(Segment(k),:)>thresh;
    end
    if ~isempty(idx)
        idx(moutoob==0)=0;
        idx=find(idx==1);
        count = countingFiringBins(idx,neuron);
        
        %% 100318 0.2sec threshold && 102418 10 sec threshold
        countTime_smaller_than_thr=countTime<countTimeThresh(1); %0.2sec
        count(countTime_smaller_than_thr)=0;
        countTime(countTime_smaller_than_thr)=0;
        
        countTime_larger_than_thr=countTime>countTimeThresh(2); %10sec
        count(countTime_larger_than_thr)=0;
        
        firingRate = count./countTime;
%         firingRate(countTime == 0) = NaN;
        firingRate(isnan(firingRate))=0;
        
        firingRate2 = nan(size(firingRate)+1);
        firingRate2(1:end-1,1:end-1) = firingRate;
        countTime2 = nan(size(countTime)+1);
        countTime2(1:end-1,1:end-1) = countTime;
%         firingRate2(countTime2 == 0) = NaN;
        firingRate2(isnan(firingRate2))=0;
%         maxCount = max(firingRate(:));
        if plotting
            figure;
%              pcolor(firingRate2);
            firingRateSmoothing = filter2DMatrices(firingRate2, 1);
            pcolor(firingRateSmoothing);
            colormap(jet)
            %  maxCount(k) = max(firingRate(:)); % comment this line when you obtain the maximum of maxCount after running once
            caxis([0,max(maxCount)])
            colorbar;
            set(gca, 'color', 'w', 'ydir', 'reverse')
            shading flat;
            if intensity
                shading interp
            end
            axis image
            axis off;
                    
            title(['Cell #', num2str(Segment(k))],'FontName','Arial','FontSize',10,'FontWeight','bold')
            hold off
                     saveas(gcf,fullfile(fpath,['CellSpatialMatch',num2str(Segment(k)),'.tif']))
         saveas(gcf,fullfile(fpath,['CellSpatialMatch',num2str(Segment(k)),'.fig']))
        end
        
%         firingRate=filter2DMatrices(firingRate,1);
%         count=filter2DMatrices(count,1);
        firingRateAll{k} = firingRate;
        countAll{k} = count;
%         countTime=countTime;
        %     firingRateAll(:,:,k) = firingRate;
        %     countAll(:,:,k) = count;
    end
    
    %max(maxCount)
    
end

function count=countingFiringBins(idx,neuron)
global pos1 pos2
count = zeros(length(pos1),length(pos2));
for i = 1:length(idx)
    if idx(i)<=length(neuron.pos) %sometimes in behav data, the position is less longer than neuron.S, which cause crash
    [~,idxx] = find(pos1 <= neuron.pos(idx(i),1), 1, 'last');
    [~,idyy] = find(pos2 <= neuron.pos(idx(i),2), 1, 'last');
    count(idxx,idyy) = count(idxx,idyy)+1;
    end
end
count = count';
% count(end+1,:) = count(end,:);
% count(:,end+1) = count(:,end);

