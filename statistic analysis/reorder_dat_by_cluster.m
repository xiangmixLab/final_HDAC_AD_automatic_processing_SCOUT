function [dataC2,positionC2]=reorder_dat_by_cluster(dat,group2)

colorClusters2=distinguishable_colors(10);
dataC2 = [];
for j = 1:length(unique(group2))
    dataC2 = [dataC2;dat(group2 == j,:)];
end

positionC2 = 0;
for i =1:length(unique(group2))
    positionC2(i+1) = positionC2(i)+sum(group2 == i);
end
optimalK2=length(unique(group2));

for j = 1:length(unique(group2))
    subplot(length(unique(group2)),1,j);
%     figure;
    rangee=find(group2 == j);
%     rangee(rand([1 length(rangee)])>0.3)=0;
%     yyaxis left
    ctt=1;
    for k=1:length(rangee)
        plot(dat(rangee(k),1:end)'+(ctt-1)*10,'-','color',colorClusters2(j,:));hold on;
        ctt=ctt+1;
    end
%     axis off;

end
set(gcf,'renderer','painters');