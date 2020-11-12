%hdac_ad_auto folder name set
function [conditionfolder,conditionfolder1,conditionfolder2,conditionfolder3,conditionfolder4,conditionfoldercombine,conditionfoldercombinecluster,one_condition_cluster_index]= HDAC_AD_foldername_set(nameparts,num_of_conditions,numparts)

for i01=1:num_of_conditions
    conditionfolderall{1,i01}=[nameparts{1,i01},'_results'];
    conditionfolder1all{1,i01}=[nameparts{1,i01},'_info_score_placement_cell'];
    conditionfolder2all{1,i01}=[nameparts{1,i01},'_placement_cell_cluster'];
    conditionfolder3all{1,i01}=[nameparts{1,i01},'_placement_cell_cluster_baseline','based'];
    conditionfolder4all{1,i01}=[nameparts{1,i01},'_placement_cell_cluster_parts'];
end

conditionfolder=cell(1,length(numparts(numparts~=0)));
conditionfolder1=cell(1,length(numparts(numparts~=0)));
conditionfolder2=cell(1,length(numparts(numparts~=0)));
conditionfolder3=cell(1,length(numparts(numparts~=0)));
conditionfolder4=cell(1,length(numparts(numparts~=0)));

nameparts1=cell(1,length(numparts(numparts~=0)));

count=1;
one_condition_cluster_index=0;% used for clustering only on training section
for i=1:num_of_conditions %actually length(numparts) is always equal to 3
%     if numparts(i)~=0
        conditionfolder{1,count}=conditionfolderall{1,i};
        conditionfolder1{1,count}=conditionfolder1all{1,i};
        conditionfolder2{1,count}=conditionfolder2all{1,i};
        conditionfolder3{1,count}=conditionfolder3all{1,i};
        conditionfolder4{1,count}=conditionfolder4all{1,i};
        nameparts1{1,count}=nameparts{1,i};
        if isequal(nameparts{1,i},'baseline')
            one_condition_cluster_index=count;
        end
        count=count+1;
%     end
end

conditionfoldercombine='combined_info_score_placement_cell';
conditionfoldercombinecluster='combined_cell_cluster';

save('foldername_in_use.mat','conditionfolder','conditionfolder1','conditionfolder2','conditionfolder3','conditionfolder4','conditionfoldercombine','conditionfoldercombinecluster','one_condition_cluster_index');