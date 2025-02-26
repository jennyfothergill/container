VERSION = 2.7.7
GIT_REV = $(shell git rev-parse --short=16 HEAD)

beast_v$(VERSION)_$(GIT_REV).sif: beast.def
	apptainer build -F --fakeroot --build-arg GIT_REV=$(GIT_REV) \
		beast_v$(VERSION)_$(GIT_REV).sif beast.def

.PHONY: clean
clean:
	rm -f beast*.sif
