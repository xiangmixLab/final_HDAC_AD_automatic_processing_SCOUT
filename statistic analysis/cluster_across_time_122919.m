% bad neuron remove loaded

fname={
'D:\Remapping_square_circle_triangle_061119_061319\M3424F\neuronIndividuals_new.mat'	
}

load(fname{1})

cond={
    'triangle1';
    'circle1';
    'square1';
    'circle2';
    'square2';
    'triangle2';
    }
for i=1:6
    neuron_temp=neuronIndividuals_new{i}.copy;
    win_leng=900;%1min, one waveform may have correlation witnin 10 sec, 60 sec can permit 6 spikes to correlate
    interval=1;
    time_series=1:15*interval:size(neuron_temp.C,2)-win_leng;% cluster of every 1 second
    session=1;
    load(['M3424F_',cond{i},'_','cluster_over_time','_',num2str(interval),'sInterval','.mat']);
    [group_all_1,group_all,group_model]=cluster_stability_illustrate_func(time_series,session,{neuron_temp},win_leng,group_model);
    save(['M3424F_',cond{i},'_','cluster_over_time','_',num2str(interval),'sInterval','_',num2str(win_leng/15),'sec_Segment','.mat'],'group_all_1','group_all','group_model');
end


%footprint illustration
A_color={};
for ip=1:length(group_all_1)
    A_color{ip}=cluster_spatial_footprint_colormap_2p({neuron_temp},363,548,distinguishable_colors(10),group_all_1{ip},0.4);
end
for ip=1:length(group_all_1)
    imagesc(A_color{ip});
    drawnow;
    pause(0.2)
end