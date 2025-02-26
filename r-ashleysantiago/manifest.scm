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
                            "gawk"
                            "tar"
                            "gzip"
                            "unzip"
                            "make"
                            "cmake"
                            "pkg-config"
                            "cairo"
                            "libxt"
                            "openssl"
                            "curl"
                            "zlib"
                            ;; jags
                            ;; "jags"
                            ;; r stuff
                            "r"
                            "r-tidyr"
                            "r-jagsui"
                            "r-dplyr"
                          ))
