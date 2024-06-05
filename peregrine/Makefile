DATE    = $(shell date --utc "+%Y%m%dT%H%M%S")
GIT_REV = $(shell git rev-parse --short=16 HEAD)

peregrine.sif: peregrine.def guix.out
	apptainer build -F --fakeroot --build-arg GIT_REV=$(GIT_REV) --build-arg GUIX_SQUASHFS=$$(cat guix.out) peregrine.sif peregrine.def

guix.out: channels.scm manifest.scm
	guix time-machine -C channels.scm -- pack -f squashfs -m manifest.scm > guix.out

.PHONY: dist
dist: peregrine.sif gitdiff
	cp peregrine.sif peregrine-$(DATE).sif

.PHONY: gitdiff
gitdiff:
	git diff --quiet

.PHONY: clean
clean:
	rm -f peregrine.sif
	rm -f guix.out
