function f=behav_load_frames(orilocation_c)

f={};
behavVidName_struct=dir([orilocation_c,'\','behavCam*.avi']);
behavVidName={};
for i=1:length(behavVidName_struct)
    behavVidName{i}=[orilocation_c,'\',behavVidName_struct(i).name];
end
ctt=1;
for i=1:length(behavVidName)
    v=VideoReader(behavVidName{i});
    while hasFrame(v)
        f{ctt}=readFrame(v);
        ctt=ctt+1;
    end
end