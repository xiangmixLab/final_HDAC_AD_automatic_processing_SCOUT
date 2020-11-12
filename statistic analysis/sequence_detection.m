function [PC_reconstruct_out,idx_final,PC,ori_data_sort_out]=sequence_detection(sin_data)
%% step1: PCA reconstruct
gaussianWindow=fspecial('gaussian',[1 60],10); % 4sec gausswin, std=5, already normalized
sin_data1=[];
for i=1:size(sin_data,1)
    sin_data1(i,:)=conv(sin_data(i,:),gaussianWindow,'same');
end

[coeff1, score1, latent, tsquared, explained, mu1] = pca(sin_data1');


corr_dat=[];
for i=1:size(score1,2)-1
    ori_reshape=sum(sin_data1,1)';
    coeff2=coeff1;
    coeff2(:,i+1:end)=coeff2(:,i+1:end)*0;
    PC_reconstruct=(score1 *coeff2')' + mu1'; % see pca explantation of matlab. coeff each column is a PC, score1 each column is a PC too
    PC_reshape=sum(PC_reconstruct,1);
    t=corrcoef(ori_reshape,PC_reshape');
    corr_dat(i)=t(2);
end
diff_corr_dat=diff(corr_dat);
max_corr_idx=find(diff_corr_dat==max(diff_corr_dat))+1;

coeff2=coeff1*0;
coeff2(:,1:3)=coeff1(:,1:3);
PC_reconstruct=(score1 *coeff2')' + mu1'; % see pca explantation of matlab. coeff each column is a PC, score1 each column is a PC too
PC=sum(score1(:,1:3),2);
%% step2: reorder
nC=PC_reconstruct;

% find the one that happens "most earliest"
loc_min=[];
pairwise_xcorr=[];
ctt=1;
for j1=1:size(nC,1)-1
    for j2=j1+1:size(nC,1)
        nC1=nC(j1,:);
        nC2=nC(j2,:);
        nC1= conv(nC1, gaussianWindow,'same');
        nC2= conv(nC2, gaussianWindow,'same');
        if sum(nC(j1,:))>1&&sum(nC(j2,:))>1
            xc=xcorr(nC(j1,:),nC(j2,:));
            pairwise_xcorr(ctt)=(find(xc==max(xc))-round(length(xc)/2))/abs(find(xc==max(xc))-round(length(xc)/2));
        else
            pairwise_xcorr(ctt)=0;
        end                    
        ctt=ctt+1;
    end
end

psqr=squareform(pairwise_xcorr);
sort_list=[];
for k=1:size(psqr,2)
    sort_list(k)=nansum(psqr(k,k:end));
end

reference_nC=nC(min(find(sort_list==min(sort_list))),:); % as long as the peaks goes first, no matter who
pairwise_xcorr=[];
for j1=1:size(nC,1)
    nC2=nC(j1,:);
    nCr= conv(reference_nC, gaussianWindow);
    nC2= conv(nC2, gaussianWindow);
    xc=xcorr(nC2,nCr); % if nC2 is left to reference is negative, vice versa
    if sum(xc)~=0
        pairwise_xcorr(j1)=find(xc==max(xc))-round(length(xc)/2);
    else
        pairwise_xcorr(j1)=0;
    end
end

[~,idx_final]=sort(pairwise_xcorr);

PC_reconstruct_out=PC_reconstruct(idx_final,:);
ori_data_sort_out=sin_data(idx_final,:);