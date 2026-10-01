GIT_REV = $(shell git rev-parse --short=16 HEAD)
r-4.6.0.sif: r-4.6.0.def guix.out
	apptainer build -F --build-arg GIT_REV=$(GIT_REV) --build-arg GUIX_SQUASHFS=$$(tail -1 guix.out) --ignore-fakeroot-command r-4.6.0.sif r-4.6.0.def

guix.out: channels.scm manifest.scm
	guix time-machine -C channels.scm -- pack -f squashfs -m manifest.scm | tee guix.out

.PHONY: clean
clean:
	rm -f r-4.6.0.sif
	rm -f guix.out
