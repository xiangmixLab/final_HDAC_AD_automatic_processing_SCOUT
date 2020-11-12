function [firingRateAll,countAll,countTimeAll,countTime,amplitudeAll,amplitude_rateAll,binInfo] = calculatingCellSpatialForSingleData_Suoqin_simplified(nS,ntime,behavpos,behavtime,behavROI,binsize,thresh,countTimeThresh,small_velo)

if ~exist('countTimeThresh','var') || isempty(countTimeThresh)
    countTimeThresh = [0 inf]; % unit: sec
end

if ~exist('small_velo','var') || isempty(small_velo)
    small_velo = -1; % unit: mm/sec
end

downsampling = length(behavtime)/size(nS,2);
if downsampling ~= 1
    ntime = double(ntime);
    ntime = ntime(1:downsampling:end);
    ntime = resample(ntime,size(nS,2),length(ntime));
end
t = find(diff(behavtime)<=0);
while ~isempty(t)
    behavtime(t+1) = behavtime(t)+1;
    t = find(diff(behavtime)<=0);
end
npos = interp1(behavtime,behavpos,ntime); %%

num = size(nS,1);

pos1 = 0:binsize:ceil(behavROI(3));
pos2 = 0:binsize:ceil(behavROI(4));

binInfo.binsize = binsize;binInfo.pos1 = pos1;binInfo.pos2 = pos2;
binInfo.xpos = [min(npos(:,1)),max(npos(:,1))];
binInfo.ypos = [min(npos(:,2)),max(npos(:,2))];

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

%%
maxCount = 5; %add this line when you obtain the maximum of maxCount after running once
firingRateAll = cell(1,num);
countAll = cell(1,num);
countTimeAll = cell(1,num);
amplitudeAll = cell(1,num);
amplitude_rateAll=cell(1,num);
for k = 1:num
    
    idx = find(nS(k,:)>thresh(k));

    if ~isempty(idx)

        if small_velo>0 % added 061219
            slow_period=resample(slow_period,size(nS,2),length(slow_period));
            idx(slow_period==1)=[];
        end

        neuron.C=nS;
        neuron.S=nS;
        neuron.pos=npos;
        
        count = countingFiringBins(idx,neuron,pos1,pos2);
        amplitude = countingAmplitudeFiringBins(idx,neuron,k,pos1,pos2);
        %% small time threshold && long time threshold
        countTime_smaller_than_thr=countTime<countTimeThresh(1); %lower
        count(countTime_smaller_than_thr)=0;
        amplitude(countTime_smaller_than_thr) = 0;
        countTime_larger_than_thr=countTime>countTimeThresh(2); %higher
        count(countTime_larger_than_thr)=0;
        amplitude(countTime_larger_than_thr) = 0;

        count(countTime == 0) = 0;
        amplitude(countTime == 0) = 0;
        amplitude_rate = amplitude./countTime;
        amplitude_rate(countTime == 0) = 0;

        firingRate = count./countTime;
        firingRate(countTime == 0) = 0;

        firingRateAll{k} = firingRate;
        countAll{k} = count;
        countTimeAll{k} = countTime;
        amplitudeAll{k} = amplitude;
        amplitude_rateAll{k} = amplitude_rate;
    end
end

function count=countingFiringBins(idx,neuron,pos1,pos2)
count = zeros(length(pos1),length(pos2));
for i = 1:length(idx)
    [~,idxx] = find(pos1 <= neuron.pos(idx(i),1), 1, 'last');
    [~,idyy] = find(pos2 <= neuron.pos(idx(i),2), 1, 'last');
    count(idxx,idyy) = count(idxx,idyy)+1;
    % end
end
count = count';

function amplitude = countingAmplitudeFiringBins(idx,neuron,k,pos1,pos2)
amplitude = zeros(length(pos1),length(pos2));
for i = 1:length(idx)
    [~,idxx] = find(pos1 <= neuron.pos(idx(i),1), 1, 'last');
    [~,idyy] = find(pos2 <= neuron.pos(idx(i),2), 1, 'last');
    amplitude(idxx,idyy) = amplitude(idxx,idyy)+neuron.C(k,idx(i));
    % end
end
amplitude = amplitude';

