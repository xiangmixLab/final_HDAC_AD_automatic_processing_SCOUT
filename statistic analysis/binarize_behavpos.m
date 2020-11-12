function [bin_behav,bin_idx,field_size]=binarize_behavpos(behavpos,binsize,maxbehavROI)
pos1 = 0:binsize:ceil(maxbehavROI(3));
pos2 = 0:binsize:ceil(maxbehavROI(4));
bin_behav=zeros(size(behavpos,1),2);
bin_idx=zeros(size(behavpos,1),2);
for i = 1:size(behavpos,1)
    if ~isnan(behavpos(i,1))
        [~,idxx] = find(pos1 <= behavpos(i,1), 1, 'last');
        [~,idyy] = find(pos2 <= behavpos(i,2), 1, 'last');
        bin_behav(i,:) = [idxx,idyy];
        bin_idx(i,:)=sub2ind([length(pos2) length(pos1)],idyy,idxx);
    else
        bin_behav(i,:)=[nan nan];
    end
end

field_size=[length(pos2) length(pos1)];