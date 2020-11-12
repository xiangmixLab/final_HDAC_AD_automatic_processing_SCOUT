function [YPred,score]=auto_neuron_trim_temporal(dat,net)
YPred=[];
score=[];
for i=1:size(dat,1)
    dat_t=dat(i,:);
    dat_t=dat_t-min(dat_t);
    goodS=C_to_peakS(dat_t);
    goodS1=threshold_data(goodS,0.5*max(goodS,[],2));
    
    featuree=[sum(goodS1,2)./sum(goodS1>0,2),sum(dat_t,2)./sum(dat_t>0,2)]; % avg peak amp, integ amp
    
    [YPredt,scoret] = classify(net,featuree, 'SequenceLength','longest');
    YPred(i)=YPredt;
    score(i,:)=scoret;
end