% the nC fr is not meaningful
% the nC fr is not meaningful
% the nC fr is not meaningful
function [fr,amp]=nC_fr_amp_cal_perCell(nS,nC)
    
    thresh=max(nS,[],2)*0.1;
    for i=1:size(nC,1)
        t=nC(i,:);
        t(t<thresh(i))=0;
        nC(i,:)=t;
    end
    nC1=nC;
    nC1(nC1==0)=nan;
    nC2=nC>0;
    
    fr=nansum(nC2,2)/(size(nC2,2)/15);        
    amp=nansum(nC1,2);
end