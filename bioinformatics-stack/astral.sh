#!/bin/bash
cmd=$(basename "$0")
args="$@"
singularity run ${bioinformatics} $cmd $args
