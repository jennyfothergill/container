#!/bin/bash

module purge 
module load bioinformatics

#export SIMG=bioinformatics.sif
#export SIMG=~/bioinformatics.sif
export SIMG=/cm/shared/apps/singularity/containers/bioinformatics.sif

# -- Add your scripts below here -- #
# I've gotten you started with some test calls to the programs you've requested

# ASTRAL 5.7.8
printf "Running Astral\n"
astral -i test_files/song_primates.424.gene.tre 
printf "\nFinished\n\n\n"

# BEAST 2.6.6
printf "Running BEAST\n"
beast test_files/testCalibration.xml
printf "\nFinished\n\n\n"

# mafft 7.490-1
printf "Running mafft\n"
mafft --localpair --maxiterate 1000 test_files/HSP90.fas > HSP90_mafft.fas
printf "\nFinished\n\n\n"

# TrimAl 1.4.1
printf "Running TrimAl\n"
trimal -in HSP90_mafft.fas -out HSP90_trimal.fas -fasta -automated1
printf "\nFinished\n\n\n"

# BMGE 1.12
printf "Running BMGE\n"
bmge -i HSP90_mafft.fas -of HSP90_bmge.fas -t AA
printf "\nFinished\n\n\n"

# BPP 4.4.1
printf "Running BPP\n"
bpp --cfile test_files/bpp.ctl
printf "\nFinished\n\n\n"

# bwa 0.7.17
printf "Running bwa\n"
bwa index test_files/HSP90.fas
printf "\nFinished\n\n\n"

# exonerate 2.2.0
printf "Running exonerate\n"
exonerate test_files/query.fasta test_files/target.fasta 
printf "\nFinished\n\n\n"

# FastTree 2.1.11 SSE3
printf "Running FastTree\n"
FastTree -gtr -nt test_files/16S.1.p > test.out
printf "\nFinished\n\n\n"

# GetOrganelle 1.7.5.3
printf "Running GetOrganelle\n"
get_organelle_from_reads.py -1 test_files/Arabidopsis_simulated.1.fq.gz -2 test_files/Arabidopsis_simulated.2.fq.gz -t 1 -o Arabidopsis_simulated.plastome -F embplant_pt -R 10
printf "\nFinished\n\n\n"

# HybPiper 1.3.1
printf "Running HybPiper\n"
reads_first.py -r test_files/EG30_R1_test.fastq -b test_files/test_targets.fasta --prefix EG30_R1 --bwa
printf "\nFinished\n\n\n"

# iBPP 2.1.3
printf "Running iBPP\n"
ibpp test_files/5s.analysis.ctl 
printf "\nFinished\n\n\n"

# iqtree 1.6.12
printf "Running iqtree\n"
iqtree -s test_files/example.phy
printf "\nFinished\n\n\n"

# pal2nal v14
printf "Running pal2nal\n"
pal2nal.pl test_files/test.aln test_files/test.nuc
printf "\nFinished\n\n\n"

# RAxML 8.2.12
printf "Running RAxML\n"
raxmlHPC -m GTRGAMMA -p 12345 -s test_files/example.phy -# 20 -n T6
printf "\nFinished\n\n\n"

# samtools 1.10
#samtools view -S -b test_files/sample.sam > sample.bam

# TreeShrink 1.3.9
printf "Running TreeShrink\n"
run_treeshrink.py -t test_files/mm10.trees
printf "\nFinished\n\n\n"

