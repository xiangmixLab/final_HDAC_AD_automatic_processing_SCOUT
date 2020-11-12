%% SCOUT spatialfilter para


spatial_filter_options.JS=0.11;
spatial_filter_options.data_shape=[dshape(1),dshape(2)];
spatial_filter_options.trim=false;
spatial_filter_options.gSiz=gSiz;
spatial_filter_options.gSizMin=gSiz;
spatial_filter_options.filter=true;
spatial_filter_options.threshold_per=[];
spatial_filter_options.Ysignal=[];
%Change spatial filter method. Current options 'gaussian','elliptical'

%To create your own spatial filter, define the function used to construct
%the probability distribution and place the filepath in the string (including parameters).
%This function should take in the current spatial footprint (temp_A) and outputs
%two possible comparison spatial footprints (due to orientation issues)
%For example

%spatial_filter_options.method='construct_comparison_footprint_ellipse(temp_A)';
% is equivalent to
spatial_filter_options.method='elliptical';