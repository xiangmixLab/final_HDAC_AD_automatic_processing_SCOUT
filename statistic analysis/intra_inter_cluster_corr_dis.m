function [intra_all,inter_all,avg_intra_all,avg_inter_all,intra_shuffle_all,avg_intra_shuffle_all]=intra_inter_cluster_corr_dis(neuronIndividuals,group,session,sign)

shuffle=1000;

intra={};
inter={};
intra_shuffle={};

switch sign
    case 'corr'
        dataC1=neuronIndividuals{session}.C;
        corr_all=squareform(1-pdist(dataC1,'correlation'));
    case 'dis'
        dataC1=neuronIndividuals{session}.centroid;
        corr_all=squareform(pdist(dataC1));      
    otherwise
        dataC1=neuronIndividuals{session}.C;
        corr_all=squareform(1-pdist(dataC1,'correlation'));
end

for i=1:length(unique(group))
    t=triu(corr_all(group==i,group==i),1);
    mask = tril(true(size(corr_all(group==i,group==i))),1);
    intra{i}=t(~mask);
    t=triu(corr_all(group==i,group~=i),1);
    mask = tril(true(size(corr_all(group==i,group~=i))),1);
    inter{i}=t(~mask);
end

for j=1:shuffle
    group_rand = group(randperm(length(group)));
    for i=1:length(unique(group))
        t=triu(corr_all(group_rand==i,group_rand==i),1); 
        mask = tril(true(size(corr_all(group_rand==i,group_rand==i))),1);
        intra_shuffle{i,j}=t(~mask);
    end
end
    
intra_all=[];
ctt=1;
for i=1:length(unique(group))
    intra_all(ctt:ctt+length(intra{i})-1)=intra{i};
    ctt=ctt+length(intra{i});
end

inter_all=[];
ctt=1;
for i=1:length(unique(group))
    inter_all(ctt:ctt+length(inter{i})-1)=inter{i};
    ctt=ctt+length(inter{i});
end

intra_shuffle_all=[];
ctt=1;
for j=1:shuffle
    for i=1:length(unique(group))
        intra_shuffle_all(ctt:ctt+length(intra_shuffle{i,j})-1)=intra_shuffle{i,j};
        ctt=ctt+length(intra_shuffle{i,j});
    end
end

intra_all(isnan(intra_all))=[];
inter_all(isnan(inter_all))=[];
intra_shuffle_all(isnan(intra_shuffle_all))=[];

intra_all=intra_all';
inter_all=inter_all';
intra_shuffle_all=intra_shuffle_all';

avg_intra_all=nanmean(intra_all);
avg_inter_all=nanmean(inter_all);
avg_intra_shuffle_all=nanmean(intra_shuffle_all);
