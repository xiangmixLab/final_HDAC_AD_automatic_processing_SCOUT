clear all;
tfilename=dir('timestamp*.dat');
lengk=sum(~cellfun(@isempty,{tfilename.name}));

fulltimestamp=cell(lengk,1);
for i=1:lengk
    filenamet=tfilename(i).name;
    fid=fopen(filenamet,'r');
    timedata = textscan(fid, '%d%d%d%d', 'HeaderLines', 1);
    timedata=cell2mat(timedata);
    if i>1
        timedata(1:2,3)=0;
    for j=1:size(timedata,1)
        if timedata(j,1)==1
            tt1=fulltimestamp{i-1,1}(fulltimestamp{i-1,1}(:,1)==1,2);
            timedata(j,2)=timedata(j,2)+tt1(end);
            tt2=fulltimestamp{i-1,1}(fulltimestamp{i-1,1}(:,1)==1,3);
            timedata(j,3)=timedata(j,3)+tt2(end)+10;
        end
        if timedata(j,1)==0
            tt1=fulltimestamp{i-1,1}(fulltimestamp{i-1,1}(:,1)==0,2);
            timedata(j,2)=timedata(j,2)+tt1(end);
            tt2=fulltimestamp{i-1,1}(fulltimestamp{i-1,1}(:,1)==0,3);
            timedata(j,3)=timedata(j,3)+tt2(end)+10;
        end
    end
    end
    fulltimestamp{i,1}=timedata;   
    fclose(fid);
end

fulltimestamp_mat=cell2mat(fulltimestamp);
fileID = fopen('timestamp.dat','w');
fprintf(fileID,'%6s %6s %6s %6s\r\n','camNum','frameNum','sysClock','buffer');
fprintf(fileID,'%6d %6d %6d %6d\r\n',fulltimestamp_mat');
fclose(fileID);