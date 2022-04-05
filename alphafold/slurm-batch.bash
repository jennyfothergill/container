#!/bin/bash

#SBATCH -J Alphafold     # job name
#SBATCH -o log_slurm.o%j  # output and error file name (%j expands to jobID)
#SBATCH -N 1 		  # number of nodes you want to run on	
#SBATCH --gres=gpu:2
#SBATCH -p gpu         # queue (partition) -- defq, eduq, gpuq, shortq
#SBATCH -t 12:00:00       # run time (hh:mm:ss) - 12.0 hours in this example.
# Generally needed modules:
module load slurm
module load singularity

#Used to be source instead of sh
# Execute the program:
singularity exec --nv -B /bsuscratch/alphafold_data,/bsuhome/lwarner/alphafold_output alphafold.sif bash alphascript

## Some examples:
# mpirun vasp_std
# mpirun lmp_cpu -v x 32 -v y 32 -v z 32 -v t 100 < in.lj
# mpirun python3 script.py

# Exit if mpirun errored:
status=$?
if [ $status -ne 0 ]; then
    exit $status
fi

# Do some post processing.
