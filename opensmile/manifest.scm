(specifications->manifest (list
                            ;; base packages
                            "bash-minimal"
                            "glibc-locales"
                            "nss-certs"
                            ;; Common command line tools lest the container is too empty.
                            "coreutils"
                            "curl"
                            "grep"
                            "which"
                            "sed"
                            ;; Toolchain and common libraries
                            "cmake"
                            "gawk"
                            "gcc-toolchain@13"
                            "git"
                            "gzip"
                            "make"
                            "pkg-config"
                            "tar"
                            "unzip"
                            "zip"
                            "zlib"
                          ))
