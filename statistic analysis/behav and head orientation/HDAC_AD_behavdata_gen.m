%%hdac_ad_auto behavpos and behav time

function [behavpos,behavtime,objects]=HDAC_AD_behavdata_gen(behavcell,timeindex,i,bluered)

if isequal(bluered,'red')
    behavpos=[behavcell{1,timeindex(i)+1}.position(1,:)];
    behavpos2=[behavcell{1,timeindex(i)+1}.positionblue(1,:)];
end
if isequal(bluered,'blue')
    behavpos=[behavcell{1,timeindex(i)+1}.positionblue(1,:)];
    behavpos2=[behavcell{1,timeindex(i)+1}.position(1,:)];
end
behavtime=[0];
objects=behavcell{1,timeindex(i)+1}.object;
for j=timeindex(i)+1:timeindex(i+1)
    if ~isempty(behavcell{j})
    if isequal(bluered,'red')
    behavpos=[behavpos;behavcell{1,j}.position(2:end,:)];
    behavtime=[behavtime;behavcell{1,j}.time(2:end)+max(behavtime)];
    end
    if isequal(bluered,'blue')
    behavpos=[behavpos;behavcell{1,j}.positionblue(2:end,:)];
    behavtime=[behavtime;behavcell{1,j}.time(2:end)+max(behavtime)];
    end
    end
end
