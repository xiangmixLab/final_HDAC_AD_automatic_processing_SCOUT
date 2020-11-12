function outputt=time_lag_rotation(inputt,time_lag)

outputt=inputt;
for j = 1:size(inputt,1)
    tt=inputt(j,:);
    tail=tt(length(tt)-time_lag(j):end);
    tt1=[tail,tt(1:length(tt)-time_lag(j)-1)];
    outputt(j,:)=tt1;
end