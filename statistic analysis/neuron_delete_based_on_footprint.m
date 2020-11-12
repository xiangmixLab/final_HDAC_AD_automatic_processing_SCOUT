function neuron0=neuron_delete_based_on_footprint(neuron)

sft=spatial_footprint_calculation(neuron,0.6);
cen=neuron.centroid;

imshowpair(sft,neuron.Cn);
[J,I]=getpts;

del_idx=[];
close;
for i=1:length(I)
    dist=sum((cen-[I(i),J(i)]).^2,2).^0.5;
    del_idx(i)=find(dist==min(dist));
end

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

    
    