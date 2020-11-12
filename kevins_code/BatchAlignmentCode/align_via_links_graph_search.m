function [Path_Storage,Distance]=align_via_links_graph_search(neurons,links,overlap,height,width,dist_meas)
[G,final_letter]=build_linkage_graph(neurons,links,overlap,height,width,dist_meas);
Path_Storage={};
Distance={};
for i=1:size(neurons{1}.C)
    paths=[];
    distances=[];
   
    [path,distance]=shortestpath(G,horzcat('A',num2str(i)),horzcat(final_letter,num2str(i)));
    if ~isempty(path)
        paths=vertcat(paths,cellfun(@(x)extract_numeric(x),path));
        distances=[distances,distance];
       
    
    end
    Path_Storage{end+1}=paths;
    Distance{end+1}=distances;
    
end
Path_Storage=vertcat(Path_Storage{:});
Distance=horzcat(Distance{:})/(length(neurons)+length(links));
end
            