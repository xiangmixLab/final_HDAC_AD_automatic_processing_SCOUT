function crr=nC_corr(nC1,nC2)

crr=[];
for i=1:size(nC1) % suppose nC1 and nC2 HAS SAME NUMBER OF CELLS
    t1=nC1(i,:)';
    t2=nC2(i,:)';
    t1(isnan(t1))=0;
    t2(isnan(t2))=0;
    t2=resample(t2,length(t1),length(t2));
    cr=corrcoef(t1,t2);
    crr(i,1)=cr(2);
end

crr=nanmean(crr);