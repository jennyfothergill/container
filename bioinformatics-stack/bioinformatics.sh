#!/bin/bash
cmd=$(basename "$0")
args="$@"
singularity exec ${bioinformatics} $cmd $args
