GIT_REV = $(shell git rev-parse --short=16 HEAD)
peregrine-guix.sif: peregrine-guix.def peregrine-guix.out
	apptainer build -F --fakeroot --build-arg GIT_REV=$(GIT_REV) --build-arg GUIX_SQUASHFS=$$(tail -1 peregrine-guix.out) peregrine-guix.sif peregrine-guix.def

peregrine-guix.out: channels.scm manifest.scm
	guix time-machine -C channels.scm -- pack -f squashfs -m manifest.scm | tee peregrine-guix.out

.PHONY: clean
clean:
	rm -f *.sif
	rm -f peregrine-guix.out
