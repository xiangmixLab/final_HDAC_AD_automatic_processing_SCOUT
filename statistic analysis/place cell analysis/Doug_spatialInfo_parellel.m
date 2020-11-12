function [infoPerSecond, infoPerSpike]=Doug_spatialInfo_parellel(firingrateAll,countTime,occThresh,countAll)
%% 'spatialInfo' returns Skaggs spatial information per spike and per second
% Input: 'rm' 2D ratemap of firing activity for a single neuron
%        'occ' 2D occupancy map for the session corresponding to the
%         activity of the neuron
%        'occThresh' occupancy threshold (an integer) of 2D bins to include
% Output: 'infoPerSecond' information per second
%         'infoPerSpike' information per spike

for j = 1:length(firingrateAll)
    rm=firingrateAll{j};
    occ=countTime;
    Ro= sum(sum(countAll{1,j}))/sum(sum(occ));
    
    if length(occThresh)==1
        rm(occ<=occThresh) = NaN;
        occ(occ<=occThresh) = NaN;
    end
    if length(occThresh)==2
        rm(occ<=occThresh(1)) = NaN;
        occ(occ<=occThresh(1)) = NaN;
        rm(occ>=occThresh(2)) = NaN;
        occ(occ>=occThresh(2)) = NaN;
    end
    
%    Ro = nanmean(nanmean(rm)); %Overall mean firing rate
    sumOcc = nansum(nansum(occ)); % Total number of occupations
    pxO = occ./sumOcc; %Probaibility of occuping a given spatial bin
    infoTemp = nan(size(rm,1),size(rm,2)); % Initialize information matrix
    
    %% Info per Second
    for x  = 1 : size(rm,1);
        for y = 1 : size(rm,2);
            if ~isnan(rm(x,y)) && Ro ~= 0;
                    infoTemp(x,y) = (pxO(x,y).*rm(x,y)).*log2((rm(x,y)/Ro));
            else infoTemp(x,y) = 0;
            end
        end
    end

    infoPerSecond(j) = nansum(infoTemp(:));
    clear infoTemp
    
    %% Info per spike
    infoTemp = nan(size(rm,1),size(rm,2));
    for x  = 1 : size(rm,1);
        for y = 1 : size(rm,2);
            if ~isnan(rm(x,y)) && Ro ~= 0;
                    infoTemp(x,y) = (pxO(x,y).*(rm(x,y)./Ro)).*log2((rm(x,y)/Ro));
            else infoTemp(x,y) = 0;
            end
        end
    end
    
    infoPerSpike(j) = nansum(infoTemp(:));
    clear infoTemp
end
    
    
    
            