function [intra_corr_circle_all,intra_corr_rand_circle_all,inter_corr_circle_all]=correlation_histogram(foldername,cluster_file_name,jidx)


intra_corr_circle={};
intra_corr_rand_circle={};
inter_corr_circle={};
shuffle=100;
tic;
for k=1:length(foldername)
    cd(foldername{k});
    load('neuronIndividuals_new.mat');

    load(cluster_file_name)
    group=group{jidx};              
    dataC1 = neuronIndividuals_new{jidx}.C;
    corr_all=squareform(1-pdist(dataC1,'correlation'));
    for i=1:length(unique(group))
        t=triu(corr_all(group==i,group==i),1);
        mask = tril(true(size(corr_all(group==i,group==i))),1);
        intra_corr_circle{k,i}=t(~mask);
        t=triu(corr_all(group==i,group~=i),1);
        mask = tril(true(size(corr_all(group==i,group~=i))),1);
        inter_corr_circle{k,i}=t(~mask);
    end
    for j=1:shuffle
        group_rand = group(randperm(length(group)));
        for i=1:length(unique(group))
            t=triu(corr_all(group_rand==i,group_rand==i),1); 
            mask = tril(true(size(corr_all(group_rand==i,group_rand==i))),1);
            intra_corr_rand_circle{k,i,j}=t(~mask);
        end
    end
end



intra_corr_circle_all=[];
ctt=1;
for k=1:length(foldername)
    t=[];
    for i=1:length(unique(group))
        intra_corr_circle_all(ctt:ctt+length(intra_corr_circle{k,i})-1)=intra_corr_circle{k,i};
        ctt=ctt+length(intra_corr_circle{k,i});
    end
end

inter_corr_circle_all=[];
ctt=1;
for k=1:length(foldername)
    t=[];
    for i=1:length(unique(group))
        inter_corr_circle_all(ctt:ctt+length(inter_corr_circle{k,i})-1)=inter_corr_circle{k,i};
        ctt=ctt+length(inter_corr_circle{k,i});
    end
end

intra_corr_rand_circle_all=[];
ctt=1;
for k=1:length(foldername)
    for i=1:length(unique(group))
        for j=1:shuffle
            intra_corr_rand_circle_all(ctt:ctt+length(intra_corr_rand_circle{k,i,j})-1)=intra_corr_rand_circle{k,i,j}; % we do an average to make the total sample number comparable to the inter-cluster-corr
            ctt=ctt+length(intra_corr_rand_circle{k,i,j});       
        end        
    end
end

intra_corr_circle_all(isnan(intra_corr_circle_all))=[];
intra_corr_rand_circle_all(isnan(intra_corr_rand_circle_all))=[];
inter_corr_circle_all(isnan(inter_corr_circle_all))=[];

figure;
set(gcf,'renderer','painters');
hold on
subplot(211)
yyaxis left
h1=histogram(intra_corr_circle_all,100,'FaceColor','r','FaceAlpha',0.4);
yyaxis right
h3=histogram(intra_corr_rand_circle_all,100,'FaceColor','b','FaceAlpha',0.4);
subplot(212)
yyaxis left
h1=histogram(intra_corr_circle_all,100,'FaceColor','r','FaceAlpha',0.4);
yyaxis right
h2=histogram(inter_corr_circle_all,100,'FaceColor','g','FaceAlpha',0.4);

% legend({'intra cluster correlation','randomized intra cluster correlation','inter cluster correlation'});

intra_corr_circle_all=intra_corr_circle_all';
intra_corr_rand_circle_all=intra_corr_rand_circle_all';
inter_corr_circle_all=inter_corr_circle_all';
