function [neuron0]=overlap_eliminate(neuron,data_shape)
tic
if size(data_shape,1)>1
    data_shape=squeeze(data_shape');
end

neuron0=neuron.copy;

indices=zeros(size(neuron.A,2),1);
KL=zeros(size(neuron.A,2),1);
nA=neuron.A;            
%% find neurons that have multiple peaks (double neurons) and delete
% for i=1:size(nA,2)
%     dshape=data_shape;
%     A=reshape(nA(:,i),dshape(1),dshape(2));
%     indices(i)=indices(i)+multiCenterNeuronDetection(A);
% end

%% delete overlap
for i=1:size(nA,2)
    dshape=data_shape;
    A=reshape(nA(:,i),dshape(1),dshape(2))>0;
    sign=overlapDetermine(A,nA,i,dshape,KL);
    indices(i)=indices(i)+sign;
end

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