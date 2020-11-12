function [num2read,data_shape,fname_cell]=num2readDetermine(destination)
foldername=unique(destination);
num2read={};
fname_cell={};
for i=1:length(foldername)
    k=[0];
    cd(foldername{i})
    fnamestruct=dir('12*metric.mat');
    for j=1:length(fnamestruct)
        fname=fnamestruct(j).name;
        load(fname);
        k(j+1)=Ysize(3);
        fname_cell{j,i}=[foldername{i},'\',fname([1:strfind(fname,'metric')-1,strfind(fname,'metric')+6:length(fname)])];
    end
    k(1)=sum(k(2:end));
    num2read{i}=k;
    data_shape{i}=Ysize(1:2);
    disp('fin')
end