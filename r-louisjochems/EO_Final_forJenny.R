require('INLA')
require('raster')
require('plotly')
require('lattice')
require('grid')
require('gridExtra')
require('raster')
require('plotly')
require('dplyr')
require('tidyr')
require('tidyverse')
require('sp')
require('rgdal')
require('devtools')
require('INLAutils')
require('inlabru')
require('sf')
require('scales')
require('tidyverse')
require('ggplot2')
require('RColorBrewer')
require('blockCV')
require('automap')

#setwd("~/R/EFBDrivers2011_2021")
setwd("/bsuhome/louisjochems/SDMRuns_2025/Full_All/")
efb_fine <- read.csv("FullVegData11_21_NearInvNEW.csv")

#filter out different coord qualities 
efb_exc <- efb_fine %>% filter(crd_q %in% c("Excellent"))

nrow(efb_exc[which(efb_exc$hyd_bin > 0),]) / nrow(efb_exc)
#only 7 %  of points are presence w excellent only  

#make into spdf
coordinates(efb_exc) <- ~UTM_X + UTM_Y
proj4string(efb_exc) <- "+proj=utm +zone=16 +datum=WGS84 +units=m +no_defs"

GLbuffer <- shapefile("Great_Lakes_Buffer.shp")
proj4string(GLbuffer) <- "+proj=longlat +datum=WGS84 +no_defs"
GL_utm <- spTransform(GLbuffer, CRS("+proj=utm +zone=16 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"))


####---determine range and create blocks----#### 
#make a spatialblock arrangement 
sb_pred <- spatialBlock(speciesData = efb_exc,
                        species = "hyd_bin",
                        theRange = 15201, #determined from ranges 
                        k = 5,
                        showBlocks = TRUE,
                        biomod2Format = TRUE)

#####----set up cv loop for inla------###### 
fine_folds <- sb_pred$foldID

efb_exc <- as.data.frame(efb_exc)
efb_exc <- efb_exc
efb_exc$folds <- fine_folds
write.csv(efb_exc,"Full_NewNI_Folds.csv")

######----mesh building----#### 
dis <- as.matrix(dist(coordinates(efb_exc[, c(44,45)])))
diag(dis) <- NA
dis2 <- dis[lower.tri(dis, diag = FALSE)] #returns lower triangle of matrix distance values 
range(dis2)
hist(dis2) 

#still same mesh for EO
cutoff <- 8.049944e-02
#build the mesh
mesh1 <- inla.mesh.2d(boundary = GL_utm,loc = efb_exc[c(44,45)],
                      cutoff = cutoff, max.edge = c(222000,888000),
                      crs = crs(GL_utm))
#plot(mesh1);points(efb_exc[c(44,45)])

## adding some priors for resolving posteriors of hyperparams 
sigma0 <- 1
size <- min(c(diff(range(mesh1$loc[, 1])), diff(range(mesh1$loc[, 2]))))
range0 <- size/5
kappa0 <- sqrt(8)/range0
tau0 <- 1/(sqrt(4 * pi) * kappa0 * sigma0)

#prior means from fair model hyperpars 
fair_hp <- get(load("/bsuhome/louisjochems/PC_Fixed/Full_DQother/FullFair_Reg.RData"))
#fair_hp <- get(load("~/R/EFBDrivers2011_2021/FairPlus_Models/FullFair_Reg.RData"))
logTau <- inla.emarginal(function(x) x, fair_hp$marginals.hyperpar$`Theta1 for s.index_mY`)
logKappa <- inla.emarginal(function(x) x, fair_hp$marginals.hyperpar$`Theta2 for s.index_mY`)

spde <- inla.spde2.matern(mesh1, B.tau = matrix(c(log(tau0), -1, +1), nrow = 1, ncol = 3),
                          B.kappa = matrix(c(log(kappa0), 0, -1), nrow = 1, ncol = 3), theta.prior.mean = c(logTau, logKappa),
                          theta.prior.prec = c(2,2))

s.index <- inla.spde.make.index("s.index_mY", n.spde = spde$n.spde)

efb_exc <- as.data.frame(efb_exc)

A_matrix <- inla.spde.make.A(mesh1, loc = as.matrix(efb_exc[,c(44,45)]))
A_dim <- dim(A_matrix)


#######---CV-----##### 
folds <- sb_pred$folds

