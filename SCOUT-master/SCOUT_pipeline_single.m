function []=SCOUT_pipeline_single(fname,num2read,data_shape)

%Global cell tracking parameters
[pathh,fnamee]=fileparts(fname);
cd(pathh);

extraction_options.JS=.09; %(spatial constraint parameter, this is too low for in vivo data, it should be at least 0.1)
        


tic
neuron=full_demo_endoscope([fnamee,'.mat'],extraction_options);
toc

for i=1:length(neuron)
    neuron.MergeNeighbors([2,15]);
end

neuron.num2read=num2read;
neuron.imageSize=data_shape;

Cn=neuron.Cn;
[neuron.Coor,json_file,centroid] = plot_contours(neuron.A, Cn, 0.8, 0, [], [], 2);

saveas(gcf,[[pwd,'\','contours.tif']],'tif')
saveas(gcf,[[pwd,'\','contours.eps']],'epsc')
saveas(gcf,[[pwd,'\','contours.fig']],'fig')
close

neuron.centroid=centroid;

save([pwd,'\','further_processed_neuron_extraction_final_result.mat'],'neuron','-v7.3')


