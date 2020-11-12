function ratemap_plot_binary(fr,countTime,smoothsign)
if smoothsign==1
    fr=filter2DMatrices(fr,1);
end

fr=double(fr>0.6*max(fr(:)));

fr(countTime==0)=nan;
pcolor(fr);

% colormap(jet);
axis ij
shading flat;
axis image
axis off