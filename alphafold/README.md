# Alphafold container
Singularity Container for Boise State University Research Computing

Built from instructions here:
 https://github.com/kalininalab/alphafold_non_docker

Make these symbolic links to the wrapper script in /cm/shared/apps/alphafold/bin
```
alphafold.sh
run_alphafold.py -> alphafold.sh
run_alphafold.sh -> alphafold.sh
run_alphafold_test.py -> alphafold.sh

```
The wrapper script, alphafold.sh, sets up the working directory and allows for a simpler command line.

Database lives on /bsuscratch/alphafold_data and new users will need to be added to alphafold group in cmsh. New users will also need an alphafold_output directory created in their scratch space. This can be accomplished with the alphafold_user_setup.sh script.


The modulefile loads Singularity prereq, sets the PATH and sets the sif file as ${alphafold} for easier launching of container.
## sample modulefile

```
#%Module -*- tcl -*-
##
## dot modulefile
##
proc ModulesHelp { } {
  puts stderr "\tAdds Alphafold built with singularity to your environment."
}

module-whatis "Adds Alphafold to your environment"

module  load    singularity
set              root              /cm/shared/apps/alphafold
prepend-path     PATH              $root/bin
setenv          alphafold          /cm/shared/apps/singularity/containers/alphafold.sif
setenv          SINGULARITY_BINDPATH /cm/shared,/bsuscratch

```
Things to check in the future:
https://hprc.tamu.edu/wiki/SW:AlphaFold
https://hpc.nih.gov/apps/alphafold2.html
