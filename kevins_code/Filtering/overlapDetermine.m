function sign=overlapDetermine(A,nA,i,dshape,KL)
sign=0;
idx=-1;
for j=1:size(nA,2)
    A1=reshape(nA(:,j),dshape(1),dshape(2))>0;
    overlap=double(A).*double(A1);
    area_overlap=sum(overlap(:));
    area_A=sum(A(:));
    area_A1=sum(A1(:));
    if j~=i&&(area_overlap>area_A*0.8||area_overlap>area_A1*0.8) %  overlap
%         idx=max(KL(i),KL(j));
        idx=max(i,j);
    end
%     if idx==KL(i)
    if idx==i
        sign=sign+1;
    end        
end