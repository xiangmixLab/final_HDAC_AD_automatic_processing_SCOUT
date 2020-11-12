function [ outputMaps ] = filter2DMatrices( inputMaps, downsampledFlag )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% 090518 I guess this is the gaussian smoothing mentioned by Dr, Nitz.
% however in that case the center of gaussian should be 0.5-0.8 or so
%2D ratemap smoothing function **************************************

if downsampledFlag ==1;
%     halfNarrow = 5;
%     narrowStdev = 2;
%     halfNarrow = 5;
%     narrowStdev = 2;%control narrow level. larger, narrower
    halfNarrow = 5;% -5:5 is too large for 19*15 or 20:12 bins. 1/2 of the boxs are considered as possible regions that mice can go...- -
    narrowStdev = 2;

else
    halfNarrow = 7;
    narrowStdev = 3.5;
end

% [xGridVals, yGridVals]=meshgrid(-halfNarrow:1:halfNarrow);
% narrowGaussian = exp(-0.5 .* (xGridVals.^2+yGridVals.^2)/narrowStdev^2)/(narrowStdev*(sqrt(2*pi)));
narrowGaussian=fspecial('gaussian',halfNarrow*2+1,narrowStdev);
% narrowGaussianNormed=narrowGaussian./sum(sum(narrowGaussian));
% narrowGaussianNormed=narrowGaussian./max(narrowGaussian(:)); % 090518, normalization?
narrowGaussianNormed=narrowGaussian;

for i = 1:size(inputMaps,3)
%     outputMaps(:,:,i) = conv2nan(inputMaps(:,:,i,1),narrowGaussianNormed);
    outputMaps(:,:,i) = nanconv(inputMaps(:,:,i,1),narrowGaussianNormed, 'nanout');
%       outputMaps(:,:,i) = conv2(inputMaps(:,:,i,1),narrowGaussianNormed,'same');
end

end


