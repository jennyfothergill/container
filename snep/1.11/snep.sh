#!/bin/bash
cmd=$(basename "$0")
args="$@"
singularity exec ${snep} $cmd $args
