#!/bin/bash
cmd=$(basename "$0")
args="$@"
singularity exec ${ech2o_sif} $cmd $args
