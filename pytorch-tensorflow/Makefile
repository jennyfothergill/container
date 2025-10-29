GIT_REV = $(shell git rev-parse --short=16 HEAD)
pytorch_tensorflow.sif: pytorch_tensorflow.def
	apptainer build -F --fakeroot --build-arg GIT_REV=$(GIT_REV) pytorch_tensorflow.sif pytorch_tensorflow.def

.PHONY: clean
clean:
	rm -f *.sif
