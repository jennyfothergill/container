GIT_REV = $(shell git rev-parse --short=16 HEAD)
sandbox: container.def
	apptainer build -F --sandbox --fix-perms --build-arg GIT_REV=$(GIT_REV) /tmp/sandbox container.def

.PHONY: clean
clean:
	rm -f *container.sif
