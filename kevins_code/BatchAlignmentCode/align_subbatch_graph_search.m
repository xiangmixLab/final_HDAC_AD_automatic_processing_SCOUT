function [Path_Storage,Distance]=align_subbatch_graph_search(neurons,score_thresh,overlap,data_shape,corr_type,dist_meas)
Path_Storage={};
Distance={};

for l=1:ceil(length(neurons)/2)
    
    [G,final_letter]=build_batch_graph(neurons(l:l+floor(length(neurons)/2)),score_thresh,overlap,data_shape(1),data_shape(2),corr_type,dist_meas);
    paths=[];
    distances=[];
    for i=1:size(neurons{l}.C)
    
    for j=1:size(neurons{l+floor(length(neurons)/2)}.C)
        [path,distance]=shortestpath(G,horzcat('A',num2str(i)),horzcat(final_letter,num2str(j)));
        if ~isempty(path)
            paths=vertcat(paths,cellfun(@(x)extract_numeric(x),path));
            distances=[distances,distance];
        end
    end
    
    end
    Path_Storage{l}=zeros(size(paths,1),length(neurons));
    Path_Storage{l}(:,l:l+floor(length(neurons)/2))=paths;

    Distance{l}=distances;
end
end
            