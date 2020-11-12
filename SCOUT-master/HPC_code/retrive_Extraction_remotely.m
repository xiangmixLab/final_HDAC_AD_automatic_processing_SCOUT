function retrive_Extraction_remotely(extraction_folder)
cd(extraction_folder)
fnamestruct=dir('workspace*.mat');
load(fnamestruct.name);

%% Check to see if extraction completed
%Check if extraction has finished, if so, move data back to local server
ssh2_conn=ssh2_config(Hostname,Username,Password);
ssh2_conn=ssh2_command(ssh2_conn,'qstat -u lujiac1');
job_running=false;
for k=1:length(ssh2_conn.command_result)
    if length(strfind(ssh2_conn.command_result{k},num2str(job_num)))>0
        job_running=true;
    end
end
try
    ssh2_conn=scp_get(ssh2_conn,{['batchendoscope.o',num2str(job_num)],...
    ['batchendoscope.e',num2str(job_num)]},'.','~/');
end
if ~job_running
    disp('Data Extracted (or extraction failed)')
    try
        ext_path=regexp(extraction_folder,filesep,'split');
        ext_path1='';
        if isunix
            ext_path1='/';
        end
        for k=1:length(ext_path)-2
            if ~isempty(ext_path{k});
                
                ext_path1=[ext_path1,ext_path{k},filesep];
            end
        end
        %Delete reg.mat and frame_all.mat files
        ssh2_conn=ssh2_command(ssh2_conn,['rm ',Host_folder,'/*reg.mat']);
        ssh2_conn=ssh2_command(ssh2_conn,['rm ',Host_folder,'/*frame_all.mat']);
        
        %Move data to local machine (This has to be run on the system to
        %retrieve folders recursively
        if ispc %Requires putty
            cmd=['pscp -P 22 -r ',Username,'@',Hostname,':',Host_folder,' ', [ext_path1,'.']];
        else
            cmd=['scp -r ',Username,'@',Hostname,':',Host_folder,' ', ext_path1];
        end
        system(cmd);
        
        cmd=['rm -r ', Host_folder];
        
        ssh2_conn=ssh2_command(ssh2_conn,cmd);
    end
else
    disp('Code is still running')
   
end

ssh2_conn = ssh2_close(ssh2_conn);


