function ratemap_plot(fr,countTime,smoothsign,colorbar_sign)
if smoothsign==1
    fr=filter2DMatrices(fr,1);
end
fr(countTime==0)=nan;
pcolor(fr);

if colorbar_sign
    colorbar;
end

colormap(jet);
axis ij
shading flat;
axis image
axis off