function countTime=calculateSlowPeriodcountTime(behavpos,behavtime,slow_period,binsize,ROI)
pos1=0:binsize:ROI(3);
pos2=0:binsize:ROI(4);
countTime = zeros(length(pos1),length(pos2));
countTime_map_slow = zeros(length(pos1),length(pos2));
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
            if slow_period(j)==1
                countTime_map_slow(idxxi,idyyi)=1;
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
countTime=countTime.*countTime_map_slow;