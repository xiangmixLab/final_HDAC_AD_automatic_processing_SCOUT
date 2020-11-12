%% Dombeck & Tank 2010 2-p VR place cell identification paper method (they use dF/F, substitute to firing rate)

function [place_cells]=place_cell_identification(firingrate,nS,behavpos,behavtime,ROI,thresh)

place_cells=zeros(length(firingrate),1);
tic;
for i=1:length(firingrate)
    fr=firingrate{i};
%     fr=filter2DMatrices(fr,1);
    % 1: bin rate should be larger than 0.25*(max(fr)-percentile(fr,lower 0.25))
    fr_b=fr>(max(fr)-quantile(fr,0.25))*0.25;
    % 2: place field should larger than 2*2 bins (2-3cm*2-3cm)
    potentialFields={};
    
    statss=regionprops(fr_b,'PixelIdxList','BoundingBox');
    ctt=1;
    for j=1:length(statss)
        if statss(j).BoundingBox(3)>=2&&statss(j).BoundingBox(4)>=2
            potentialFields{ctt}=statss(j);
            ctt=ctt+1;
        end
    end
    % 3: at least one bin rate in field shoule larger than 10% of mean overall rate
    mean_rate=mean(fr(:));
    for j=1:length(potentialFields)
        fr_field_max=max(max((fr(potentialFields{j}.PixelIdxList))));
        if fr_field_max<=mean_rate
            potentialFields(j)=[];
        end
    end
    % 4: mean field rate should be larger than 3*out_field_rate
    for j=1:length(potentialFields)
        fr_field_mean=mean(mean(fr(potentialFields{j}.PixelIdxList)));
        if fr_field_max<=mean(mean(fr(setdiff([1:size(fr,1)*size(fr,2)],potentialFields{j}.PixelIdxList))))*3
            potentialFields(j)=[];
        end
    end
    % 5: significant calcium activity occupy at least 30% of time? may not
    % be necessary
    
    % 6: survive the shuffling
    for j=1:100
        nS_shuffle=trunk_shuffle_data(nS,9);
        fr_shuffle{j}=calculatingCellSpatialForSingleData_Suoqin_simplified(nS_shuffle,behavpos,behavtime,ROI,15,thresh,[0 inf],10);
    end
    for j=1:length(potentialFields)
        fr_field_mean_shuffle=[];
        for k=1:100
            fr_field_mean_shuffle(k)=mean(mean(fr_shuffle{k}{j}(potentialFields{j}.PixelIdxList)));
        end
        if mean(mean(fr(potentialFields{j}.PixelIdxList)))>quantile(fr_field_mean_shuffle,0.95)
            place_cells(i)=1;
        end
    end
    toc;
end