# Bioinformatics stack

Build container
```
singularity build --fakeroot bioinformatics.sif bioinformatics.def
```

ASTRAL 5.7.8
```
singularity run bioinformatics.sif astral -i test_files/song_primates.424.gene.tre 
```

BEAST
```
singularity exec bioinformatics.sif beast test_files/testCalibration.xml
```

Biopython
```
singularity exec bioinformatics.sif python -c "import Bio"
```

BMGE
```
singularity exec bioinformatics.sif bmge -?
```

BPP
```
singularity exec bioinformatics.sif bpp --help
```

bwa
```
singularity exec bioinformatics.sif bwa
```

exonerate
```
singularity exec bioinformatics.sif exonerate -h
```

FastTree
```
singularity exec bioinformatics.sif FastTree
```

GetOrganelle
```
singularity exec bioinformatics.sif get_organelle_from_reads.py -h
```

GNU parallel
```
singularity exec bioinformatics.sif parallel -h
```

HybPiper
```
singularity exec bioinformatics.sif reads_first.py --check-depend
```

iBPP
```
singularity exec bioinformatics.sif ibpp test_files/5s.analysis.ctl 
```

iqtree
```
singularity exec bioinformatics.sif iqtree -h
```

mafft
```
singularity exec bioinformatics.sif mafft
```

pal2nal
```
singularity exec bioinformatics.sif pal2nal.pl -h
```

samtools
```
singularity exec bioinformatics.sif samtools
```

TreeShrink
```
singularity exec bioinformatics.sif python -c "import treeshrink"
```

TrimAl
```
singularity exec bioinformatics.sif trimal -h
```
