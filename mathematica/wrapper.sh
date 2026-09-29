#!/bin/bash
cmd=$(basename "$0")
args="$@"
/usr/local/Wolfram/Mathematica/14.0/Executables/$cmd -pwfile /opt/mathpass $args
