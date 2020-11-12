function countDat=binmap_gen(behavpos,behavROI,dat,binsize,small_velo)

pos1 = 0:binsize:ceil(behavROI(3));
pos2 = 0:binsize:ceil(behavROI(4));

if small_velo>0
    d_behavpos=zeros(size(behavpos,1)-1,1);
    for ll=2:size(behavpos,1)
        d_behavpos(ll-1,1)=norm((behavpos(ll,:)-behavpos(ll-1,:)));
    end
    d_behavtime=diff(behavtime)/1000;
    velo=d_behavpos./d_behavtime;
    small_velo_idx=find(velo<small_velo);
    slow_period=behavtime*0;
    slow_period(small_velo_idx+1)=1;
end

countDat = zeros(length(pos1),length(pos2));
dat_num = zeros(length(pos1),length(pos2));
ts = 1;
while ts < length(dat)
    %     ts
    [~,idxxi] = find(pos1 <= behavpos(ts,1), 1, 'last');
    [~,idyyi] = find(pos2 <= behavpos(ts,2), 1, 'last');
    for j = ts+1:length(dat)
        [~,idxxj] = find(pos1 <= behavpos(j,1), 1, 'last');
        [~,idyyj] = find(pos2 <= behavpos(j,2), 1, 'last');
        if idxxj == idxxi & idyyj == idyyi
            countDat(idxxi,idyyi) = countDat(idxxi,idyyi)+dat(j);
            dat_num(idxxi,idyyi)=dat_num(idxxi,idyyi)+1;
            if small_velo>0 && slow_period(j)==1 % added 061219
                countDat(idxxi,idyyi) = countDat(idxxi,idyyi)-(dat(j));
                dat_num(idxxi,idyyi)=dat_num(idxxi,idyyi)-1;
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
countDat=countDat./dat_num; % take average 
