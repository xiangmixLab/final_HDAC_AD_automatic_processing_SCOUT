% within-across cluster ratio calculation
function [within_across_ratio,maxIndex]=within_across_cluster_ratio_cal(datai,Klist)

within_across_ratio=zeros(1,length(Klist));% should just be CH score

for cst=1:length(Klist)
    idx = kmeans(datai,Klist(cst));
    unique_idx=unique(idx);
    [within_all,cross_all]=within_across_cluster_ratio_cal_sub(unique_idx,datai,idx);
    within_across_ratio(1,cst)=mean(within_all)/mean(cross_all);
end

maxIndex=find(within_across_ratio==max(within_across_ratio));
end

function [within_all,cross_all]=within_across_cluster_ratio_cal_sub(unique_idx,datai,idx)
    within_all=[];
    cross_all=[];
    for cst2=1:length(unique_idx)
            corr_within=corrcoef(datai(idx==unique_idx(cst2),:)');
            corr_within_vec=corr_within(logical(triu(ones(size(corr_within)),1)));
            corr_across=corrcoef(datai');
            corr_across(idx==unique_idx(cst2),idx==unique_idx(cst2))=-1000;
            corr_across_vec=corr_across(logical(triu(ones(size(corr_across)),1)));
            corr_across_vec(corr_across_vec==-1000)=[];
            corr_within_vec(isnan(corr_within_vec))=[];
            corr_across_vec(isnan(corr_across_vec))=[];
            within_all=[within_all;mean(abs(corr_within_vec))];% we have to deal with the different number of correlation items under different number of clusters... or larger cluster number will bound to have larger ratio
            cross_all=[cross_all;mean(abs(corr_across_vec))];        
    end
    within_all(isnan(within_all))=[];
    cross_all(isnan(cross_all))=[];
end