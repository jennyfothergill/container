#!/bin/bash
cmd=$(basename "$0")
args="$@"
singularity exec ${bioinformatics} singularity exec /opt/conda/bin/python /opt/HybPiper/get_seq_lengths.py $args
