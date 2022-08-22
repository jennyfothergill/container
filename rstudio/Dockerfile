FROM ubuntu:22.04
MAINTAINER Kyle Shannon <kyle@pobox.com>

RUN apt update

RUN apt install -y -qq --no-install-recommends software-properties-common
RUN apt-add-repository multiverse

RUN apt update

RUN DEBIAN_FRONTEND=NONINTERACTIVE apt upgrade -y -qq
RUN DEBIAN_FRONTEND=NONINTERACTIVE apt install -y -qq \
  curl \
  git \
  gdebi-core \
  libfontconfig1-dev \
  libgdal-dev \
  libproj-dev \
  libudunits2-dev \
  r-base \
  vim

#RUN curl -LO https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1717-amd64.deb
#RUN gdebi --n rstudio-server-1.4.1717-amd64.deb
RUN curl -LO https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2022.07.1-554-amd64.deb
RUN gdebi --n rstudio-server-2022.07.1-554-amd64.deb

# R packages we need
# rgdal ✓
# rgeos ✓
# raster ✓
# terra ✓
# stars ✓
# sp ✓
# spdep ✓
# mapview ✓ (says okay, bad download?)
# dismo ✓
# gdistance ✓
# igraph ✓
# rasterVis ✓
# microbenchmark ✓
#
# post start of class
# rmarkdown ✓
# tidyverse ✓
# usethis ✓
# gitcreds ✓

RUN R -e "install.packages('rgdal', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('rgeos', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('raster', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('terra', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('stars', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('sp', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('spdep', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('mapview', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('tmap', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('dismo', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('gdistance', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('igraph', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('rasterVis', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('microbenchmark', repo='http://cran.r-project.org', Ncpus=4)"

RUN R -e "install.packages('rmarkdown', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('tidyverse', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('usethis', repo='http://cran.r-project.org', Ncpus=4)"
RUN R -e "install.packages('gitcreds', repo='http://cran.r-project.org', Ncpus=4)"

RUN R -e "install.package('quarto', repo='http://cran.r-project.org', Ncpus=4)"

RUN useradd -l -m -s /bin/bash -N -u 1001 kyle
RUN useradd -l -m -s /bin/bash -N -u 1002 matt
RUN useradd -l -m -s /bin/bash -N -u 1003 buster
RUN useradd -l -m -s /bin/bash -N -u 1004 leticia
RUN useradd -l -m -s /bin/bash -N -u 1005 hannah
RUN useradd -l -m -s /bin/bash -N -u 1006 david
RUN useradd -l -m -s /bin/bash -N -u 1007 zoe
RUN useradd -l -m -s /bin/bash -N -u 1008 jessica
RUN useradd -l -m -s /bin/bash -N -u 1009 nora

EXPOSE 8787

CMD /usr/lib/rstudio-server/bin/rserver --www-port 8787 --server-daemonize=0
