# Bioinformatics stack
Quick notes on how to access each of the programs in this container along with what version is installed

UPDATED 2022-11-18

Build container
```
apptainer build --fakeroot bioinformatics.sif bioinformatics.def
```

ASTRAL 5.7.8
```
apptainer run bioinformatics.sif astral -i test_files/song_primates.424.gene.tre 
```

BBMap 39.01
```
apptainer exec bioinformatics.sif bbmap.sh
```

BCFtools 1.16
```
apptainer exec bioinformatics.sif bcftools --help
```

BEAST 2.6.6
```
apptainer exec bioinformatics.sif beast test_files/testCalibration.xml
```

Biopython 1.79
```
apptainer exec bioinformatics.sif python -c "import Bio"
```

BMGE 1.12
```
apptainer exec bioinformatics.sif bmge -?
```

BPP 4.4.1
```
apptainer exec bioinformatics.sif bpp --help
```

bwa 0.7.17
```
apptainer exec bioinformatics.sif bwa
```

exonerate 2.2.0
```
apptainer exec bioinformatics.sif exonerate -h
```

FastTree 2.1.11 SSE3
```
apptainer exec bioinformatics.sif FastTree
```

GetOrganelle 1.7.5.3
```
apptainer exec bioinformatics.sif get_organelle_from_reads.py -h
```

GNU parallel 20211222
```
apptainer exec bioinformatics.sif parallel -h
```

HybPiper 1.3.1
```
apptainer exec bioinformatics.sif reads_first.py --check-depend
```

iBPP 2.1.3
```
apptainer exec bioinformatics.sif ibpp test_files/5s.analysis.ctl 
```

iqtree 1.6.12
```
apptainer exec bioinformatics.sif iqtree -h
```

mafft 7.490-1
```
apptainer exec bioinformatics.sif mafft
```

pal2nal v14
```
apptainer exec bioinformatics.sif pal2nal.pl -h
```

raxml 8.2.12
```
apptainer exec bioinformatics.sif raxmlHPC -h
```

samtools 1.10
```
apptainer exec bioinformatics.sif samtools
```

TreeShrink 1.3.9
```
apptainer exec bioinformatics.sif run_treeshrink -h
```

TrimAl 1.4.1
```
apptainer exec bioinformatics.sif trimal -h
```
