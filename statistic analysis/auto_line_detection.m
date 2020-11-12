% use this later than matlab 2019a 
% I need to find a replacement for the dbscan function here
function [lines_sequence,ori_sequence]=auto_line_detection(t)

t=C_to_peakS(t);
pts=[];
ctt=1;
for i=1:size(t,1)
    for j=1:size(t,2)
        if t(i,j)>0&&t(i,j)>0.1*max(t(:))
            pts(ctt,:)=[j,i];
            ctt=ctt+1;
        end
    end
end

% % dbscan to distinguish line points
idx=dbscan(pts,5,5);
% colormat=distinguishable_colors(100);
% imagesc(neuron_dat_seq_ori{2,14,2})
% hold on
% for i=1:size(pts,1)
% if idx(i)>0
% plot(pts(i,1),pts(i,2),'.','color',colormat(idx(i),:),'MarkerSize',10)
% end
% end

% merge clusters that are temporally close and close with neuro index
for i=1:max(unique(idx))
    pts_t=pts(idx==i,:);
    cen_temporal(i)=mean(pts_t(:,1));
end

idx_merge=idx;

for i=1:max(unique(idx))-1
    for j=i+1:max(unique(idx))
        if abs(cen_temporal(i)-cen_temporal(j))<=75 % sequences happen within 5 sec may be regarded as one
             
%             pts_t1=pts(idx==i,:);
%             pts_t2=pts(idx==j,:);
%             range_pts_t1=[min(pts_t1(:,2))-3:max(pts_t1(:,2))+3];
%             range_pts_t2=[min(pts_t2(:,2))-3:max(pts_t2(:,2))+3];
%             outt=intersect(sort(range_pts_t1),sort(range_pts_t2));
%             if ~isempty(outt)
                idx_merge(idx==j)=mean(idx_merge(idx==i));
%             end
        end
    end
end
                
% colormat=distinguishable_colors(100);
% imagesc(neuron_dat_seq_ori{1,7,1})
% hold on
% for i=1:size(pts,1)
% if idx(i)>0
% plot(pts(i,1),pts(i,2),'.','color',colormat(idx_merge(i),:),'MarkerSize',10)
% text(pts(i,1),pts(i,2),num2str(idx(i)))
% end
% end

% clear not good lines
idx_rm=idx_merge*0;
max_diff_neuronIdx=[];
for i=1:max(unique(idx_merge))
    pts_t=pts(idx_merge==i,:);
    % 1: participate neuron more than 5
    num_participate_neurons=length(unique(pts_t(:,2)));
    if num_participate_neurons<5
        idx_rm(idx_merge==i)=1;
    end
    % 2: too much disconnection
    diff_neuronIdx=diff(unique(pts_t(:,2)));
    if max(diff_neuronIdx)>20
        idx_rm(idx_merge==i)=1;
        max_diff_neuronIdx(i)=max(diff_neuronIdx);
    end
end

idx_clean=idx_merge;
idx_clean(idx_rm==1)=-1;

u_idx_clean=unique(idx_clean);
u_idx_clean=u_idx_clean(2:end);
%regress lines
lines_sequence={};
ori_sequence={};
for i=1:length(u_idx_clean)
    pts_t=pts(idx_clean==u_idx_clean(i),:);
%     p = polyfit(pts_t(:,1)/1000,pts_t(:,2),1);
%     line_t=polyval(p,pts_t(:,1));
    max_pts_t_y=max(pts_t(:,2));
    min_pts_t_y=min(pts_t(:,2));
    
%     pts_line=pts_t([find(pts_t(:,2)==min_pts_t_y);find(pts_t(:,2)==max_pts_t_y)],:);
    pts_line_pt1=mean(pts_t(find(pts_t(:,2)<=quantile(pts_t(:,2),0.2)),:),1);
    pts_line_pt2=mean(pts_t(find(pts_t(:,2)>=quantile(pts_t(:,2),0.8)),:),1);
    lines_sequence{i}=[pts_line_pt1;pts_line_pt2];
    ori_sequence{i}=pts_t;
end
    
% imagesc(neuron_dat_seq_ori{3,6,3})
% hold on
% for i=1:length(lines_sequence)
% line(lines_sequence{i}(:,1),lines_sequence{i}(:,2),'color','r','lineWidth',2);
% end    