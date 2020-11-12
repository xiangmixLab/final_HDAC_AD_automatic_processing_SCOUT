function [velo,ddistance,dtime,cen,diff_from_cen]=behav_velo_cal(behav,cen,led)

if isequal(led,'r')
    for i=2:size(behav.position,1)
        ddistance(i-1,1)=norm(behav.position(i-1,:)-behav.position(i,:));
    end    
    dtime=diff(behav.time);    
    velo=ddistance./dtime;
    if isempty(cen)
        cen=[mean(behav.position(:,1)),mean(behav.position(:,2))];
        for i=1:size(behav.position,1)
            diff_from_cen(i)=norm(behav.position(i,:)-cen);
        end
    else
        for i=1:size(behav.position,1)
            diff_from_cen(i)=norm(behav.position(i,:)-cen);
        end
    end
end

if isequal(led,'b')
    for i=2:size(behav.positionblue,1)
        ddistance(i)=norm(behav.positionblue(i-1,:)-behav.positionblue(i,:));
    end    
    dtime=diff(behav.time);    
    velo=ddistance./dtime;
    h1=histogram(behav.position(:,1));
    cen=[median(behav.position(:,1)),median(behav.position(:,2))];
    for i=1:size(behav.position,1)
        diff_from_cen(i)=norm(behav.position(i,:)-cen);
    end
end

