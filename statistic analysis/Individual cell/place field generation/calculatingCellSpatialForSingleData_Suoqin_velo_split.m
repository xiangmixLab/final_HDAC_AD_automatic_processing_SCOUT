function [firingRateAll,countAll,countTimeAll,countTime,amplitudeAll,amplitude_rateAll,binInfo] = calculatingCellSpatialForSingleData_Suoqin_velo_split(neuron,behavpos,behavtime,behavROI,binsize,segments,threshold,temp,intensity,plotting,countTimeThresh,velo_thresh)
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
if ~exist('segments','var') || isempty(segments)
    segments = 1:size(neuron.C,1);
end
if ~exist('binsize','var') || isempty(binsize)
    binsize = 15;%attention: value has been 5, 10, 15
end
if ~exist('countTimeThresh','var') || isempty(countTimeThresh)
    countTimeThresh = [0 10000000]; % unit: sec
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

folderName = 'FiguresCellSpatial';
if ~exist(folderName,'dir')
    mkdir(folderName)
end

global ts pos1 pos2
num = length(segments);

pos1 = 0:binsize:ceil(behavROI(3));
pos2 = 0:binsize:ceil(behavROI(4));
binInfo.binsize = binsize;binInfo.pos1 = pos1;binInfo.pos2 = pos2;
binInfo.xpos = [min(neuron.pos(:,1)),max(neuron.pos(:,1))];
binInfo.ypos = [min(neuron.pos(:,2)),max(neuron.pos(:,2))];

%% velo thresh determine % added 041720

d_behavpos=zeros(size(behavpos,1)-1,1);
for ll=2:size(behavpos,1)
    d_behavpos(ll-1,1)=norm((behavpos(ll,:)-behavpos(ll-1,:)));
end
d_behavtime=diff(behavtime)/1000;
velo=d_behavpos./d_behavtime;

small_velo_idx=find(velo<velo_thresh);
large_velo_idx=find(velo>=velo_thresh);

slow_period=behavtime*0;
slow_period(small_velo_idx+1)=1;
fast_period=behavtime*0;
fast_period(large_velo_idx+1)=1;

slow_period_res=interp1(behavtime,slow_period,neuron.time); %%
fast_period_res=interp1(behavtime,fast_period,neuron.time); %%

%% countTime calculation
countTime = zeros(length(pos1),length(pos2));
countTime_slow = zeros(length(pos1),length(pos2));
countTime_fast = zeros(length(pos1),length(pos2));
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
            countTime_slow(idxxi,idyyi) = countTime(idxxi,idyyi)+behavtime(j)-behavtime(j-1);
            countTime_fast(idxxi,idyyi) = countTime(idxxi,idyyi)+behavtime(j)-behavtime(j-1);
            if fast_period(j)==1
                countTime_slow(idxxi,idyyi) = countTime(idxxi,idyyi)-(behavtime(j)-behavtime(j-1));
            end
            if slow_period(j)==1
                countTime_fast(idxxi,idyyi) = countTime(idxxi,idyyi)-(behavtime(j)-behavtime(j-1));
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
countTime_slow = countTime_slow'/1000;
countTime_fast = countTime_fast'/1000;


%%
firingRateAll = cell(num,3);
countAll = cell(num,3);
countTimeAll = cell(1,3);
amplitudeAll = cell(num,3);
amplitude_rateAll=cell(num,3);

