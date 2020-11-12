for i=2:2
    fpath=fileparts(foldernamestruct{i});
    cd(fpath)
    load('neuron_extraction_final_results_kevin_ori.mat');
    [neuron,KL]=Eliminate_Misshapen_new(neuron,[240 376],0.3);
    save('further_processed_neuron_extraction_final_results.mat','neuron');
    Cn=neuron.Cn;
    [neuron.Coor,json_file,centroid] = plot_contours_cellspec(neuron.A, Cn, 0.8, 1, [], [], 2,[],[1 2 4 5 6]);
    saveas(gcf,[['contours.tif']],'tif')
    saveas(gcf,[['contours.eps']],'epsc')
    saveas(gcf,[['contours.fig']],'fig')
    close
end