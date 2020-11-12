% virtual place cells

pos1 = 1:binsize:ceil(maxbehavROI(3));
pos2 = 1:binsize:ceil(maxbehavROI(4));
matt=zeros(length(pos1),length(pos2));

nC_v=zeros(length(pos1)*length(pos2),size(behavpos,1)); % 30Hz

calcium_trans=exp([6:-0.02:0])-1;% suppose each transient lasts for 10 sec
calcium_trans=calcium_trans(2:end);

for i = 1:10:size(behavpos,1)-30*10 
    if ~isnan(behavpos(i,1))
        [~,idxx] = find(pos1 <= behavpos(i,1), 1, 'last');
        [~,idyy] = find(pos2 <= behavpos(i,2), 1, 'last');
        cell_idx(i)=sub2ind(size(matt),idxx,idyy);
        nC_v(cell_idx(i),i:i+299)=nC_v(cell_idx(i),i:i+299)+calcium_trans;
    else
    end
end

nS_v=C_to_peakS(nC_v);
ntemp.C=nC_v;
ntemp.S=nS_v;
ntemp.A=neuronIndividuals_new{1}.A;
ntemp.time=behavtime;

[firingrate,count,~,countTime] = calculatingCellSpatialForSingleData_Suoqin(ntemp,behavpos,behavtime,maxbehavROI,binsize,1:size(ntemp.C,1),zeros(size(ntemp.C,1),1),'S',[],[],[0 inf],10);

ctt=1;
v_pc=[];
for i=1:length(firingrate)
    if ~isempty(firingrate{i})
        v_pc(ctt)=i;
        ctt=ctt+1;
    end
end

ntemp.C=ntemp.C(v_pc,:);
ntemp.S=ntemp.S(v_pc,:);
ntemp.A=ntemp.A(:,v_pc);
