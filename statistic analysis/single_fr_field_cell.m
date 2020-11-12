function idx=single_fr_field_cell(firingrate)
idx=zeros(length(firingrate),1);
for i=1:length(firingrate)
    fr=firingrate{i};
    fr(fr<0.5*max(fr(:)))=0;
    fr=filter2DMatrices(fr,1);
    fr=logical(fr);
    
    stats=regionprops(fr);
    if size(stats,1)==1&&stats(1).Area>=4&&stats(1).Area<0.1*size(fr,1)*size(fr,2)
        idx(i)=1;
    end
end

%%This code is to sort out cells that only have single firing field. After
%%running this code, load variables and if index is 1, then this cell has
%%single firing field. 