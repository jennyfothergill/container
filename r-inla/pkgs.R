pkgs <- c(
  'automap',
  'blockCV',
  'tidyverse',
  'plotly',
  'palettetown',
  'dismo',
  'cowplot',
  'reshape2',
  'inlabru'
)

#install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable"), Ncpus=24, dep=TRUE)
remotes::install_version("INLA", version = "22.05.07", repos = c(getOption("repos"), INLA = "https://inla.r-inla-download.org/R/testing"), Ncpus=8, dep = TRUE)
install.packages(pkgs, Ncpus=8, dep=TRUE)
devtools::install_github("timcdlucas/INLAutils", dependencies=FALSE)
