function [tuningMapAll,countAll,countTimeFrame,countTime] = neuronCtuningMapCal(neuron,behavpos,behavtime,behavROI,binsize,segments,threshold,countTimeThresh,small_velo)
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

if ~exist('threshold','var') || isempty(threshold)
    threshold = 0.1;
end
if ~exist('segments','var') || isempty(segments)
    segments = 1:size(neuron.C,1);
end
if ~exist('binsize','var') || isempty(binsize)
    binsize = 15;%attention: value has been 5, 10, 15
end
if ~exist('countTimeThresh','var') || isempty(countTimeThresh)
    countTimeThresh = [0 inf]; % unit: sec
end

if ~exist('small_velo','var') || isempty(small_velo)
    small_velo = -1; % unit: mm/sec
end

downsampling = length(neuron.time)/size(neuron.C,2);
if downsampling ~= 1
    %     downsampling == 2
    neuron.time = double(neuron.time);
    neuron.time = neuron.time(1:downsampling:end);
    neuron.time = resample(neuron.time,size(neuron.C,2),length(neuron.time));
end
t = find(diff(behavtime)<=0);
while ~isempty(t)
    behavtime(t+1) = behavtime(t)+1;
    t = find(diff(behavtime)<=0);
end
neuron.pos = interp1(behavtime,behavpos,neuron.time); %%

global ts pos1 pos2
num = length(segments);

pos1 = 0:binsize:ceil(behavROI(3));
pos2 = 0:binsize:ceil(behavROI(4));

binInfo.binsize = binsize;binInfo.pos1 = pos1;binInfo.pos2 = pos2;
binInfo.xpos = [min(neuron.pos(:,1)),max(neuron.pos(:,1))];
binInfo.ypos = [min(neuron.pos(:,2)),max(neuron.pos(:,2))];

%% small velo determine % added 061219

d_behavpos=zeros(size(behavpos,1)-1,1);
for ll=2:size(behavpos,1)
    d_behavpos(ll-1,1)=norm((behavpos(ll,:)-behavpos(ll-1,:)));
end
d_behavtime=diff(behavtime)/1000;
velo=d_behavpos./d_behavtime;
small_velo_idx=find(velo<small_velo);
slow_period=behavtime*0;
slow_period(small_velo_idx+1)=1;

%% countTime calculation
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
            if small_velo>0 && slow_period(j)==1 % added 061219
                countTime(idxxi,idyyi) = countTime(idxxi,idyyi)-(behavtime(j)-behavtime(j-1));
            end
        else
            ts = j;
            break;
        end
    end
    if ts < j
        break;
    end
end
countTime = countTime'/1000;%purpose: because behavtime is recorded in milisec.

countAll = cell(1,num);
tuningMapAll = cell(1,num);

for k = 1:num
    
    if length(threshold) <= 1
        thresh = (max(neuron.C(segments(k),:))-0)*threshold; % the threshold above which the neuron is active
    else
        thresh = threshold(segments(k));
    end
    
    idx = find(neuron.C(segments(k),:)>thresh);
%     idx1 = diff(neuron.C(segments(k),:));
    
    if ~isempty(idx)
        
        if small_velo>0 % added 061219
            slow_period=resample(slow_period,size(neuron.C,2),length(slow_period));
            idx(ismember(idx,intersect(idx,find(slow_period==1))))=[];
        end
        
%         idx(ismember(idx,find(idx1<=0)+1))=[]; % only pick upward calcium response (too little!)
        
        count = countingFiringBins(idx,neuron);
        countTimeFrame = countingFiringBins([1:size(neuron.pos,1)],neuron);

        %% small time threshold && long time threshold
        countTime_smaller_than_thr=countTime<countTimeThresh(1); %low
        count(countTime_smaller_than_thr)=0;
        countTimeFrame(countTime_smaller_than_thr)=0;
        countTime_larger_than_thr=countTime>countTimeThresh(2); %high
        count(countTime_larger_than_thr)=0;
        countTimeFrame(countTime_larger_than_thr)=0;
        
        count(countTime == 0) = 0;
        countTimeFrame(countTime == 0)=0;
        
        tuningMap = count./countTimeFrame;
        tuningMap(countTime == 0) = nan; 
          
        tuningMapAll{k} = tuningMap; 
        countAll{k} = count;
    end  
end

function count=countingFiringBins(idx,neuron)
global pos1 pos2
count = zeros(length(pos1),length(pos2));
for i = 1:length(idx)
    [~,idxx] = find(pos1 <= neuron.pos(idx(i),1), 1, 'last');
    [~,idyy] = find(pos2 <= neuron.pos(idx(i),2), 1, 'last');
    count(idxx,idyy) = count(idxx,idyy)+1;
end
count = count';

