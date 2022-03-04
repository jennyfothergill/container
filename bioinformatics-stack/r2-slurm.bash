#!/bin/bash

#SBATCH -J bioinformatics    # job name
#SBATCH -o log_slurm.o%j     # output and error file name (%j expands to jobID)
#SBATCH -N 1		     # number of nodes requested
#SBATCH -n 28                # total number of cpus requested. 28 per node.
#SBATCH -p defq              # queue (partition) -- defq, ipowerq, eduq, gpuq.
#SBATCH -t 72:00:00          # run time (hh:mm:ss) - 72.0 hours in this example.


# Load the necessary modules
module purge
module load slurm singularity


