GIT_REV = $(shell git rev-parse --short=16 HEAD)
all: sandbox container.sif
sandbox: container.def
	sudo rm -rf /tmp/sandbox; apptainer build --ignore-subuid --sandbox --build-arg GIT_REV=$(GIT_REV) /tmp/sandbox container.def

container.sif: /tmp/sandbox
	apptainer build -F container.sif /tmp/sandbox

.PHONY: clean
clean:
	rm -f *container.sif
