function cellmat1=fill_nan_to_cellmat(cellmat)

max_length=[];
for i=1:size(cellmat,1)
    for j=1:size(cellmat,2)
        max_length=[max_length,length(cellmat{i,j})];
    end
end

max_length=max(max_length);
cellmat1={};
for i=1:size(cellmat,1)
    fat_all=[];
    for j=1:size(cellmat,2)
        fat=cellmat{i,j};
        fat(length(fat)+1:max_length)=nan;
        fat_all(:,j)=fat;
    end
    cellmat1{i,1}=fat_all;
end
