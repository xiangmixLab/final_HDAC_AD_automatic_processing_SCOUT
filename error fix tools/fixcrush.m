%fix crush
function fixcrush(fixfolder,firstfolder,crushedfolder,mscamprefix,behavcamprefix)

mkdir(fixfolder);
%% msCam*.avi move
filenamestruct1ms=dir([firstfolder,'/',mscamprefix,'*.avi']);
lengk=sum(~cellfun(@isempty,{filenamestruct1ms.name}));
filenamet1ms={};
for k=1:lengk
    ft=filenamestruct1ms(k).name;
    num_c=ft(findstr(ft,mscamprefix)+length(mscamprefix):findstr(ft,'.avi')-1);
    num_ind=str2num(num_c);
    filenamet1ms{num_ind}=ft;
end
for k1=1:lengk
    copyfile([firstfolder,'/',filenamet1ms{k1}],[fixfolder,'/',[mscamprefix,num2str(k1),'.avi']]);
end

maxmsCamid=length(filenamet1ms);

for i=1:length(crushedfolder)
    crushedfn=crushedfolder{i};
    filenamestruct1msc=dir([crushedfn,'/',mscamprefix,'*.avi']);
    lengk=sum(~cellfun(@isempty,{filenamestruct1msc.name}));
    filenamet1msc={};
    for k=1:lengk
        ft=filenamestruct1msc(k).name;
        num_c=ft(findstr(ft,mscamprefix)+length(mscamprefix):findstr(ft,'.avi')-1);
        num_ind=str2num(num_c);
        filenamet1msc{num_ind}=ft;
    end
    for k1=1:lengk
        copyfile([crushedfn,'/',filenamet1msc{k1}],[fixfolder,'/',[mscamprefix,num2str(k1+maxmsCamid),'.avi']]);
    end
    maxmsCamid=maxmsCamid+lengk;
end

%% behavCam*.avi move
filenamestruct1behav=dir([firstfolder,'/',behavcamprefix,'*.avi']);
lengk=sum(~cellfun(@isempty,{filenamestruct1behav.name}));
filenamet1behav={};
for k=1:lengk
    ft=filenamestruct1behav(k).name;
    num_c=ft(findstr(ft,behavcamprefix)+length(behavcamprefix):findstr(ft,'.avi')-1);
    num_ind=str2num(num_c);
    filenamet1behav{num_ind}=ft;
end
for k1=1:lengk
    copyfile([firstfolder,'/',filenamet1behav{k1}],[fixfolder,'/',[behavcamprefix,num2str(k1),'.avi']]);
end
maxbehavCamid=length(filenamet1behav);

for i=1:length(crushedfolder)
    crushedfn=crushedfolder{i};
    filenamestruct1behavc=dir([crushedfn,'/',behavcamprefix,'*.avi']);
    lengk=sum(~cellfun(@isempty,{filenamestruct1behavc.name}));
    filenamet1behavc={};
    for k=1:lengk
        ft=filenamestruct1behavc(k).name;
        num_c=ft(findstr(ft,behavcamprefix)+length(behavcamprefix):findstr(ft,'.avi')-1);
        num_ind=str2num(num_c);
        filenamet1behavc{num_ind}=ft;
    end
    for k1=1:lengk
        copyfile([crushedfn,'/',filenamet1behavc{k1}],[fixfolder,'/',[behavcamprefix,num2str(k1+maxbehavCamid),'.avi']]);
    end
    maxbehavCamid=maxbehavCamid+lengk;
end

%% timestamp
copyfile([firstfolder,'/','timestamp.dat'],[fixfolder,'/','timestamp1.dat']);
for i=1:length(crushedfolder)
    crushedfn=crushedfolder{i};
    copyfile([crushedfn,'/','timestamp.dat'],[fixfolder,'/',['timestamp',num2str(i+1),'.dat']]);
end

cd(fixfolder);
timestamp_crush_fix;