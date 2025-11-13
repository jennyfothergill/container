# Container
Container definition files for Boise State University Research Computing

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
        freetype-dev \
        fribidi-dev \
        gnu-libiconv-dev \
        harfbuzz-dev

Also, the `linux-headers` package is frequently needed for packages:

    apk add linux-headers

### GUIX

In order to use a `guix` based build, the user should test the environment using
`guix shell`, then dump the channel configuration to a `channels.scm` file
using:

  guix describe --format=channels > channels.scm

Then `guix time-machine` to build the environment/squashfs.  The full process
may look like:

    $ # optional
    $ guix pull
    $ guix shell bash go
    $ # test environment...
    $ guix shell --export-manifest shell bash go > manifest.scm
    $ # export the current channel definition
    $ guix describe --format=channels > channels.scm
    $ # test
    $ guix time-machine -C channels.scm -- shell -m manifest
    $ # build squashfs
    $ guix time-machine -C channels.scm -- pack -f squashfs -m manifest.scm

To build a container from the squashfs, simply use the squashfs as the source:

    appatiner build --fakeroot x.sif /gnu/store/${guixhash}.squashfs

For simple examples of adding metadata to the container, see
`peregrine/Makefile`
