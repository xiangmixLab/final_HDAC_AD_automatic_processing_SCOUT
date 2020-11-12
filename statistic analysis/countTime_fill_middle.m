function [fr_fill,ct_fill]=countTime_fill_middle(fr,ct1)

ct1(isnan(ct1))=0;
ct2=ct1>0;
ct3=imfill(ct2,'holes');
ct1(ct3==0)=nan;
ct_fill=ct1;

for i=1:length(fr)
    frt=fr{i};
    frt(isnan(ct_fill(:)))=nan;
    fr{i}=frt;
end

fr_fill=fr;