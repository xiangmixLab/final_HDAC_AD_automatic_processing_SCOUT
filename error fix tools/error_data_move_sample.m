%% error data move

for i=1:length(orilocation)
    if ~isequal(orilocation{i},orilocation_error{i})
        error_ind=0;
        for j=1:length(orilocation)
            if isequal(orilocation{j},orilocation_error{i})
                error_ind=j;
            end
        end
        wrong_vid_name=[destination{i},'\',vname{i},'.mat'];
        true_vid_name=[destination{error_ind},'\',vname{error_ind},'_t.mat'];
        wrong_temp_name=[destination{i},'\','MAX_',vname{i},'.tif'];
        true_temp_name=[destination{error_ind},'\','MAX_',vname{error_ind},'_t.tif'];  
        wrong_mr_vid_name=[destination{i},'\',num2str(1204000+i),'.mat'];
        true_mr_vid_name=[destination{error_ind},'\',num2str(1204000+error_ind),'_t.mat'];
        wrong_mr_vid_m_name=[destination{i},'\',num2str(1204000+i),'metric.mat'];
        true_mr_vid_m_name=[destination{error_ind},'\',num2str(1204000+error_ind),'metric_t.mat'];    
        wrong_mr_vid_avi_name=[destination{i},'\',num2str(1204000+i),'.avi'];
        true_mr_vid_avi_name=[destination{error_ind},'\',num2str(1204000+error_ind),'_t.avi'];
        copyfile(wrong_vid_name,true_vid_name);
        copyfile(wrong_temp_name,true_temp_name);
        copyfile(wrong_mr_vid_name,true_mr_vid_name);
        copyfile(wrong_mr_vid_m_name,true_mr_vid_m_name);
        copyfile(wrong_mr_vid_avi_name,true_mr_vid_avi_name);
        disp(['finish ',num2str(i)])
    end
end