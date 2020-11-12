function behav_rescale(behavname,real_arena_size_length)

for i=1:length(behavname)
    load(behavname{i});
    
    trackLength_ori=behav.trackLength;
    
    behav.position=behav.position/trackLength_ori*real_arena_size_length;
    behav.positionblue=behav.positionblue/trackLength_ori*real_arena_size_length;
    behav.ROI=behav.ROI/trackLength_ori*real_arena_size_length;
    % adjust object pos to real box size
    behav.object=behav.object/trackLength_ori*real_arena_size_length;
    
    behav.trackLength=real_arena_size_length;
    
    save(behavname{i},'behav','velosmallthan3');
end
