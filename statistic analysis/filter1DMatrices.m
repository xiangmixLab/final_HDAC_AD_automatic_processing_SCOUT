function [ outputMaps ] = filter1DMatrices( inputMaps, downsampledFlag,dir )
%1D ratemap smoothing function **************************************

    if downsampledFlag ==1
        halfNarrow = 5;% -5:5 is too large for 19*15 or 20:12 bins. 1/2 of the boxs are considered as possible regions that mice can go...- -
        narrowStdev = 4;

    else
        halfNarrow = 7;
        narrowStdev = 3.5;
    end
    if dir==1
        narrowGaussian=fspecial('gaussian',[1 halfNarrow*2+1],narrowStdev);
    end
    if dir==2
        narrowGaussian=fspecial('gaussian',[halfNarrow*2+1,1],narrowStdev);
    end
    narrowGaussianNormed=narrowGaussian;

    for i = 1:size(inputMaps,dir)
        if dir==1
            outputMaps(i,:) = nanconv(inputMaps(i,:),narrowGaussianNormed, 'nanout');
        end
        if dir==2
            outputMaps(:,i) = nanconv(inputMaps(:,i),narrowGaussianNormed, 'nanout');
        end
    end
end


