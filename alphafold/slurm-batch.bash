#!/bin/bash

#SBATCH -J Alphafold      # job name
#SBATCH -o log_slurm.o%j  # output and error file name (%j expands to jobID)
#SBATCH -N 1 		  # number of nodes you want to run on	
#SBATCH --gres=gpu:2
#SBATCH -p gpu            # queue (partition) -- defq, eduq, gpuq, shortq
#SBATCH -t 12:00:00       # run time (hh:mm:ss) - 12.0 hours in this example.

# Generally needed modules:
module load slurm
module load singularity

export SIMG=/cm/shared/apps/singularity/containers/alphafold.sif
export OUTPUT_DIR=$HOME/scratch/alphafold_output
export DATA_DIR=/bsuscratch/alphafold_data

# Execute the program:
singularity exec --nv -B $DATA_DIR,$OUTPUT_DIR $SIMG bash run.sh -d $DATA_DIR -o $OUTPUT_DIR -m model_1 -f $DATA_DIR/mgnify/mgy_clusters_2018_12.fa -t 2020-05-14

# Exit if mpirun errored:
status=$?
if [ $status -ne 0 ]; then
    exit $status
fi

# Do some post processing.
