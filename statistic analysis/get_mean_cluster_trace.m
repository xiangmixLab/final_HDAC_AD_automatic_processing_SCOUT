function meanTrace=get_mean_cluster_trace(dataC,group)

meanTrace=[];
    for j=1:length(unique(group))
        meanTrace(j,:)=mean(dataC(group == j,:),1);
    end

