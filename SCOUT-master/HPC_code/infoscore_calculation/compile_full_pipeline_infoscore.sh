

module load MATLAB
mcc ~/SCOUT/HPC_code/infoscore_calculation/full_pipeline_infoscore.m -m -v -d ~/SCOUT/HPC_code/infoscore_calculation/ -a ~/SCOUT/CNMF_E -I ~/SCOUT/HPC_code/ -I ~/SCOUT/ -a ~/SCOUT/Preprocessing -I ~/SCOUT/HPC_code/ 
	
qsub ~/SCOUT/HPC_code/infoscore_calculation/full_pipeline_infoscore.sh

