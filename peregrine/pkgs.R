#options(repos="https://ftp.osuosl.org/pub/cran/")
#options(repos="http://cran.us.r-project.org")
options(repos="https://cloud.r-project.org")

installp <- function(pkgs) {
  for (p in pkgs) {
    install.packages(p, dependencies=TRUE, Ncpus=8);
    if (!library(p, character.only=TRUE, logical.return=TRUE)) {
      quit(status=1, save='no')
    }
  }
}

# no packages
#installp('rgdal', 'rgeos', 'spatialEco', 'glmmTMB', 'R2OpenBUGS', 'jagsUI', 'rjags', 'R2jags', 'rstanarm', 'ENMeval')

# skipping rgdal, rgeos, spatialEco, ENMeval, and possibly R2OpenBUGS

# need glmmTMB, jagsUI, rjags, R2jags

# rstanarm and glmmTMB (maybe) runs out of memory on my mini builder (8GB RAM), so build on workstation

pkgs <- c(
	'raster',
	'sf',
	'sp',
	'RPyGeo',
	'cartography',
	'geosphere',
	'dplyr',
	'devtools',
	'jpeg',
	'units',
	'lme4',
	'MuMIn',
	'nimble',
	'reshape2',
	'tidyr',
	'fields',
	'unmarked',
	'maxnet',
	'spThin',
	'lubridate',
	'landscapemetrics',
	'data.table',
	'brms',
	'mgcv',
	'inlabru',
	'ggplot2',
	'viridis',
	'cowplot',
	'grid',
	'gridExtra',
	'infotheo',
	'arules',
	'snow',
	'geosphere',
	'groupdata2',
	'exactextractr',
	'nlme',
	'censusapi',
	'gratia',
	'RcppArmadillo',
	'nloptr',
	'lwgeom',
	'rjags',
	'jagsUI',
	'R2jags',
	'glmmTMB')

installp(pkgs)

installp(c('rstanarm'))

install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)
library(INLA)
