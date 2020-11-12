foldername=unique(destination);
num2read={};
for i=1:length(foldername)
    k=[0];
    cd(foldername{i})
    fnamestruct=dir('12*.avi');
    for j=1:length(fnamestruct)
        fname=fnamestruct(j).name;
        v=VideoReader(fname);
        k(j+1)=v.Duration*v.FrameRate;
    end
    k(1)=sum(k(2:end));
    num2read{i}=k;
    disp('fin')
end