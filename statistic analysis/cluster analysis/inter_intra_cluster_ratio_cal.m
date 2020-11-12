function [ratio,within_all,cross_all]=inter_intra_cluster_ratio_cal(unique_idx,datai,idx)
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
    ratio=mean(within_all)/mean(cross_all);
end