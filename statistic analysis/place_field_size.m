function [percentage_fr,sparsity]=place_field_size(fr,overall_rate,ct)

fr(fr<overall_rate)=0;
% fr=filter2DMatrices(fr,1);
% 
% fr=fr>max(fr(:))*0.5;
fr(ct==0)=0;

overall_size=sum(sum(ct>0));

fr_size=sum(sum(fr>0));

po=ct/sum(ct(:));
sparsity=sum(sum(ct.*fr)).^2/sum(sum(ct.*fr.^2));
percentage_fr=fr_size/overall_size;




