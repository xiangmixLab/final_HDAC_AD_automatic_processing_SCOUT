Username='lujiac1';
Hostname='hpc.oit.uci.edu';
Password='Yzc1945yzc1945';

ssh2_conn=ssh2_config(Hostname,Username,Password);


for i=1:length(HPC_dir)
    slash_pos=strfind(HPC_dir{i},'\');
    disp('******************************************************************');
    cmd=[['dir /pub/lujiac1/AD_square_circle_results_092320/HPC_processing/',HPC_dir{i}(slash_pos(end)+1:end),'/motion_corrected/registered']];
    disp(num2str(i))
    ssh2_conn=ssh2_command(ssh2_conn,cmd);
end