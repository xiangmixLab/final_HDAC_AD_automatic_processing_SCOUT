function [dataC2,positionC2]=clustered_timeSeries(ts,group2)

dataC2 = [];
for j = 1:length(unique(group2))
    dataC2 = [dataC2;ts(group2 == j,:)];
end

positionC2 = 0;
for i =1:length(unique(group2))
    positionC2(i+1) = positionC2(i)+sum(group2 == i);
end
