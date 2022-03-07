#!/bin/bash

#SBATCH -J poolparty     # job name
#SBATCH -o log_slurm.o%j  # output and error file name (%j expands to jobID)
#SBATCH -n 48             # total number of tasks requested
#SBATCH -N 1              # number of nodes you want to run on  
#SBATCH -p bsudfq      # queue (partition) -- eduq, gpuq, shortq
#SBATCH -t 1:00:00       # run time (hh:mm:ss) - 1.0 hour in this example.

module load poolparty

PPalign pp_align.config
PPstats pp_stats.config
PPanalyze pp_analyze.config


