GIT_REV = $(shell git rev-parse --short=16 HEAD)
rstudiodesktop.sif: rstudiodesktop.def guix.out
	apptainer build -F --fakeroot --build-arg GIT_REV=$(GIT_REV) --build-arg GUIX_SQUASHFS=$$(tail -1 guix.out) rstudiodesktop.sif rstudiodesktop.def

guix.out: channels.scm manifest.scm
	guix time-machine -C channels.scm -- pack -f squashfs -m manifest.scm | tee guix.out

.PHONY: clean
clean:
	rm -f rstudiodesktop.sif
	rm -f guix.out
