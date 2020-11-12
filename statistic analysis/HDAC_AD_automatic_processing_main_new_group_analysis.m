%% HDAC AD common processing script
function HDAC_AD_automatic_processing_main_new_group_analysis(nameparts,foldernamet,numpartsall,exp,processingparts,objname,num_of_conditions,binsize,in_use_objects,temp)
% clear all;clc

% nameparts_hdac_ad;
% foldername_hdac_ad;
% behavname_hdac_ad;
% timestamp_hdac_ad;
% camid_hdac_ad;
% numpart_hdac_ad;
% num2read_hdac_ad;

% exp1=[10 12];
% processingparts=[1 0 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1];
% exceld=0;
% processingparts=zeros(1,25);
time_lag_period=[10 100 1];%[min(t) max(t)]
Fs_msCam=15;
countTimeThresh=[0.2 10];


%% start
group_analysis_settings;
[conditionfolder,conditionfolder2]= HDAC_AD_foldername_set(nameparts,num_of_conditions,numpartsall{1});  

if processingparts(1)==1
    count_event_time_fr_all_analysis(group,cfolder1,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,objname,num_of_conditions,boxlength,exp,temp);
end
if processingparts(2)==1
    count_event_time_fr_all_analysis_look_at_obj(group,cfolder2,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,num_of_conditions,boxlength,exp);
end
if processingparts(3)==1
    distance_orientation_all_analysis(group,cfolder3,groupname,nameparts,conditionfolder,num_of_conditions,foldernamet,numpartsall,in_use_objects,exp);   
end
if processingparts(4)==1
    distance_orientation_rate_all_analysis(group,cfolder8,groupname,nameparts,conditionfolder,num_of_conditions,foldernamet,numpartsall,in_use_objects,exp);   
end
if processingparts(5)==1
    distance_time_all_analysis(group,cfolder11,groupname,nameparts,conditionfolder,num_of_conditions,foldernamet,numpartsall,in_use_objects,exp);   
    distance_time_all_analysis_cdf(group,cfolder11,groupname,nameparts,conditionfolder,num_of_conditions,foldernamet,numpartsall,in_use_objects,exp);   
end
%     calcium_trace_section;
close all;

if processingparts(6)==1
    histogram_plot(cfolder4,group,groupname,nameparts,foldernamet,exp) ;
end
if processingparts(7)==1
    histogram_plot_all_box(group,groupname,cfolder5,foldernamet,nameparts,exp,'C');  
end
if processingparts(8)==1
    histogram_plot_all_box(group,groupname,cfolder5,foldernamet,nameparts,exp,'S');
end
if processingparts(9)==1
    histogram_plot_all_box_no_spatial(group,groupname,cfolder6,foldernamet,nameparts,exp,'C')
end
if processingparts(10)==1
    histogram_plot_all_box_no_spatial(group,groupname,cfolder6,foldernamet,nameparts,exp,'S')
end
if processingparts(11)==1
    histogram_plot_intra_inter_cluster_dis(cfolder12,group,groupname,nameparts,foldernamet,exp,conditionfolder2,[2 3])    
end
close all;

