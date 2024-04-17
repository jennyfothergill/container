# Container
Singularity container definition files for Boise State University Research Computing

## Notes on specific distributions and applications

### Alpine

#### Building from scratch

An Alpine image can be quickly build from scratch by downloading the
`minirootfs` tarballs in the `%setup` section.  For example, to build from
Alpine 3.19.0 on x86\_64:

    %setup
    curl -LO https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz
    curl -LO https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz.sha512
    sha512sum -c alpine-minirootfs-3.19.0-x86_64.tar.gz.sha512
    tar -C ${APPTAINER_ROOTFS} -xf alpine-minirootfs-3.19.0-x86_64.tar.gz

#### Using Alpine edge and community repositories

To change the alpine repostories to use the bleeding edge packages, swap the
`$MAJOR.$MINOR` version to `edge`:

    sed -i 's/v3.19/edge/g' /etc/apk/repositories

To add the testing repository to `apk` after switching to `edge`:

    tail -n 1 /etc/apk/repositories | sed 's/community/testing/' >> /etc/apk/repositories

### R

R packages can be difficult to build, especially with dependencies on various
systems.  Posit (creators of RStudio) have ppa repositories to help with some of
these dependencies, and handles them especially well in conjuction with RStudio
server.  See the `r-spatial` build for an example.

Another option that appears to work well is using `guix` to create a squashfs
image directly.  There is an HPC/cran channel for guix that mirrors R packages.
See the `peregrine` build for an example.

#### Issues on Alpine

If you are getting `iconv` translation errors, set `LC_ALL=en_US.UTF-8`.

Other `pkgconfig` and text related issues _may_ be solved by installing common
text libraries:

    apk add \
        fontconfig-dev \
        freetype-dev f\
        ribidi-dev \
        gnu-libiconv-dev \
        harfbuzz-dev

Also, the `linux-headers` package is frequently needed for packages:

    apk add linux-headers
