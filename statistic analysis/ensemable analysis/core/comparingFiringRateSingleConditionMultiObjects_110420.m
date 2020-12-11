function [sumFiringRate_conv,sumFiringRateObject] = comparingFiringRateSingleConditionMultiObjects_110420(firingRate,countTime,objpos,binsize)

    posObjects = ceil(objpos./binsize);

    [sumFiringRate,sumFiringRate_conv,cellnum] = calculatingSumFiringRate(firingRate,countTime);

    sumFiringRate=sumFiringRate/cellnum;
    sumFiringRate_conv=sumFiringRate_conv/cellnum;

    sumFiringRateObject = zeros(1,size(posObjects,1));

    if sum(posObjects(:))>0
        for i = 1:size(posObjects,1)
    %         sumFiringRateObject(1,i) =sumFiringRateObject(1,i)+sumFiringRate_conv(size(sumFiringRate_conv,1)-posObjects(i,2)+1+u,posObjects(i,1)+v);
            sumFiringRateObject(1,i) =0;
            sum_num=0;
            for u=-1:1 % the obj is large, a larger area may be required (5x5 around obj)
                for v=-1:1
                    if size(sumFiringRate,1)-posObjects(i,2)+u>0&&size(sumFiringRate,1)-posObjects(i,2)+u<size(sumFiringRate,1)&&posObjects(i,1)+v>0&&posObjects(i,1)+v<size(sumFiringRate,2)
                        if ~isnan(sumFiringRate(size(sumFiringRate,1)-posObjects(i,2)+u,posObjects(i,1)+v))
                            sumFiringRateObject(1,i) =sumFiringRateObject(1,i)+sumFiringRate(size(sumFiringRate,1)-posObjects(i,2)+u,posObjects(i,1)+v);
                            sum_num=sum_num+1;
                        end
                    end
                end
            end
            sumFiringRateObject(1,i)=sumFiringRateObject(1,i)/sum_num;
        end
    end
%     sumFiringRate_conv(size(sumFiringRate_conv,1)-posObjects(1,2)+1,posObjects(1,1))=-1;
%     sumFiringRate_conv(size(sumFiringRate_conv,1)-posObjects(2,2)+1,posObjects(2,1))=-1;
    sumFiringRateObject(isnan(sumFiringRateObject)) = 0;

end


function [sumFiringRate,sumFiringRate_conv,cellnum] = calculatingSumFiringRate(firingRate,countTime)

    
    radius=3;
%     f=ones(2*radius-1); % this is sum
    f=ones(2*radius-1)/sum(sum(ones(2*radius-1))); % this is average
    
    sumFiringRate = zeros(size(countTime));
    sumFiringRate_conv=zeros(size(countTime));
    
    cellnum=0;

    for i = 1:length(firingRate)
            if isempty(firingRate{i})
                continue;
            end
            firingRate{i}(isnan(firingRate{i})) = nan;
            firingRate{i}(firingRate{i}==inf) = nan;
            firingRate{i}(countTime==0) = nan;
            sumFiringRate_conv = sumFiringRate_conv + nanconv(firingRate{i},f);
            sumFiringRate = sumFiringRate + firingRate{i};
            cellnum=cellnum+1;
    end
end
    % sumFiringRate(countTime == 0) = NaN;



