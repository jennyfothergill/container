#!/bin/bash

#SBATCH -J snep              # job name
#SBATCH -o log_slurm.o%j     # output and error file name (%j expands to jobID)
#SBATCH -N 1		     # number of nodes requested
#SBATCH -n 28                # total number of cpus requested. 28 per node.
#SBATCH -p bsudfq            # queue (partition) -- bsudfq, gpu, bigmem.
#SBATCH -t 72:00:00          # run time (hh:mm:ss) - 72.0 hours in this example.


# Load the necessary modules
module purge
module load slurm snep

# -- Add your scripts below here -- #

# SNeP v1.11
printf "Running SNeP\n"
snep -h
printf "\nFinished\n\n\n"

# NeEstimator
printf "Running NeEstimator\n"
printf "\nFinished\n\n\n"
