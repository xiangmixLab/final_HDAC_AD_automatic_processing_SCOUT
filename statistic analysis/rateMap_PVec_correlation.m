% if no fs2, please left it empty
% fs2 and ct2 is supposed to be adjusted to a traj similar as fs1 and ct1 by to_circle_behav
function rateMap_corr=rateMap_PVec_correlation(fs1,fs2,ct1,ct2)
rateMap_corr=[];


fs1_pvec=[];
fs2_pvec=[];

ctt=1;
for i=1:length(fs1)
    if ~isempty(fs1{i})&&~isempty(fs2{i})
        cell1=filter2DMatrices(fs1{i},1);
        cell2=filter2DMatrices(fs2{i},1);
        cell1(ct1==0)=nan;
        cell2(ct2==0)=nan;
        fs1_pvec(:,:,ctt)=cell1;
        fs2_pvec(:,:,ctt)=cell2;
        ctt=ctt+1;
    end
end

for i=1:size(fs1_pvec,1)
    for j=1:size(fs1_pvec,2)  
        rm_corr=corrcoef(fs1_pvec(i,j,:),fs2_pvec(i,j,:));
        rateMap_corr(i,j)=rm_corr(2);
    end
 end
rateMap_corr=nanmean(rateMap_corr(:));