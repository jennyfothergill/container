GIT_REV = $(shell git rev-parse --short=16 HEAD)
sagedale.sif: apptainer guix.out
	apptainer build -F --fakeroot --build-arg GIT_REV=$(GIT_REV) --build-arg GUIX_SQUASHFS=$$(tail -1 guix.out) sagedale.sif apptainer

guix.out: channels.scm manifest.scm
	guix time-machine -C channels.scm -- pack -f squashfs -m manifest.scm | tee guix.out

.PHONY: clean
clean:
	rm -f *.sif
	rm -f guix.out
