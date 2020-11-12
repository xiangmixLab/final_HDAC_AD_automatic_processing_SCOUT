function [num2read,fname,data_shape]=cross_condition_info_extraction(destination,rangee)

num2read={};
fname={};
data_shape={};

udes=unique(destination);
for i=1:length(rangee)
    cd(udes{rangee(i)});
    fname_struct=dir('*metric.mat');
    
    num2readt=[];
    for j=1:length(fname_struct)
        fnamet=fname_struct(j).name;
        fname{i}{j}=[udes{rangee(i)},'\',fnamet(1:end-10),'.mat'];
        load(fnamet);
        if exist('Ysize')==1
           num2readt(j)=Ysize(3); 
        end
        if exist('Ysiz')==1
           num2readt(j)=Ysiz(3); 
        end        
    end
    num2read{i}=num2readt;
    if exist('Ysize')==1
       data_shape{i}=Ysize(1:2);
    end
    if exist('Ysiz')==1
       data_shape{i}=Ysiz(1:2);
    end 
end