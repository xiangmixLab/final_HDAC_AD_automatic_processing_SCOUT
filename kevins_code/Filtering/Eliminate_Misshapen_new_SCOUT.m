function [neuron0,KL,indices_rem]=Eliminate_Misshapen_new_SCOUT(neuron,data_shape,KL_thresh)
tic
if size(data_shape,1)>1
    data_shape=squeeze(data_shape');
end

neuron0=neuron.copy;

indices=zeros(size(neuron.A,2),1);
KL=zeros(size(neuron.A,2),1);

%% fit neuron to normal distribution
Cn=neuron.Cn;
nA=neuron.A;

for i=1:size(neuron.A,2)
    dshape=data_shape;
    [centroid,cov]=calculateCentroid_and_Covariance(nA(:,i),dshape(1),dshape(2));
%     det_cov=det(cov);
%     eigs=eig(cov);
%     eig_ratio=min(abs(eigs(1)/eigs(2)),abs(eigs(2)/eigs(1)));
    if ~isempty(centroid)&&~isempty(cov)&&(sum(sum(isnan(centroid)))==0||sum(sum(isnan(cov)))==0)
        A=mvnpdf_cal(data_shape,centroid,cov);
        
        A1=nA(:,i);
       
        A=reshape(A,1,size(A,1)*size(A,2))';

        [KLt]=KLDiv_ori(A1,A);

        KL(i)=KLt;
        if KL(i)>KL_thresh
            indices(i)=1;
        end
    else
        indices(i)=1;
    end
end

%% find if there's multi-peak neurons and delete them
% neuron0=thresholdNeuron(neuron0,0.2);
nA=neuron0.A;
parfor i=1:size(neuron0.A,2)
    dshape=data_shape;
    A=reshape(nA(:,i),dshape(1),dshape(2));
    indices(i)=indices(i)+multiCenterNeuronDetection(A);
end
            
%% find overlap neurons and delete the one with larger idx
% 
% parfor i=1:size(nA,2)
%     dshape=data_shape;
%     A=reshape(nA(:,i),dshape(1),dshape(2))>0;
%     sign=overlapDetermine(A,nA,i,dshape,KL);
%     indices(i)=indices(i)+sign;
% end

%% find temporal traces that have a continuous long larger-than-thres-period 
parfor i=1:size(nA,2)
    Ct=neuron0.C(i,:);
    Ct(Ct<3*std(Ct))=0;
    statsss=regionprops(logical(Ct),'Area');
    Area_all=[statsss.Area];
    if max(Area_all)>900 % if lasts more than 2 min
        indices(i)=indices(i)+1;
    end
end
% indices=indices+double(overlapind>=1);
indices_rem=indices>0;

try
    neuron0.P.kernel_pars(indices_rem)=[];
catch
    'display no error';
end
try    
    neuron0.combined(indices_rem,:)=[];
catch
    'display no error';
end
try    
    neuron0.scores(indices_rem,:)=[];
catch
    'display no error';
end
try
    neuron0.overlap_corr(indices_rem,:)=[];
    neuron0.overlap_dist(indices_rem,:)=[];
catch
    'no error';
end
try
    neuron0.corr_scores(indices_rem,:)=[];
    neuron0.corr_prc(indices_rem,:)=[];
    neuron0.dist(indices_rem,:)=[];
    neuron0.dist_prc(indices_rem,:)=[];
catch
    'no error';
end

try
neuron0.A(:,indices_rem)=[];
catch
end

try
neuron0.C(indices_rem,:)=[];
catch
end

try
neuron0.C_raw(indices_rem,:)=[];
catch
end

try
neuron0.S(indices_rem,:)=[];
catch
end

try
neuron0.Coor(indices_rem)=[];
catch
end

try
neuron0.centroid(indices_rem,:)=[];
catch
end

try
neuron0.A_prev(indices_rem,:)=[];
catch
end

try
neuron0.C_prev(indices_rem,:)=[];
catch
end

try
neuron0.trace(indices_rem,:)=[];
catch
end

try
neuron0.trace_raw(indices_rem,:)=[];
catch
end

try
neuron0.C_df(indices_rem,:)=[];
catch
end

try
neuron0.Df(indices_rem,:)=[];
catch
end
toc;