% if no fs2, please left it empty
function rateMap_corr=rateMap_correlation(fs1,fs2,ct1,ct2,resize_sign)
rateMap_corr=[];
ctt=1;

if ~isempty(fs2)
    for i=1:length(fs1)
        if ~isempty(fs1{i})&&~isempty(fs2{i})
            cell1=fs1{i};
            cell2=fs2{i};
            cell1=filter2DMatrices(cell1,1);
            cell2=filter2DMatrices(cell2,1);
            if resize_sign==1
                cell2=imresize(cell2,[size(ct1,1),size(ct1,2)]);
                ct2=imresize(ct2,[size(ct1,1),size(ct1,2)]);
            end
    %         cell1(ct1==0)=nan; % get rid of non trespassing periods, avoid unnecessary correlation boost
    %         cell2(ct2==0)=nan;
            cell1t=reshape(cell1,size(cell1,1)*size(cell1,2),1);
            cell2t=reshape(cell2,size(cell2,1)*size(cell2,2),1);
    %         idx=~isnan(cell1t);
            if isempty(cell1t)
                cell1t=cell2t*0;
            end
            if isempty(cell2t)
                cell2t=cell1t*0;
            end
    %         cell1t(isnan(cell1t))=[];
    %         cell2t(isnan(cell2t))=[];     

            rm_corr=corrcoef(cell1t,cell2t);
            rateMap_corr(ctt)=rm_corr(1,2);
            ctt=ctt+1;
        end
     end
else
    for i=1:length(fs1)-1
        for j=i+1:length(fs1)
            cell1=fs1{i};
            cell2=fs1{j};
            cell1=filter2DMatrices(cell1,1);
            cell2=filter2DMatrices(cell2,1);
            cell1(ct1==0)=nan; % get rid of non trespassing periods, avoid unnecessary correlation boost
            cell2(ct1==0)=nan;
            cell1=reshape(cell1,size(cell1,1)*size(cell1,2),1);
            cell2=reshape(cell2,size(cell2,1)*size(cell2,2),1);
            if isempty(cell1)
                cell1=cell2*0;
            end
            if isempty(cell2)
                cell2=cell1*0;
            end
            cell1(isnan(cell1))=[];
            cell2(isnan(cell2))=[];
            rm_corr=corrcoef(cell1,cell2);
            rateMap_corr(ctt)=rm_corr(1,2);
            ctt=ctt+1;
        end
     end
end