function [neuron_del,keep_idx]=low_fr_delete_neurons(neuron,rate_thresh,Fs)


nS=C_to_peakS(neuron.C);
for i=1:size(nS,1)
    ts=nS(i,:);
    ts(ts<max(ts)*0.1)=0;
    nS(i,:)=ts;
end

frS=sum(nS>0,2)/(size(nS,2)/Fs);
del_idx=find(frS<rate_thresh);

neuron_del=neuron.copy;

neuron_del.A(:,del_idx)=[];
neuron_del.C(del_idx,:)=[];
neuron_del.S(del_idx,:)=[];
neuron_del.trace(del_idx,:)=[];
neuron_del.C_df(del_idx,:)=[];
neuron_del.Coor(del_idx)=[];
neuron_del.centroid(del_idx,:)=[];

keep_idx=find(frS>=rate_thresh);