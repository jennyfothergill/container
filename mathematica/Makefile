GIT_REV = $(shell git rev-parse --short=16 HEAD)
container.sif: container.def
	apptainer build --fakeroot --ignore-subuid -F --build-arg GIT_REV=$(GIT_REV) container.sif container.def

container2.sif: container2.def
	apptainer build --fakeroot --ignore-subuid -F --build-arg GIT_REV=$(GIT_REV) container2.sif container2.def

.PHONY: clean
clean:
	rm -f *container.sif
