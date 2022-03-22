#!/bin/bash

#SBATCH -J bioinformatics    # job name
#SBATCH -o log_slurm.o%j     # output and error file name (%j expands to jobID)
#SBATCH -N 1		     # number of nodes requested
#SBATCH -n 28                # total number of cpus requested. 28 per node.
#SBATCH -p defq              # queue (partition) -- defq, ipowerq, eduq, gpuq.
#SBATCH -t 72:00:00          # run time (hh:mm:ss) - 72.0 hours in this example.


# Load the necessary modules
module purge
module load slurm bioinformatics

export SIMG=/cm/shared/apps/singularity/containers/bioinformatics.sif

# -- Add your scripts below here -- #
# I've gotten you started with some test calls to the programs you've requested

# ASTRAL 5.7.8
astral -i test_files/song_primates.424.gene.tre 

# BEAST 2.6.6
beast test_files/testCalibration.xml

# mafft 7.490-1
mafft --localpair --maxiterate 1000 test_files/HSP90.fas > HSP90_mafft.fas

# TrimAl 1.4.1
trimal -in HSP90_mafft.fas -out HSP90_trimal.fas -fasta -automated1

# BMGE 1.12
bmge -i HSP90_mafft.fas -of HSP90_bmge.fas -t AA

# BPP 4.4.1
bpp --cfile test_files/bpp.ctl

# bwa 0.7.17
bwa index test_files/HSP90.fas

# exonerate 2.2.0
exonerate test_files/query.fasta test_files/target.fasta 

# FastTree 2.1.11 SSE3
FastTree -gtr -nt test_files/16S.1.p > test

# GetOrganelle 1.7.5.3
get_organelle_from_reads.py -1 test_files/Arabidopsis_simulated.1.fq.gz -2 test_files/Arabidopsis_simulated.2.fq.gz -t 1 -o Arabidopsis_simulated.plastome -F embplant_pt -R 10

# HybPiper 1.3.1
reads_first.py -r test_files/EG30_R1_test.fastq -b test_files/test_targets.fasta --prefix EG30_R1 --bwa

# iBPP 2.1.3
ibpp test_files/5s.analysis.ctl 

# iqtree 1.6.12
iqtree -s test_files/example.phy

# pal2nal v14
pal2nal.pl test_files/test.aln test_files/test.nuc

# RAxML 8.2.12
raxmlHPC -m GTRGAMMA -p 12345 -s test_files/example.phy -# 20 -n T6

# samtools 1.10
#singularity exec $SIMG samtools view -S -b test_files/sample.sam > sample.bam

# TreeShrink 1.3.9
run_treeshrink.py -t test_files/mm10.trees


