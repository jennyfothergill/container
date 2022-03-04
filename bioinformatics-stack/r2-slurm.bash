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

export SIMG=/cm/shared/apps/singularity/containers/bioinformatics.sif

# -- Add your scripts below here -- #
# I've gotten you started with some test calls to the programs you've requested

# ASTRAL 5.7.8
singularity run $SIMG astral -i test_files/song_primates.424.gene.tre 

# BEAST 2.6.6
singularity exec $SIMG beast test_files/testCalibration.xml

# BMGE 1.12
singularity exec $SIMG bmge -?

# BPP 4.4.1
singularity exec $SIMG bpp --help

# bwa 0.7.17
singularity exec $SIMG bwa

# exonerate 2.2.0
singularity exec $SIMG exonerate -h

# FastTree 2.1.11 SSE3
singularity exec $SIMG FastTree

# GetOrganelle 1.7.5.3
singularity exec $SIMG get_organelle_from_reads.py -h

# HybPiper 1.3.1
singularity exec $SIMG reads_first.py --check-depend

# iBPP 2.1.3
singularity exec $SIMG ibpp test_files/5s.analysis.ctl 

# iqtree 1.6.12
singularity exec $SIMG iqtree -h

# mafft 7.490-1
singularity exec $SIMG mafft

# pal2nal v14
singularity exec $SIMG pal2nal.pl -h

# RAxML 8.2.12
singularity exec $SIMG raxmlHPC -h

# samtools 1.10
singularity exec $SIMG samtools

# TreeShrink 1.3.9
singularity exec $SIMG run_treeshrink -h

# TrimAl 1.4.1
singularity exec $SIMG trimal -h

