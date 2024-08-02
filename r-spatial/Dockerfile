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

RUN apt install -y caret
RUN apt install -y r-cran-gitcreds
RUN apt install -y r-cran-googledrive
RUN apt install -y r-cran-knitr
RUN apt install -y r-cran-lubridate
RUN apt install -y r-cran-markdown
RUN apt install -y r-cran-maps
RUN apt install -y r-cran-mgcv
RUN apt install -y r-cran-nlme
RUN apt install -y r-cran-quarto
RUN apt install -y r-cran-RColorBrewer
RUN apt install -y r-cran-readxl
RUN apt install -y r-cran-reprex
RUN apt install -y r-cran-scales
RUN apt install -y r-cran-sf
RUN apt install -y r-cran-terra
RUN apt install -y r-cran-tidycensus
RUN apt install -y r-cran-tidyverse
RUN apt install -y r-cran-tmap
RUN apt install -y r-cran-units
RUN apt install -y r-cran-usethis
RUN apt install -y r-cran-viridisLite

# edit/run tclsh pword.tcl to generate encrypted passwords for users
RUN useradd -l -m -s /bin/bash -N -u 1001 sabrina -p '$6$oq7l$vO47iZXy19GKbGWK2VyslTLiRFyHnZVKoc06BjY3wiQWpUdZKOnK844ZYd7Z7Y8l/DHJJ8EZjRIFpr/VJLRm6.'
RUN useradd -l -m -s /bin/bash -N -u 1002 molly -p '$6$/+ZV$qe9Ze.mGXfbVNwvSupuW9WXqhPYMqECD7nBcWDw0ZuuCZ2JmsYe54C4jOjQy25Gkc.0KTFfyDqdP6aviY69Gq/'
RUN useradd -l -m -s /bin/bash -N -u 1003 matthew -p '$6$W82V$o0W80GkCl4ikt2lHI8z5.E2VtP5tYKZU0VCYuoej3QsmbWTt.wxSs42L/AGG4Hko0qGHC9DZiaS3mqeQA8jAC1'
RUN useradd -l -m -s /bin/bash -N -u 1004 yas -p '$6$BaxU$WoXMqSdDKSbSq7VUl9KcEYFOyIp1SSmFdrt9fvG.BKgWnGP9q0VWEZihrJpvBMlqmvdad1SY3J4eEHg6i/gh2/'
RUN useradd -l -m -s /bin/bash -N -u 1005 brittanie -p '$6$WJXb$AreRLcVh6JbAW0ya5jVKti9f4eH3/YB5O74b/uybzqNk90t0qUaWTmr1QiSr3nbWsAml6.kyJKF6rBH0Ec0su.'
RUN useradd -l -m -s /bin/bash -N -u 1006 kathleen -p '$6$1MGq$3RLlNlbr09kGmAVEh1FzyWNOSaCwamFrsxpsHlhEvyBDrA22I30setcVQBNAJOcvKEg5xrdLWS/71UMp6vDBs1'
RUN useradd -l -m -s /bin/bash -N -u 1007 prithila -p '$6$FYf1$iWjmf7AOij7Z/nDnujLOfDUu.FKn0TFUS6Fe3BL55xydo1Az6qGln/bh50zfDimQnJHPVAih5Loux1S3lW680/'
RUN useradd -l -m -s /bin/bash -N -u 1008 ashley -p '$6$/ds4$ErTp2cH9Z3BujgD2ILC9xT4ACPfCRMq29f13ck5Gh6BiHODClCL7zHflWKZS1xRCAvy7YEdhnt0wB6Au2fH3b1'
RUN useradd -l -m -s /bin/bash -N -u 1009 amanda -p '$6$wNb5$z4uZf4IQbPIJSEoR8QF9eu2CI2WpK1ShykgeP8uwQbAfU1srrJ/QAjeQZ5ch4eRJTKWJtxVX5fU6F25.I8Der1'
RUN useradd -l -m -s /bin/bash -N -u 1010 ben -p '$6$Dx6Q$NHxDHbD5k11vj./G5UgBKAgI28bkCwm7NKuHPNhwYMrZdrQOXeIz7miczv90aGAV/iXAZ1c/fmTujLuR9mLyB/'
RUN useradd -l -m -s /bin/bash -N -u 1011 ryan -p '$6$MvIA$Sj41aVyXXAyUXiWnJHwBjXgup4DELXF/mTppI3fx3ZmhQGgOgcOzqutr.QI.vZn9R49cO8bBrFvgPvLljvjn1.'
RUN useradd -l -m -s /bin/bash -N -u 1012 kyle -p '$6$vSU5$tGNco5WIn.N/YGi8zOOfgEhy5SdkpuAkgxxguFflrBlF4z/SjLTyzHUeYlrhYbL3QVKBVD7/497EJWi.R8hyB.'
RUN useradd -l -m -s /bin/bash -N -u 1013 matt -p '$6$XUns$UH6bjU4kqs/KsVXDuZSR5i/AnB6K0.2KvIR7bH1ZXflJAm4s3/Mc2bIcJ2/pI2RkTfrSZGfKmvJA77ZnsWh3o.'

EXPOSE 8787

CMD /usr/lib/rstudio-server/bin/rserver --www-port 8787 --server-daemonize=0
