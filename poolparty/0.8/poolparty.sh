#!/bin/bash
cmd=$(basename "$0")
args="$@"
singularity exec ${poolparty} $cmd $args
