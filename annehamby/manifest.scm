(specifications->manifest (list
                            ;; base packages
                            "bash-minimal"
                            "glibc-locales"
                            "nss-certs"
                            ;; Common command line tools lest the container is too empty.
                            "coreutils"
                            "grep"
                            "which"
                            "wget"
                            "sed"
                            ;; Toolchain and common libraries for "install.packages"
                            "gcc-toolchain@10"
                            "gfortran-toolchain"
                            "cmake"
                            "git"
                            "make"
                            ;; Go
                            "go"
                            ;; R packages
                            "r-minimal"
                            "r-tidyverse"
                          ))