for (k in seq_along(folds)) {
  assign(paste("IDtrainSet_",k,sep = ""),unlist(folds[[k]][1]))
}

for(k in seq_along(folds)) {
  assign(paste("IDtestSet_",k,sep =""),unlist(folds[[k]][2]))
}

train_list <- list(IDtrainSet_1,IDtrainSet_2,IDtrainSet_3,
                   IDtrainSet_4,IDtrainSet_5)
test_list <- list(IDtestSet_1,IDtestSet_2,IDtestSet_3,
                  IDtestSet_4,IDtestSet_5)

#match and subset to respective training and testing datasets 
train_dfs <- lapply(train_list, function(i) efb_exc[match(i,efb_exc$OID),]) 

for (i in seq_along(train_dfs)) {
  train_dfs[[i]]$fold <- rep("train",nrow(train_dfs[[i]]))
}

test_dfs <- lapply(test_list, function(i) efb_exc[match(i,efb_exc$OID),])

for (i in seq_along(test_dfs)) {
  test_dfs[[i]]$fold <- rep("test",nrow(test_dfs[[i]]))
}
#second row of each has all NAs.. hopefully won't affect things down the road 

#set PA to NAs 
test_dfs <- lapply(seq_along(test_dfs),function(i,x) {x[[i]] %>% 
    mutate(hyd_bin = ifelse(as.numeric(hyd_bin) >= 0, "NA",as.numeric(hyd_bin)))},x=test_dfs)
#set abundance to NAs 
test_dfs <- lapply(seq_along(test_dfs),function(i,x) {x[[i]] %>% 
    mutate(EFB_cover = ifelse(as.numeric(EFB_cover) >= 0, "NA",as.numeric(EFB_cover)))},x=test_dfs)

#combine test_dfs to training dfs 
final_dfs <- mapply(rbind,train_dfs,test_dfs,SIMPLIFY = FALSE)
final_dfs <- lapply(final_dfs,function(df) mutate_at(df, .vars = c("hyd_bin","EFB_cover"),as.double))

#make sure response vars have desired training and testing NAs 
sapply(final_dfs[[1]],tail)
#everything in quotes? characters? 

names.list <- c("FullNewNI_Fold_1","FullNewNI_Fold_2","FullNewNI_Fold_3",
                "FullNewNI_Fold_4","FullNewNI_Fold_5")

for (i in 1:length(final_dfs)) {
  write.csv(final_dfs[i],paste0(names.list[i],'.csv'))
}

