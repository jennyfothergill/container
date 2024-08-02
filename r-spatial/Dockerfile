FROM ubuntu:22.04
MAINTAINER Kyle Shannon <kyle@pobox.com>

RUN apt update -qq
RUN apt install -y wget
RUN apt install -y --no-install-recommends software-properties-common dirmngr
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

RUN DEBIAN_FRONTEND=NONINTERACTIVE apt update -y -qq
RUN DEBIAN_FRONTEND=NONINTERACTIVE apt upgrade -y -qq
RUN DEBIAN_FRONTEND=NONINTERACTIVE apt install --no-install-recommends -y r-base
RUN DEBIAN_FRONTEND=NONINTERACTIVE apt install -y -qq \
  build-essential \
  curl \
  gdal-bin \
  gdebi-core \
  git \
  gpg \
  gpg-agent \
  libfontconfig1-dev \
  libgdal-dev \
  libgeos-dev \
  libproj-dev \
  libudunits2-dev \
  vim

#RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable
RUN add-apt-repository ppa:ubuntugis/ppa
RUN add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+

# 2023
RUN curl -LO https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.06.1-524-amd64.deb
RUN gdebi --n rstudio-server-2023.06.1-524-amd64.deb

# 2024
#RUN curl -LO https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.04.2-764-amd64.deb
#RUN gdebi --n rstudio-server-2024.04.2-764-amd64.deb

# install the r packages via apt instead of install.packages from the posit ppa
RUN apt install -y \
  r-cran-caret \
  r-cran-gitcreds \
  r-cran-googledrive \
  r-cran-knitr \
  r-cran-lubridate \
  r-cran-markdown \
  r-cran-maps \
  r-cran-mgcv \
  r-cran-nlme \
  r-cran-rcolorbrewer \
  r-cran-readxl \
  r-cran-reprex \
  r-cran-scales \
  r-cran-sf \
  r-cran-terra \
  r-cran-tidyverse \
  r-cran-tmap \
  r-cran-units \
  r-cran-usethis \
  r-cran-viridislite

# install non-apt libraries
# r-cran-tidycensus
RUN Rscript -e "install.packages('tidycensus');"
# r-cran-quarto
RUN Rscript -e "install.packages('quarto');"

# edit/run tclsh pword.tcl to generate encrypted passwords for users
RUN useradd -l -m -s /bin/bash -N -u 1001 carolyn -p '$6$l1lt$ssNW7MVlQxySLOWYhfvseiz6qe14.Jhri2efIEPFu8lOID3gsIFmskP8aj.9xcbY9zVt5W2Izq0ytRLGTXUb60'
RUN useradd -l -m -s /bin/bash -N -u 1002 kyle -p '$6$NXtr$UVx8AQatSxSzXp9n0JDMME4.gWbLRy6ozu1KLxzwn74dHo1gw40eBN5PZL1Y9v3s61HtA3c6qy2vKaXLUjkUx0'
RUN useradd -l -m -s /bin/bash -N -u 1003 matt -p '$6$NCTL$eBdx3BwdQO2M5DNeE3uFDY6Pe/uesZPobE7V3Es5MueDZsHGDYoQsJs4lBS5tI3nMhwLlgTMkHqO79T6RogkJ1'

EXPOSE 8787

CMD /usr/lib/rstudio-server/bin/rserver --www-port 8787 --server-daemonize=0
