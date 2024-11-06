GIT_REV = $(shell git rev-parse --short=16 HEAD)
r-mollyastell.sif: r-mollyastell.def r-mollyastell-guix.out
	apptainer build -F --fakeroot --build-arg GIT_REV=$(GIT_REV) --build-arg GUIX_SQUASHFS=$$(tail -1 r-mollyastell-guix.out) r-mollyastell.sif r-mollyastell.def

r-mollyastell-guix.out: channels.scm manifest.scm
	guix time-machine -C channels.scm -- pack -f squashfs -m manifest.scm | tee r-mollyastell-guix.out

.PHONY: clean
clean:
	rm -f *.sif
	rm -f r-mollyastell-guix.out
