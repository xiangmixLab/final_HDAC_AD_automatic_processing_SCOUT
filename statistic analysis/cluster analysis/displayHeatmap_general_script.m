%display_heatmap_script
subplot(1,5,[2 5])

if 0
    imagesc(flip(CM1(perm,perm)));
else
    imagesc(CM1(perm,perm));
end
% axis square
set(gca,'Xtick',[]);set(gca,'Ytick',[])
colormap(bluewhitered2)
caxis([min(CM1(:)) max(CM1(:))])
c = colorbar;
c.Location = 'EastOutside';
c.Label.String = 'Simimarity';
c.Label.FontSize = 8;%c.Label.FontWeight = 'bold'
c.FontSize = 8;
title('CorrelationHeatMap');

subplot(1,5,1)
groupUni = unique(grouph(perm),'stable');
ybar = [];
for i = 1:1:optimalK
    ybar = [ybar,nnz(grouph == groupUni(i))];
end
H = bar([ybar;nan(1,length(ybar))],'stacked','BarWidth',0.0004,'ShowBaseLine','off','LineWidth',0.01);
k = 0;
for i = 1:1:optimalK
    k = k+1;
    set(H(i),'facecolor',colorClusters(groupUni(k),:))
end
axis tight
xlim([1 1.001])
set(gca,'xtick',1)
axis off
if 0
else
    axis ij;
end