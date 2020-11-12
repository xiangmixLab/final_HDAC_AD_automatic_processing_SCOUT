for i=1:length(folderName)
    load([folderName{i},'\','neuronIndividuals_new.mat']);
    for j=1:length(neuronIndividuals_new)            
        for z=2:10
            group_record{j,i}{z}=cluster_determine_by_suoqin_NMF_firstPeakCoph_stability(neuronIndividuals_new{j},100,10,z);
        end
    end
end


A_color={};
A_color_region={};
region_siz={};
region_size_shuf={};
region_size_shuf_95={};
for i=1:length(folderName)
    load([folderName{i},'\','neuronIndividuals_new.mat']);
    for j=1:length(neuronIndividuals_new)  
        for z=2:10
        [A_color{j,i}{z},A_color_region{j,i}{z},region_siz{j,i}{z},region_size_shuf{j,i}{z},region_size_shuf_95{j,i}{z},A_color_region_shuffle{j,i}{z}]=DBSCAN_region_quantify_func_single_group(group_record{j,i}{z-1},1,neuronIndividuals_new);
        end
    end
end