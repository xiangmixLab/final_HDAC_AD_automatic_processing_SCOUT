function nS1=threshold_data(nS,thres)

nS1=nS;

for i=1:size(nS1,1)
    nS1t=nS1(i,:);
    nS1t(nS1t<thres(i))=0;
    nS1(i,:)=nS1t;
end