GIT_REV = $(shell git rev-parse --short=16 HEAD)

alphafold_v3.0.0_$(GIT_REV).sif: alphafold.def
	apptainer build -F --fakeroot --build-arg GIT_REV=$(GIT_REV) \
		alphafold_v3.0.0_$(GIT_REV).sif alphafold.def

.PHONY: clean
clean:
	rm -f alphafold*.sif
