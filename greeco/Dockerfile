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
  git \
  gpg \
  gpg-agent \
  libfontconfig1-dev \
  vim

RUN add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+

# install the r packages via apt instead of install.packages from the posit ppa
RUN apt install -y r-cran-dt
RUN apt install -y r-cran-bslib
RUN apt install -y r-cran-shiny
RUN apt install -y r-cran-plotly
RUN apt install -y r-cran-tidyverse
RUN apt install -y r-cran-viridis

WORKDIR /opt
COPY greeco_shiny_app .

CMD ["R", "-e", "shiny::runApp('/opt', port=80, host='0.0.0.0', launch.browser=FALSE);"]
