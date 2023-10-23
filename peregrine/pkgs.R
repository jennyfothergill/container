#options(repos="https://ftp.osuosl.org/pub/cran/")
#options(repos="http://cran.us.r-project.org")
options(repos="https://cloud.r-project.org")

# function to error out if the package fails to install
installp <- function(pkgs) {
  for (p in pkgs) {
    install.packages(p, dependencies=TRUE, Ncpus=8);
    if (!library(p, character.only=TRUE, logical.return=TRUE)) {
      quit(status=1, save='no')
    }
  }
}

# rgdal and rgeos have been removed from cran
# ENMeval fails to install due to dependency issues:
# ERROR: dependency 'BIEN' is not available for package 'rangeModelMetadata'
# * removing '/opt/R/4.3.1/lib/R/library/rangeModelMetadata'
# ERROR: dependency 'rangeModelMetadata' is not available for package 'ENMeval'
# * removing '/opt/R/4.3.1/lib/R/library/ENMeval'
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
	'glmmTMB',
	'terra',
	'rstan',
	'rstanarm',
	'PointedSDMs',
	'nimbleHMC',
	'spOccupancy',
	'loo',
	'ENMeval')

installp(pkgs)

install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)
library(INLA)
