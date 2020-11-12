function nS=C_to_peakS_new(nC,nSo)

nS=[];
for i=1:size(nC,1)
    t=nC(i,:);
    [pks,loc]=findpeaks(t);
    t=t*0;
    
    loc1=find(nSo(i,:)>0);
    idx_rm=[]; % if loc1 is more than loc
    for j=1:length(loc1)
        diff_loc=abs(loc-loc1(j));
        if min(diff_loc)>15 % difference more than 1 sec
            idx_rm=[idx_rm j];
        end
    end
    
    loc1(idx_rm)=[];
    
    pks1=[];
    for j=1:length(loc1)
        diff_loc=abs(loc-loc1(j));
        pks1(j)=pks(diff_loc==min(diff_loc));
    end
        
    t(loc1)=pks1;
    nS(i,:)=t;
end