#!/bin/bash
export SINGULARITY_BINDPATH="/cm/shared,/scratch"
dir=/cm/shared/apps/singularity/containers
cmd=$(basename "$0")
args="$@"
singularity exec $dir/poolparty.sif $cmd $args
