% Naoya Takahashi et al. 2010

load('neuronIndividuals_new.mat')

session=1;
dataC1=neuronIndividuals_new{session}.C;
dataS1=C_to_peakS(neuronIndividuals_new{session}.C);

% # of sync spikes
% expected sync spikes
% surprise index
thresh=repmat(3*std(dataS1,[],2),1,size(dataC1,2));
dataC1(dataC1<thresh)=0;

ctt=1;
Fs=15;
for i=1:size(dataS1,1)-1
    for j=i+1:size(dataS1,1)
        syncSpikes=sum(dataS1(i,:)>0.*dataS1(j,:)>0);
        
        fr1=sum(dataS1(i,:)>0)/(length(dataS1(i,:))/Fs);
        fr2=sum(dataS1(j,:)>0)/(length(dataS1(j,:))/Fs);
        m=fr1*fr2*(size(dataS1,2)/Fs);
        
        p=0;
        for k=0:syncSpikes-1
           p=p+(m^k)*exp(-m)/factorial(k);
        end
        p=1-p;
        
        S(ctt)=-log2(p);
        S(ctt)=real(S(ctt));
        ctt=ctt+1;
    end
end