for (k in seq_along(final_dfs)) {
  z <- efb_exc$hyd_bin
  y <- ifelse(final_dfs[[k]]$EFB_cover > 0, yes=final_dfs[[k]]$EFB_cover,no = NA)
  y_noNA <- y[!is.na(y)]
  cens <- 0.001
  y_noNA[y_noNA >= 1-cens] <- 1-cens
  y[y >= 1-cens] <- 1-cens
  
  stack.EFB_y <- inla.stack(data = list(alldata = cbind(y,NA)), 
                            A = list(A_matrix, 1),
                            effects = list(s.index_mY = spde$n.spde,
                                           list(b0Y = rep(1, nrow(final_dfs[[k]])),
                                                data.frame(depth=scale(final_dfs[[k]]$wtr__)[,1]),data.frame(depthq=scale(final_dfs[[k]]$wtr__)[,1]),
                                                data.frame(typha=scale(final_dfs[[k]]$typ_cover)[,1]),
                                                data.frame(boats=scale(final_dfs[[k]]$NEAR_DIST)[,1]), data.frame(fetch=scale(final_dfs[[k]]$MeanFetch)[,1]),
                                                data.frame(dist_inv = scale(final_dfs[[k]]$Near_InvNew)[,1]), 
                                                idY = rep(1,nrow(final_dfs[[k]])), idYq = rep(1,nrow(final_dfs[[k]])), idY2 = rep(1,nrow(final_dfs[[k]])),idY3 = rep(1,nrow(final_dfs[[k]])),
                                                idY4 = rep(1,nrow(final_dfs[[k]])), idY5 = rep(1,nrow(final_dfs[[k]])))), 
                            tag = "Beta (EFB Cover)")
  
  stack.EFB_z <- inla.stack(data = list(alldata = cbind(NA,z)), 
                            A = list(A_matrix, 1),
                            effects = list(s.index_mZ = spde$n.spde,
                                           list(b0Z = rep(1, nrow(final_dfs[[k]])),
                                                data.frame(depth=scale(final_dfs[[k]]$wtr__)[,1]),data.frame(depthq=scale(final_dfs[[k]]$wtr__)[,1]),
                                                data.frame(typha=scale(final_dfs[[k]]$typ_cover)[,1]),
                                                data.frame(boats=scale(final_dfs[[k]]$NEAR_DIST)[,1]), data.frame(fetch=scale(final_dfs[[k]]$MeanFetch)[,1]),
                                                data.frame(dist_inv = scale(final_dfs[[k]]$Near_InvNew)[,1]), 
                                                idZ = rep(1,nrow(final_dfs[[k]])), idZq = rep(1,nrow(final_dfs[[k]])), idZ2 = rep(1,nrow(final_dfs[[k]])),idZ3 = rep(1,nrow(final_dfs[[k]])),
                                                idZ4 = rep(1,nrow(final_dfs[[k]])), idZ5 = rep(1,nrow(final_dfs[[k]])))), 
                            tag = "Bernoulli (EFB Occurence)")
  
  stackm <- inla.stack(stack.EFB_y,stack.EFB_z)
  
  prec.prior <- list(prec = list(prec = list(initial = 40000, fixed = TRUE)))
  
  formula_all <- alldata ~ 0 + b0Y + b0Z +
    f(s.index_mY,model=spde) +
    f(s.index_mZ, copy = "s.index_mY", hyper = list(beta = list(fixed = FALSE))) +
    f(idY, depth, hyper = prec.prior) +
    f(idZ, depth, hyper = prec.prior) +
    f(idYq, I(depth^2), hyper = prec.prior) +
    f(idZq, I(depth^2), hyper = prec.prior) +
    f(idY2, typha, hyper = prec.prior) +
    f(idZ2, typha, hyper = prec.prior) +
    f(idY3, boats, hyper = prec.prior) +
    f(idZ3, boats, hyper = prec.prior) +
    f(idY4, fetch, hyper = prec.prior) +
    f(idZ4, fetch, hyper = prec.prior) +   
    f(idY5, dist_inv, hyper = prec.prior) + 
    f(idZ5, dist_inv, hyper = prec.prior)
  
  EFB.hurdlemodel.inla <- inla(formula_all,
                               data = inla.stack.data(stackm),
                               control.predictor = list(A = inla.stack.A(stackm), link = c(rep(1,length(y)), rep(2,length(z))), compute = TRUE),
                               control.compute = list(dic = T, waic = T, config = T,
                                                      hyperpar = T, return.marginals=T), 
                               family = c("beta", "binomial"),
                               control.family = list(list(link = 'logit'), list(link = 'logit')), 
                               control.fixed = list(mean = c(0,0), prec = c(list(prior = "pc.prec", param = c(0.2, 0.85)), list(prior = "pc.prec", param = c(0.2, 0.85)))),
                               control.inla(list(strategy="laplace")),
                               verbose = T)
  
  
  
  EFB.hurdlemodel.inla.complete <- list(summary.fixed = EFB.hurdlemodel.inla$summary.fixed,
                                        summary.hyperpar = EFB.hurdlemodel.inla$summary.hyperpar,
                                        summary.fitted.values = EFB.hurdlemodel.inla$summary.fitted.values,
                                        summary.random = EFB.hurdlemodel.inla$summary.random,
                                        dic = EFB.hurdlemodel.inla$dic, 
                                        waic = EFB.hurdlemodel.inla$waic, 
                                        marginals.fixed = EFB.hurdlemodel.inla$marginals.fixed,
                                        marginals.random = EFB.hurdlemodel.inla$marginals.random,
                                        marginals.hyperpar = EFB.hurdlemodel.inla$marginals.hyperpar,
                                        internal.marginals.hyperpar = EFB.hurdlemodel.inla$internal.marginals.hyperpar,
                                        marginals.spde2.blc = EFB.hurdlemodel.inla$marginals.spde2.blc,
                                        marginals.spde3.blc = EFB.hurdlemodel.inla$marginals.spde3.blc,
                                        internal.marginals.hyperpar = EFB.hurdlemodel.inla$internal.marginals.hyperpar)
  
  
  save(EFB.hurdlemodel.inla.complete, file = paste0("/bsuhome/louisjochems/SDMRuns_2025/Full_All/FullModel_NewNI_Fold",k,".RData"))
  
}

