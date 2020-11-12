function t_mod=average_duplicate_place_cells(t1,place_cells_all)

    [~, uniqueIdx] = unique(place_cells_all);
    duplicateIdx=setdiff(1:length(place_cells_all), uniqueIdx);
    duplicate_cellIdx=unique(place_cells_all(duplicateIdx));
    for it=1:length(duplicate_cellIdx)
        cell_pos=find(place_cells_all==duplicate_cellIdx(it));
        t1(cell_pos(1))=mean(t1(cell_pos));
        t1(cell_pos(2:end))=nan;
    end
    
    t_mod=t1;
    t_mod(isnan(t_mod))=[];