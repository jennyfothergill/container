#!/bin/bash

#SBATCH -J Alphafold      # job name
#SBATCH -o log_slurm.o%j  # output and error file name (%j expands to jobID)
#SBATCH -N 1 		  # number of nodes you want to run on	
#SBATCH --gres=gpu:2
#SBATCH -p gpu            # queue (partition) -- bsudfq, eduq, gpuq, shortq
#SBATCH -t 12:00:00       # run time (hh:mm:ss) - 12.0 hours in this example.

# Generally needed modules:

module load slurm
module load alphafold

# Execute the program:
#singularity exec --nv -B /bsuscratch/alphafold_data,/bsuscratch/${USER}/alphafold_output $SIMG bash $alphafold_path/run_alphafold.sh -d /bsuscratch/alphafold_data -o /bsuscratch/${USER}/alphafold_output -m model_1 -f ./example_query.fasta -t 2020-05-14

run_alphafold.sh -d /bsuscratch/alphafold_data -o /bsuscratch/${USER}/alphafold_output -m model_1 -f ./example_query.fasta -t 2020-05-14
# Exit if mpirun errored:
status=$?
if [ $status -ne 0 ]; then
    exit $status
fi

# Do some post processing.
