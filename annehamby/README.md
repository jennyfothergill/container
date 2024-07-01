# OpenSMILE Workflow

## Software

The software required is available as a module on Borah, or as a container from
the Boise State [container](https://github.com/bsurc/container) repository.  R
and the required dependencies are bundled with OpenSMILE 3.0.2.  The container
is the preferred method, and is fully selfcontained.

## Borah

On borah, there are three steps to running the program.  There is a built in
default method using the `--app` functionality of apptainer.  After any sort of
update to the container, the first step is to unpack the sbatch scripts:

    module load apptainer/1.2.5
    apptainer run --app=unpack annehamby.sif

This unpacks two sbatch scripts with defaults set to the appropriate
input/output for borah.

The next step is to submit the smile batch job:

    sbatch smile.batch --array=1-81

This will run all the analyses in chunks of 480 wav files.  Output will be
written to `/bsushare/annehamby-share/oskoutput`.

To check and make sure all the output was written, run:

    apptainer run --app=check

And finally, to run the summary statistics, run:

    sbatch pause.batch

This should write the file speech\_variables.csv to the current directory.

## Running

To run the entire analysis, the following commands need to be run:

0. module load apptainer
0. apptainer run --app=unpack annehamby.sif
0. sbatch --array=1-81 smile.batch
0. apptainer run --app=check annehamby.sif
0. sbatch pause.batch

## `smile.go`

The binary stored in the container at `/usr/local/bin/smile` is a go program
that runs batches of `SMILExtract`.  It reads `SLURM_ARRAY_TASK_ID`, and runs a
the analysis on a group of wav files.  For example, if it is invoked with:

    sbatch --array=1 smile.batch -batch=480

will run the wav files for indices 0-479 inclusive from a sorted list of
directories in the input file directory.

smile takes the following options:

    smile -help
    Usage of smile:
      -batch int
            number of analyses to do per task (default 480)
      -check
            check input vs output, requires argc==2
      -config string
            OpenSMILE config file (default "prosodyAcf.conf")
      -jobs int
            concurrent jobs
      -n    dry run
      -output string
            output folder (default "/bsushare/annehamby-shared/oskoutput")
      -version
            show version and exit
      -wavs string
            wav folder (default "/bsushare/annehamby-shared/oskwavs")

