GIT_REV = $(shell git rev-parse --short=16 HEAD)
comsol.sif: comsol.def
	apptainer build -F --build-arg GIT_REV=$(GIT_REV) comsol.sif comsol.def

.PHONY: clean
clean:
	rm -f *.sif
