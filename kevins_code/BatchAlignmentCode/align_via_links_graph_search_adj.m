function [Path_Storage,Distance]=align_via_links_graph_search_adj(neurons,links,overlap,height,width,dist_meas)
[G,final_letter]=build_linkage_graph(neurons,links,overlap,height,width,dist_meas);


G=rmnode(G,'Useless');
Adj_mat=adjacency(G);
for i=1:length(neurons)+length(links)
    if mod(i,2)==1
        batches(i)=size(neurons{(i+1)/2}.C,1);
    else
        batches(i)=size(links{i/2}.C,1);
    end
end
for i=1:length(neurons)+length(links)
    offsets(i)=sum(batches(1:i));
end

Path_Storage={};
Distance={};
parfor i=1:size(neurons{1}.C,1)
    Path_Storage{i}=pathbetweennodes(Adj_mat,i,i+offsets(end-1));
end

Path_Storage=vertcat(Path_Storage{:});

Path_Storage=vertcat(Path_Storage{:});
Path_Storage(:,2:end)=Path_Storage(:,2:end)-offsets(1:end-1);
    
    