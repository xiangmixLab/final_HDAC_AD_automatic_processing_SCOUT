function [neuron0,del_ind]=auto_deletion_main(neuron)
%Allows for manual identification of false discoveries
del_ind=zeros(size(neuron.C,1),1);
KL_thresh=0.3;
% footprints
nA=neuron.A;
roundness=[];
for i=1:size(neuron.A,2)
    dshape=neuron.imageSize;
    [centroid,cov]=calculateCentroid_and_Covariance(nA(:,i),dshape(1),dshape(2));
    if ~isempty(centroid)&&~isempty(cov)&&(sum(sum(isnan(centroid)))==0||sum(sum(isnan(cov)))==0)
        A=mvnpdf_cal(dshape,centroid,cov);
        At=A;
        A1=nA(:,i);
        A=reshape(A,1,size(A,1)*size(A,2))';

        [KLt]=KLDiv_ori(A,A1);

        KL(i)=KLt;
        stats=regionprops(At>max(At(:))*0.5,'MajorAxisLength','MinorAxisLength');
        roundness(i)=stats.MajorAxisLength/stats.MinorAxisLength;
        if KL(i)>KL_thresh || stats.MajorAxisLength/stats.MinorAxisLength>2.5
            del_ind(i)=1;
        end
    else
        del_ind(i)=0;
    end
end

% temporal: 3 criterias
nC=neuron.C;
nC_thres=[];
thres=0.1*max(nC,[],2);
for i=1:size(nC,1)
    nCt=nC(i,:);
    nCt(nCt<=thres(i))=thres(i);
    nCt=nCt-thres(i);
    nC_thres(i,:)=nCt;
end

temp_del_idx=zeros(length(del_ind),2);
max_area=[];
for i=1:size(nC,1)
    nCt=nC_thres(i,:);
    % 1: have at least 5 peaks
    [pks,ind]=findpeaks(nCt);
    if length(pks)<5
        temp_del_idx(i,1)=1;
        continue;
    end
    % 2: do not have continuous peak bump (continuous high-than-0 region
    % that longer than 30sec)
    nCt_b=nCt>0;
    stats=regionprops(nCt_b);
    area_all=[stats.Area];
    max_area(i)=max(area_all);
    if max(area_all)>15*120 % 2 min or more
        temp_del_idx(i,2)=1;
        continue;
    end   
end

del_ind(temp_del_idx(:,1)==1)=1;
del_ind(temp_del_idx(:,2)==1)=1;

del_idx=find(del_ind==1);
neuron0=neuron.copy;
try
neuron0.A(:,del_idx)=[];
catch
end

try
neuron0.C(del_idx,:)=[];
catch
end

try
neuron0.C_raw(del_idx,:)=[];
catch
end

try
neuron0.S(del_idx,:)=[];
catch
end

try
neuron0.Coor(del_idx)=[];
catch
end

try
neuron0.centroid(del_idx,:)=[];
catch
end

try
neuron0.A_prev(del_idx,:)=[];
catch
end

try
neuron0.C_prev(del_idx,:)=[];
catch
end

try
neuron0.trace(del_idx,:)=[];
catch
end

try
neuron0.trace_raw(del_idx,:)=[];
catch
end

try
neuron0.C_df(del_idx,:)=[];
catch
end

try
neuron0.Df(del_idx,:)=[];
catch
end

    