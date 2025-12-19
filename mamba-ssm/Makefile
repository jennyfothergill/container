GIT_REV = $(shell git rev-parse --short=16 HEAD)
container.sif: container.def
	apptainer build --nv -F --fakeroot --build-arg GIT_REV=$(GIT_REV) container.sif container.def

.PHONY: clean
clean:
	rm -f *.sif
