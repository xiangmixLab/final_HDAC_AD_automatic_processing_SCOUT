function [img]=colPatch2img(colPatch,cellmatrixSize,patch_size)
cellmatrix=cell(cellmatrixSize(1),cellmatrixSize(2));
for i=1:size(colPatch,2)
    oriPatch=reshape(colPatch(:,i),patch_size(1),patch_size(2));
    cellmatrix{i}=oriPatch;
end

img=cell2mat(cellmatrix);

