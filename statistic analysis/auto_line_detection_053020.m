% use this later than matlab 2019a 
% I need to find a replacement for the dbscan function here
function [lines_sequence,ori_sequence]=auto_line_detection_053020(t)

% smoothing and binarzation
t=zscore(t,[],2);
t1=imgaussfilt(t,5);
t2=t1;
t2=localcontrast(uint8(t2*255/max(t2(:))));
% t2=imbinarize(t2);
t2(t2<max(t2(:))*0.13)=0;
t2=t2>0;
% t2=imbinarize(t2*1/max(t2(:)),'adaptive','Sensitivity',0.9);
t2=bwareaopen(t2,1000);
stats=regionprops(t2,'pixelList');

pts={};
for i=1:length(stats)
    pts{i}=stats(i).PixelList;
end

% colormat=distinguishable_colors(100);
% imagesc(neuron_dat_seq_ori{2,14,2})
% hold on
% for i=1:size(pts,1)
% if idx(i)>0
% plot(pts(i,1),pts(i,2),'.','color',colormat(idx(i),:),'MarkerSize',10)
% end
% end
                
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
idx_rm=zeros(length(pts),1);
max_diff_neuronIdx=[];
for i=1:length(pts)
    pts_t=pts{i};
    % 1: participate neuron more than 5
    num_participate_neurons=length(unique(pts_t(:,2)));
    if num_participate_neurons<6
        idx_rm(i)=1;
    end
    % 2: too much disconnection
    diff_neuronIdx=diff(unique(pts_t(:,2)));
    if max(diff_neuronIdx)>20
        idx_rm(i)=1;
        max_diff_neuronIdx(i)=max(diff_neuronIdx);
    end
end

% merge close seq
cen_temporal=[];
for i=1:length(pts)
    pts_t=pts{i};
    cen_temporal(i)=mean(pts_t(:,1));
end

for i=1:length(cen_temporal)-1
    for j=i+1:length(cen_temporal)
        if abs(cen_temporal(i)-cen_temporal(j))<=75 % sequences happen within 5 sec may be regarded as one
            pts_i=pts{i};
            pts_j=pts{j};
            uni_y_i=unique(pts_i(:,2));
            uni_y_j=unique(pts_j(:,2));
            leng_uni_y_i=length(uni_y_i);
            leng_uni_y_j=length(uni_y_j);
            if ~isempty(intersect(uni_y_i,uni_y_j))
                if leng_uni_y_i>leng_uni_y_j
                    idx_rm(j)=1;
                else
                    idx_rm(i)=1;
                end
            else
                if leng_uni_y_i>leng_uni_y_j
                    if leng_uni_y_i>2*leng_uni_y_j&&cen_temporal(i)-cen_temporal(j)<0 %i before j and i is much longer than j
                        
                    else
                        pts{i}=[pts{i};pts{j}];
                        idx_rm(j)=1;
                    end
                else
                    if leng_uni_y_j>2*leng_uni_y_i&&cen_temporal(j)-cen_temporal(i)<0 %j before i and j is much longer than i

                    else
                        pts{j}=[pts{j};pts{i}];
                        idx_rm(i)=1;
                    end
                end                
            end
        end
    end
end

% delete rm seq
pts(idx_rm==1)=[];

%regress lines
lines_sequence={};
ori_sequence={};
for i=1:length(pts)
    pts_t=pts{i};
    pts_line_pt1=mean(pts_t(find(pts_t(:,2)<=quantile(pts_t(:,2),0.1)),:),1);
    pts_line_pt2=mean(pts_t(find(pts_t(:,2)>=quantile(pts_t(:,2),0.9)),:),1);
    pts_line_pt1(:,2)=min(pts_t(:,2));
    pts_line_pt2(:,2)=max(pts_t(:,2));
    lines_sequence{i}=[pts_line_pt1;pts_line_pt2];
    ori_sequence{i}=pts_t;
end
    
% imagesc(neuron_dat_seq_ori{3,5,2})
% hold on
% for i=1:length(lines_sequence)
% line(lines_sequence{i}(:,1),lines_sequence{i}(:,2),'color','r','lineWidth',2);
% end    