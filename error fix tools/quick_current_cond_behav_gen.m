for i=1:length(behavname)
    load(behavname{i});
    behavpos=behav.position;
    behavtime=behav.time;
    [dirr,namee]=fileparts(behavname{i});
    mkdir([dirr,'\',namee(1:end-6)]);
    save([dirr,'\',namee(1:end-6),'\','current_condition_behav.mat'],'behavpos','behavtime');
end