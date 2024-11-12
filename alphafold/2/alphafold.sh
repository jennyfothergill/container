#!/bin/bash
cmd=/opt/alphafold/$(basename "$0")
args="$@"
singularity exec --nv ${alphafold} $cmd $args
