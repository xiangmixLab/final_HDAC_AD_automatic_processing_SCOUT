function [acf,lag,acf_hl]=autocorrelation_calcium(gp,nCt)

acf={};
lag={};

acf_hl_t=[];
for k=1:length(unique(gp))
    rangee=find(gp == k);
    nC=nCt(rangee,1:end)';
    nC_sum=sum(nC,1);
    [acf{k},lag{k}] = xcorr(nC_sum','coeff');
    acf_hl_t=[acf_hl_t,(length(acf{k})/2)/15]; %Fs=15
end
acf_hl=mean(acf_hl_t);

