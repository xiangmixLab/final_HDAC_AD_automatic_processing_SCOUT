#!/bin/bash 
#$ -S /bin/bash 
#$ -N batchendoscope 
#$ -q free64
#$ -ckpt restart
#$ -cwd 
#$ -pe one-node-mpi 8
TMPDIR=./${RANDOM}
mkdir $TMPDIR
export MCR_CACHE_ROOT=$TMPDIR
module load MATLAB
~/SCOUT/HPC_code/full_pipeline/full_pipeline_infoscore $'/pub/lujiac1/AD_square_circle_results_092320/AD_young/143'
