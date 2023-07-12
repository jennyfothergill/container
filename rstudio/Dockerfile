FROM ubuntu:22.04
MAINTAINER Kyle Shannon <kyle@pobox.com>

RUN apt update -qq
RUN apt install -y wget
RUN apt install -y --no-install-recommends software-properties-common dirmngr
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

RUN DEBIAN_FRONTEND=NONINTERACTIVE apt upgrade -y -qq
RUN DEBIAN_FRONTEND=NONINTERACTIVE apt install --no-install-recommends -y r-base
RUN DEBIAN_FRONTEND=NONINTERACTIVE apt install -y -qq \
  curl \
  gdebi-core \
  git \
  gpg \
  gpg-agent \
  libfontconfig1-dev \
  libgdal-dev \
  libproj-dev \
  libudunits2-dev \
  vim

RUN add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+

RUN curl -LO https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.06.1-524-amd64.deb
RUN gdebi --n rstudio-server-2023.06.1-524-amd64.deb


# install the r packages via apt instead of install.packages from the posit ppa
RUN apt install -y \
  r-cran-terra \
  r-cran-sf \
  r-cran-stars \
  r-cran-tmap \
  r-cran-tidyverse

# edit/run tclsh pword.tcl to generate encrypted passwords for users
RUN useradd -l -m -s /bin/bash -N -u 1001 buster -p '$6$dvJCQQ==$GZojCbORzx5zaM.uJM8OkqiEjncyPHjailTiuUkPFC5K2ZJGN2CE3Urk1ACu0sRKWsjGuRTwEvRx61qmZ2V./1'
RUN useradd -l -m -s /bin/bash -N -u 1002 kyle -p '$6$JbNdqg==$1dFPFSK2XNq1wZ9G9n4xxYNKGuJJeqLpsHXRiL4lGYnbNZQdfd6dmE/csoTyXfprbPzW0wAEHmrW/K3WmjjZ60'
RUN useradd -l -m -s /bin/bash -N -u 1003 matt -p '$6$QhLwLw==$yg0yLwgvuT7n.rO9tbHZ39mY1sxC47Vew63S6LyyLMkKdrahDbWynEMLSG5p2YdHOzqHsMEXtqsPBH5F6PJci1'

EXPOSE 8787

CMD /usr/lib/rstudio-server/bin/rserver --www-port 8787 --server-daemonize=0
