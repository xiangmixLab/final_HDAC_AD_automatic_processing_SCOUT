function [foldernamestruct,num2read,data_shape]=HPC_generated_info(foldername)

for i=1:length(foldername)
    load([foldername{i},'\','final_concatenate_stack_stats.mat']);
    foldernamestruct{i}=[[foldername{i},'\','final_concatenate_stack.mat']];
    num2read_all{i}=num2read;
    data_shape_all{i}=data_shape;
end

num2read=num2read_all;
data_shape=data_shape_all;