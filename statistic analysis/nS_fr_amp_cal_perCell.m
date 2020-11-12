function [fr,amp]=nS_fr_amp_cal_perCell(nS)
    
    thresh=max(nS,[],2)*0.1;
    for i=1:size(nS,1)
        t=nS(i,:);
        t(t<thresh(i))=0;
        nS(i,:)=t;
    end
    nS1=nS;
    nS1(nS1==0)=nan;
    nS2=nS>0;
    
    fr=nansum(nS2,2)/(size(nS2,2)/15);        
    amp=nansum(nS1,2);
end