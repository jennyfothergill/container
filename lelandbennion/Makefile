GIT_REV = $(shell git rev-parse --short=16 HEAD)
CONTAINER = lelandbennion
GITHUB_PAT=$(shell tail -1 pat.txt)

$(CONTAINER).sif: $(CONTAINER).def guix.out
	apptainer build -F --fakeroot \
		--build-arg GIT_REV=$(GIT_REV) \
		--build-arg GITHUB_PAT=$(GITHUB_PAT) \
		--build-arg GUIX_SQUASHFS=$$(tail -1 guix.out) \
		$(CONTAINER).sif \
		$(CONTAINER).def

guix.out: channels.scm manifest.scm
	guix time-machine -C channels.scm -- pack -f squashfs -m manifest.scm | tee guix.out

.PHONY: clean
clean:
	rm -f $(CONTAINER).sif
	rm -f guix.out
