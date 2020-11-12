function raw_trace_plot(nC,h)

ct=1;

nS=C_to_peakS(nC);
thresh=0.1*max(nS,[],2);
for i=1:size(nS,1)
    t=nS(i,:);
    t(t<thresh(i))=0;
    t=t>0;
    nS(i,:)=t;
end
peak_num=sum(nS,2);
[~,peak_num_sort_idx]=sort(peak_num);

for i=1:10:size(nC,1)
    t=nC(peak_num_sort_idx(i),:);
    t=t-mean(t);
    plot(h,t+(ct-1)*20,'color','b','lineWidth',2);
    ct=ct+1;
    hold on;
end