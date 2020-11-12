Username='lujiac1';
Hostname='hpc.oit.uci.edu';
Password='Yzc1945yzc1945';
ssh2_conn=ssh2_config(Hostname,Username,Password);
ssh2_conn=ssh2_command(ssh2_conn,'qstat -u lujiac1');

for i=23
    slash_pos=strfind(HPC_dir{i},'\');
    disp('******************************************************************');
    cmd=[['pscp -P 22 -r ',Username,'@',Hostname,':','/pub/lujiac1/AD_square_circle_results_092320/HPC_processing/',HPC_dir{i}(slash_pos(end)+1:end),'/motion_corrected/registered/further_processed_neuron_extraction_final_result.mat',' ','D:\AD_square_circle_results_092320\HPC_processing\HPC_processing\',HPC_dir{i}(slash_pos(end)+1:end),'/motion_corrected/registered/further_processed_neuron_extraction_final_result.mat']];
    disp(num2str(i))
    system(cmd);
end

% 2 6 10 15 11 12 16 17 23