function submit_Extraction_Remotely_func_extraction_only(extraction_folder,put_vid)

cd(extraction_folder);

Username='lujiac1';
Hostname='hpc.oit.uci.edu';
Password='Yzc1945yzc1945';
SCOUT_loc='D:\\final_HDAC_AD_automatic_processing_SCOUT\\SCOUT-master\\'; %SCOUT location on local computer
SCOUT_loc_host='~/SCOUT/'; %SCOUT location on host (SCOUT should be at this location, as some paths are hardcoded)
Host_data_dir='/pub/lujiac1'; %Base data storage directory on host

%folder with video files on local computer
% extraction_folder='D:\AD_square_circle_results_092320\HPC_processing\batch4_972';

% wsn=dir('workspace*.mat');
% load(wsn.name)


%Create folder name on HPC
endout=regexp(extraction_folder,filesep,'split');
endout=endout(2:end); % usually the disk charater is included
for k=length(endout):-1:1
    if isempty(endout{k})
        endout(k)=[];
    end
end

% endout(1:end-4)=[];
Host_folder=Host_data_dir;
workspace_name='workspace';
for k=1:length(endout)
    Host_folder=[Host_folder,'/',endout{k}];
    workspace_name=[workspace_name,'_',endout{k}];
end
Host_folder(Host_folder==':')=[];

%Connect to HPC
ssh2_conn=ssh2_config(Hostname,Username,Password);
% ssh2_conn=ssh2_command(ssh2_conn,cmd);

%Construct Full Paths

options_ext='HPC_code\full_pipeline\full_pipeline_options_extraction_only.txt';
opt_path=regexp(options_ext,filesep,'split');
loc_path=regexp(SCOUT_loc,filesep,'split');
host_path=regexp(SCOUT_loc_host,'/','split');

loc_path(end+1:end+length(opt_path)-1)=opt_path(1:end-1);
host_path(end+1:end+length(opt_path)-1)=opt_path(1:end-1);

loc_path1='';
host_path1='';
if isunix
    loc_path1='/';
end
for k=1:length(loc_path)
    if ~isempty(loc_path{k})
        loc_path1=[loc_path1,loc_path{k},filesep];
    end
end
for k=1:length(host_path)
    if ~isempty(host_path{k})
        host_path1=[host_path1,host_path{k},'/'];
    end
end
           
loc_path=loc_path1;
host_path=host_path1;

%% if need to put vid
% put_vid=1;
if put_vid==1
    cmd=['mkdir -p ', Host_folder];
    ssh2_conn=ssh2_command(ssh2_conn,cmd);

    vids=dir(extraction_folder);
    vids={vids.name};
    vids(1:2)=[];
    if contains(vids(end),'workspace')
        vids=vids(1:end-1);
    end
    for k=1:length(vids)
        vids{k}=convert_recording(fullfile(extraction_folder,vids{k}));
    end
    for k=length(vids):-1:1
        if isempty(vids{k}) | ~isempty(strfind(vids{k},'.dir.mat'))
            vids(k)=[];
        end
    end
    for k=1:length(vids)
        [~,name,ext]=fileparts(vids{k});
        vids{k}=[name,ext];
    end
    ssh2_conn=scp_put(ssh2_conn,vids,Host_folder,extraction_folder);
end

ssh2_conn=scp_put(ssh2_conn,opt_path{end},Host_folder,loc_path,'full_pipeline_options.txt');

edit_sh_file_adapted([loc_path,'full_pipeline_hpc.sh'],Host_folder,'full_pipeline_hpc_code_concatenate_tracking');
ssh2_conn=scp_put(ssh2_conn,'full_pipeline_hpc.sh',host_path,loc_path);

ssh2_conn=ssh2_command(ssh2_conn,['test -f ',[host_path,'full_pipeline_hpc_code_concatenate_tracking'],' && echo "exists"']);
if ~isempty(ssh2_conn.command_result{1})
    %Submit job 
    cmd=['qsub ', [host_path,'full_pipeline_hpc.sh']];
    ssh2_conn=ssh2_command(ssh2_conn,cmd);
else
    disp('complie option');
    %Compile and run analysis code, this can take up to 30 minutes
    cmd=['bash ',[host_path,'compile_full_pipeline_concatenation.sh']];
    ssh2_conn=ssh2_command(ssh2_conn,cmd);
end


%Find job number
result=ssh2_conn.command_result{end};
result=split(result,' ');
for k=1:length(result)
    if ~isempty(str2num(result{k}))
        job_num=str2num(result{k});
        break
    end
end

ssh2_conn = ssh2_close(ssh2_conn);

load('HPC_job_table.mat');
size_table=size(HPC_job_table,1);
HPC_job_table{size_table+1,1}=job_num;
HPC_job_table{size_table+1,2}=extraction_folder;
save([fileparts(which('HPC_job_table.mat')),'\','HPC_job_table.mat'],'HPC_job_table');

save(workspace_name);
