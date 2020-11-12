function latency=dryland_latency_cal(behav)

% start till the first time close to obj
object=behav.object;
object(:,2)=behav.ROI(4)-object(:,2);

behavpos=behav.position;

dis2obj=sum((behavpos-object).^2,2).^0.5;

objrange=12.5+15; % 1.5cm range, r=1.25cm

first_encounter=min(find(dis2obj<objrange));

latency=first_encounter/30; % 30Hz