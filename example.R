source('help_funcs.R')
source('L2BOOST-CUT.R')
source('L2BOOST-IMP.R')

set.seed(1234)

# Simulate Data
n <- 500
n.monitor <- 3
tau <- 6
b0 <- 1
b1 <- 0.8
b2 <- 0.8
sigma <- 0.25 
setting <- 'lognormal'

dat <- datGen(n, n.monitor, tau, b0, b1, b2, sigma, setting)
dat_tr <- dat[[1]]
dat_te <- dat[[2]]

# L2Boost Execution
cut <- L2BOOSTCUT(dat_tr, dat_te, n, 10, tau)
imp <- L2BOOSTIMP(dat_tr, dat_te, n, 10, tau)