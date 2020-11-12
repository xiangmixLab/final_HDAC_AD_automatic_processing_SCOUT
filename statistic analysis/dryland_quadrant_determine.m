%for left up, right up, right down, left down type
function quad_idx=dryland_quadrant_determine(behavname)

for i=1:length(behavname)
    load(behavname{i});
    pos=behav.position;
    pos(isnan(pos(:,1)),:)=[];
    pos(isnan(pos(:,2)),:)=[];
    
    start_pos(i,:)=pos(2,:);
end

%cross design
center=mean(start_pos,1);

quad_idx=[];
for i=1:size(start_pos,1)
    t=start_pos(i,:)-center;
    if t(1)>0&&t(2)>0
        quad_idx(i,1)=1;
    end
    if t(1)<0&&t(2)>0
        quad_idx(i,1)=2;
    end
    if t(1)<0&&t(2)<0
        quad_idx(i,1)=3;
    end
    if t(1)>0&&t(2)<0
        quad_idx(i,1)=4;
    end
end