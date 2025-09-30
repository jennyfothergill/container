GIT_REV = $(shell git rev-parse --short=16 HEAD)
lichtfeld.sif: lichtfeld.def
	apptainer build -F --fakeroot --build-arg GIT_REV=$(GIT_REV) lichtfeld.sif lichtfeld.def

lichtfeld2.sif: lichtfeld2.def lichtfeld.sif
	apptainer build -F --fakeroot --build-arg GIT_REV=$(GIT_REV) lichtfeld2.sif lichtfeld2.def

.PHONY: clean
clean:
	rm -f *.sif
