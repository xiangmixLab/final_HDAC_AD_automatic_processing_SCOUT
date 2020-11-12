#!/bin/bash 
#$ -S /bin/bash 
#$ -N batchendoscope 
#$ -q free64
#$ -ckpt restart
#$ -l mem_size=512
#$ -cwd 
#$ -pe one-node-mpi 8
TMPDIR=./${RANDOM}
mkdir $TMPDIR
export MCR_CACHE_ROOT=$TMPDIR
 module load MATLAB
~/SCOUT/HPC_code/full_pipeline/full_pipeline_hpc_code_concatenate_tracking $'/pub/lujiac1/AD_ORM_result_102820/HPC_processing/AD_ORM_result_102820_AD_ORM_result_102820/188'
