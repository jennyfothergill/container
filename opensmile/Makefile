GIT_REV = $(shell git rev-parse --short=16 HEAD)
opensmile.sif: apptainer guix.out
	apptainer build -F --fakeroot --build-arg GIT_REV=$(GIT_REV) --build-arg GUIX_SQUASHFS=$$(tail -1 guix.out) opensmile.sif apptainer

guix.out: channels.scm manifest.scm
	guix time-machine -C channels.scm -- pack -f squashfs -m manifest.scm | tee guix.out

.PHONY: test
test: opensmile.sif
	./opensmile.sif -h 2> /dev/null

.PHONY: clean
clean:
	rm -f *.sif
	rm -f guix.out
