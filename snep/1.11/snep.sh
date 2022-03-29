#!/bin/bash
cmd=$(basename "$0")
args="$@"
singularity exec ${snepcontainer} $cmd $args
