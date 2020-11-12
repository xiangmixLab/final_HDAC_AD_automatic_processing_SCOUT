function [max_inds] = FindMaxIndsRateMap(rate_mat)

% turn nans in rate_mat to zeros
rate_mat_ori=rate_mat;
rate_mat(isnan(rate_mat))=0;

% pad rate mat with zero edges to catch border maxs 
        rm_size= size(rate_mat);
        rm_size= rm_size+2;
        rate_mat_new= zeros(rm_size);
        rate_mat_new(2:end-1, 2:end-1)= rate_mat(1:end, 1:end);
        rate_mat=rate_mat_new;
        
        max_inds_len = 0;
        
        [size_x, size_y]= size(rate_mat);
        
        for fig_i = 3:size_x-2
            for j = 3:size_y-2
                if rate_mat(fig_i,j) > rate_mat(fig_i+2,j) && ...
                        rate_mat(fig_i,j) > rate_mat(fig_i-2,j) && ...
                        rate_mat(fig_i,j) > rate_mat(fig_i,j+2) && ...
                        rate_mat(fig_i,j) > rate_mat(fig_i,j-2)
                    hold on
                    max_inds_len = max_inds_len+1;
                    max_inds(max_inds_len,1) = fig_i-1;     %list of maximum pt indices
                    max_inds(max_inds_len,2) = j-1;
%                     max_inds(max_inds_len,1) = fig_i;     %list of maximum pt indices
%                     max_inds(max_inds_len,2) = j;
%                     max_inds(max_inds_len,1) = j-1;     %list of maximum pt indices
%                     max_inds(max_inds_len,2) = fig_i-1;
                    
                    %some points may out of behav range for 1 points, fix
                    if isnan(rate_mat_ori(max_inds(max_inds_len,1),max_inds(max_inds_len,2)))
                        max_inds(max_inds_len,1)=max_inds(max_inds_len,1)+(max_inds(max_inds_len,1)-size_x/2)/abs(max_inds(max_inds_len,1)-size_x/2);
                        max_inds(max_inds_len,2)=max_inds(max_inds_len,2)+(max_inds(max_inds_len,2)-size_y/2)/abs(max_inds(max_inds_len,2)-size_y/2);
                    end

                end
            end
        end
%         close;