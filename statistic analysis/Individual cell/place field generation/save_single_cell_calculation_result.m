function save_single_cell_calculation_result(conditionfolder,amplitude_normalized,amplitude,firingrate,count,countTime,firingrateS,countS,countTimeS,amplitude_normalizedS,amplitudeS,objects,behavpos,behavtime,thresh,maxbehavROI,headdirectioncell)
    save([conditionfolder,'/','single_cell_amplitude_profile.mat'],'amplitude_normalized','amplitude','objects');
    save([conditionfolder,'/','single_cell_amplitude_profile_S.mat'],'amplitude_normalizedS','amplitudeS','objects');
    save([conditionfolder,'/','single_cell_firing_profile.mat'],'firingrate','count','countTime','objects');
    save([conditionfolder,'/','single_cell_firing_profile_S.mat'],'firingrateS','countS','countTime','objects');
    save([conditionfolder,'/','current_condition_behav.mat'],'behavpos','behavtime','objects','headdirectioncell');
    save('thresh_and_ROI.mat','thresh','maxbehavROI');