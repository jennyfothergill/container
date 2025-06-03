GIT_REV = $(shell git rev-parse --short=16 HEAD)
r-ashleysantiago.sif: r-ashleysantiago.def r-ashleysantiago-guix.out
	apptainer build -F --fakeroot --build-arg GIT_REV=$(GIT_REV) --build-arg GUIX_SQUASHFS=$$(tail -1 r-ashleysantiago-guix.out) r-ashleysantiago.sif r-ashleysantiago.def

r-ashleysantiago-guix.out: channels.scm manifest.scm
	guix time-machine -C channels.scm -- pack -f squashfs -m manifest.scm | tee r-ashleysantiago-guix.out

.PHONY: clean
clean:
	rm -f *.sif
	rm -f r-ashleysantiago-guix.out