for k = 1:num
    if strcmpi(temp,'trace')
        if length(threshold) <= 1&&threshold==0.1
            thresh = (max(neuron.trace(segments(k),:))-0)*threshold; % the threshold above which the neuron is active
        else
            thresh = threshold(segments(k));
        end
        [pks,locs] = findpeaks(neuron.trace(segments(k),:),'MinPeakHeight',thresh);
        idx = locs;
    elseif strcmpi(temp,'S')
        if length(threshold) <= 1&&threshold==0.1
            thresh = (max(neuron.S(segments(k),:))-0)*threshold; % the threshold above which the neuron is active
        else
            thresh = threshold(segments(k));
        end
        idx = find(neuron.S(segments(k),:)>thresh);
    elseif strcmpi(temp,'C')
        if length(threshold) <= 1&&threshold==0.1
            thresh = (max(neuron.C(segments(k),:))-0)*threshold; % the threshold above which the neuron is active
        else
            thresh = threshold(segments(k));
        end
        idx = find(neuron.C(segments(k),:)>thresh);
    end
    if ~isempty(idx)
        
        idx_fast=idx;
        idx_slow=idx;
        idx_fast(ismember(idx,intersect(idx,find(slow_period_res==1))))=[];        
        idx_slow(ismember(idx,intersect(idx,find(fast_period_res==1))))=[];   
        
        count = countingFiringBins(idx,neuron);
        count_slow = countingFiringBins(idx_slow,neuron);
        count_fast = countingFiringBins(idx_fast,neuron);
        
        amplitude = countingAmplitudeFiringBins(idx,neuron,segments(k));
        amplitude_slow = countingAmplitudeFiringBins(idx_slow,neuron,segments(k));
        amplitude_fast = countingAmplitudeFiringBins(idx_fast,neuron,segments(k));
        
        %% small time threshold && long time threshold
        countTime_smaller_than_thr=countTime<countTimeThresh(1); %0.2sec
        count(countTime_smaller_than_thr)=0;
        amplitude(countTime_smaller_than_thr) = 0;
        count_slow(countTime_smaller_than_thr)=0;
        amplitude_slow(countTime_smaller_than_thr) = 0;
        count_fast(countTime_smaller_than_thr)=0;
        amplitude_fast(countTime_smaller_than_thr) = 0;        
        countTime_larger_than_thr=countTime>countTimeThresh(2); %10sec
        count(countTime_larger_than_thr)=0;
        amplitude(countTime_larger_than_thr) = 0;
        count_slow(countTime_larger_than_thr)=0;
        amplitude_slow(countTime_larger_than_thr) = 0;
        count_fast(countTime_larger_than_thr)=0;
        amplitude_fast(countTime_larger_than_thr) = 0;  
        
        %% countTime == 0 bin remove (original countTime applies to slow and fast)
        count(countTime == 0) = 0;
        count_slow(countTime == 0) = 0;
        count_fast(countTime == 0) = 0;
        amplitude(countTime == 0) = 0;
        amplitude_slow(countTime == 0) = 0;
        amplitude_fast(countTime == 0) = 0;
        
        %% calculate rate
        amplitude_rate = amplitude./countTime;
        amplitude_rate_slow=amplitude_slow./countTime_slow;
        amplitude_rate_fast=amplitude_fast./countTime_fast;
        
        firingRate = count./countTime;
        firingRate_slow = count_slow./countTime_slow;
        firingRate_fast = count_fast./countTime_fast;
        
        %% output
        firingRateAll{k,1} = firingRate;
        firingRateAll{k,2} = firingRate_slow;
        firingRateAll{k,3} = firingRate_fast;
        
        countAll{k,1} = count;
        countAll{k,2} = count_slow;
        countAll{k,3} = count_fast;
        
        countTimeAll{1,1} = countTime;
        countTimeAll{1,2} = countTime_slow;
        countTimeAll{1,3} = countTime_fast;
        
        amplitudeAll{k,1} = amplitude;
        amplitudeAll{k,2} = amplitude_slow;
        amplitudeAll{k,3} = amplitude_fast;
        
        amplitude_rateAll{k,1} = amplitude_rate;
        amplitude_rateAll{k,2} = amplitude_rate_slow;
        amplitude_rateAll{k,3} = amplitude_rate_fast;
    end
end

function count=countingFiringBins(idx,neuron)
global pos1 pos2
count = zeros(length(pos1),length(pos2));
for i = 1:length(idx)
    % if idx(i)<=length(neuron.pos) %sometimes in behav data, the position is less longer than neuron.S, which cause crash
    [~,idxx] = find(pos1 <= neuron.pos(idx(i),1), 1, 'last');
    [~,idyy] = find(pos2 <= neuron.pos(idx(i),2), 1, 'last');
    count(idxx,idyy) = count(idxx,idyy)+1;
    % end
end
count = count';


function amplitude = countingAmplitudeFiringBins(idx,neuron,k)
global pos1 pos2
amplitude = zeros(length(pos1),length(pos2));
for i = 1:length(idx)
    % if idx(i)<=length(neuron.pos) %sometimes in behav data, the position is less longer than neuron.S, which cause crash
    [~,idxx] = find(pos1 <= neuron.pos(idx(i),1), 1, 'last');
    [~,idyy] = find(pos2 <= neuron.pos(idx(i),2), 1, 'last');
    amplitude(idxx,idyy) = amplitude(idxx,idyy)+neuron.C(k,idx(i));
    % end
end
amplitude = amplitude';

