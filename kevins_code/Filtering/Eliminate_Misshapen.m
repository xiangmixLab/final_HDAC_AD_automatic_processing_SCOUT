function [neuron,KL]=Eliminate_Misshapen(neuron,KL_thresh,data_shape,constraint_type,width_crit,gSizMax,gSizMin,filter)

%constraint_type: 'bound', 'prc'

if ~exist('constraint_type','var')||isempty(constraint_type)
    constraint_type='prc';
end

if size(data_shape,1)>1;
    data_shape=squeeze(data_shape');
end
det_cov=[];
eig_ratio=[];
KL=[];
nA=neuron.A;
for i=1:size(neuron.A,2);

A=zeros(data_shape(1),data_shape(2));
[centroid,cov]=calculateCentroid_and_Covariance(squeeze(neuron.A(:,i)),data_shape(1),data_shape(2));
det_cov(i)=det(cov);
if isnan(det_cov(i))
    det_cov(i)=0;
end
try
    eigs=eig(cov);
    eig_ratio(i)=min(abs(eigs(1)/eigs(2)),abs(eigs(2)/eigs(1)));
catch
    eig_ratio(i)=0;
end
indices_rem=[];
try 
    parfor j=1:data_shape(1)*data_shape(2);
        [ind1,ind2]=ind2sub(data_shape,j);  
        A(j)=mvnpdf([ind2,ind1],centroid,cov);
    end
    A1=reshape(neuron.A(:,i),data_shape(1),data_shape(2));

    A=reshape(A,1,[]);
    
    thresh_indices=A<.2*max(max(A));
    neuron.A(thresh_indices,i)=0;
%     A1=reshape(neuron.A(:,i),data_shape(1),data_shape(2));

    [KL(i),mass(i)]=KLDiv_ori(A,A1);
    bw=reshape(neuron.A(:,i),data_shape(1),data_shape(2));
    bw=bw>0;
    
    stats= regionprops(full(bw),'MajorAxisLength','MinorAxisLength');
    max_diam(i)=stats.MajorAxisLength;
    min_diam(i)=stats.MinorAxisLength;
    
catch
    KL(i)=KL_thresh+10;
end
end

if isequal(constraint_type,'prc')
    try
        KL=(KL-mean(KL))/std(KL);
        KL_thresh=norminv(KL_thresh);
    end
end
size_thresh_rem=find(max_diam>gSizMax|min_diam<gSizMin);


if filter==true
if width_crit==true
    indices=[find(KL>KL_thresh),find(isoutlier(det_cov,'gesd','MaxNumOutliers',floor(.05*size(neuron.C,1)))),find(isoutlier(mass,'gesd','MaxNumOutliers',floor(.05*size(neuron.C,1)))),find(isoutlier(KL,'gesd','MaxNumOutliers',floor(.05*size(neuron.C,1)))),find(isoutlier(max_diam,'gesd','MaxNumOutliers',floor(.05*size(neuron.C,1)))),find(isoutlier(min_diam,'gesd','MaxNumOutliers',floor(.05*size(neuron.C,1))))];
else
    indices=find(KL>KL_thresh);
end
else
    indices=[];
end
for i=1:size(neuron.A,2);
    if sum(neuron.A(:,i))<=0
        indices=[indices,i];
    end
end
indices=[indices,size_thresh_rem];
try
    neuron.P.kernel_pars(indices)=[];
end
try
    neuron.P.sn_neuron(indices)=[];
end
try
    neuron.combined(indices,:)=[];
    neuron.scores(indices,:)=[];
catch
    'display no error';
end
try
    neuron.overlap_corr(indices,:)=[];
    neuron.overlap_KL(indices,:)=[];
catch
    'no error';
end
neuron.A(:,indices)=[];
neuron.C(indices,:)=[];
neuron.C_raw(indices,:)=[];
neuron.S(indices,:)=[];
