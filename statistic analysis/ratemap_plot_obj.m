function ratemap_plot_obj(fr,countTime,smoothsign,colorbar_sign,obj,binsize)
if smoothsign==1
    fr=filter2DMatrices(fr,1);
end
fr(countTime==0)=nan;

pcolor(fr);
hold on;
if ~isempty(obj)
    for i=1:size(obj,1)
        obj(i,:)=round(obj(i,:)./binsize);
        obj(i,2)=size(fr,1)-obj(i,2); % axes problems
        plot(obj(i,1),obj(i,2),'.','MarkerSize',48,'color','k');
        hold on;
    end
end

if colorbar_sign
    colorbar;
end

colormap(jet);
axis ij
shading flat;
axis image
axis off

