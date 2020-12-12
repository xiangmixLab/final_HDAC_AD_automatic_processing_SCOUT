% the behav input is supposed to have positionbody and behavOri
function behav_with_quiver_121020(behav,behavprefix,quiver_dat)

behavVidName_struct=dir([behav.oripath,'\',behavprefix,'*.avi']);
behavVidName={};
for i=1:length(behavVidName_struct)
    behavVidName{i}=behavVidName_struct(i).name;
end
behavVidName=natsort(behavVidName);

all_behav_frames={};
ctt=1;
for i=1:length(behavVidName)
    v=VideoReader([behav.oripath,'\',behavVidName{i}]);
    while hasFrame(v)
        all_behav_frames{ctt}=readFrame(v);
        ctt=ctt+1;
    end
end

figure;
quiver_dat=quiver_dat*behav.ROI3/behav.trackLength;
behav.ROI=behav.ROI*behav.ROI3/behav.trackLength;
for k=1:length(all_behav_frames)
    imagesc(all_behav_frames{k});
    hold on;
    quiver(quiver_dat(1),quiver_dat(2),quiver_dat(3)/2,quiver_dat(4)/2);
    drawnow;
end