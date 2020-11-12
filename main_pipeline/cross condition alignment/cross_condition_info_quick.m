function [num2read,foldernamestruct,data_shape]=cross_condition_info_quick(destination);

foldername=unique(destination);

for tk=1:length(foldername)
    cd(foldername{tk});
    num2read_t=[];
    f= dir(pwd); 
    total_files={f.name};
    vid_files={};
    for i=1:length(total_files)
        [filepath,name,ext]= fileparts(total_files{i});
        if (isequal(ext,'.tif')&&~isempty(str2num(name)))||(isequal(ext,'.mat')&&~isempty(str2num(name)))
            vid_files{end+1}=horzcat(name,ext);
        end
    end
    
    for j=1:length(vid_files)
        k=matfile(vid_files{j});
        size_Mr=size(k.Mr);
        num2read_t(j+1)=size_Mr(3);
    end
    
    num2read_t(1)=sum(num2read_t(2:end));
    num2read{tk}=num2read_t;
    foldernamestruct{tk}=[pwd,'\','final_concatenate_stack.mat'];
    data_shape{tk}=size_Mr(1:2);
end
        
