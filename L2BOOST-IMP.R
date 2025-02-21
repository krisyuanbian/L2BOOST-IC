library(icrf)
library(survival)

# Function for L2Boost with Interval Censored Random Forests using IMP
L2BOOSTIMP <- function(dat_tr, dat_te, nn, ntree, tau, mmax = 1e5, tol = 1e-5) {
  # Extract training and testing data
  x_tr <- dat_tr$x
  ftrue_tr <- dat_tr$mu
  x_te <- dat_te$x
  ftrue_te <- dat_te$mu
  l_tr <- dat_tr$l
  r_tr <- dat_tr$r
  l_te <- dat_te$l
  r_te <- dat_te$r
  
  # Create unique sorted time points
  t <- unique(sort(c(l_tr, r_tr, l_te, r_te)))
  
  # Fit Interval Censored Random Forest model
  sim.icrf <- icrf(
    Surv(l_tr, r_tr, type = "interval2") ~ x,
    data = dat_tr,
    ERT = T,
    split.rule = 'GWRS',
    returnBest = T,
    tau = tau,
    ntree = ntree,
    timeSmooth = t,
    quasihonesty = F
  )
  
  # Predict survival function for training and testing sets
  s.sm.tr <- sim.icrf$predicted.Sm
  s.sm.te <- predict(sim.icrf, newdata = dat_te)
  
  # Match left and right interval bounds with time points
  l.index.tr <- match(l_tr, t)
  l.index.te <- match(l_te, t)
  r.index.tr <- match(r_tr, t)
  r.index.te <- match(r_te, t)
  
  # Initialize variables for estimating expected log survival times
  denom.tr <- numeric(0.8 * nn)
  egy1.tr <- numeric(0.8 * nn)
  egy1p.tr <- numeric(0.8 * nn)
  denom.te <- numeric(0.2 * nn)
  egy1.te <- numeric(0.2 * nn)
  egy1p.te <- numeric(0.2 * nn)
  
  # Compute expected log survival times for training set
  for (j in seq_len(0.8 * nn)) {
    denom.tr[j] <- s.sm.tr[j, r.index.tr[j]] - s.sm.tr[j, l.index.tr[j]]
    v.index.tr <- max(l.index.tr[j], 2)
    w.index.tr <- min(r.index.tr[j], length(t) - 1)
    
    while (v.index.tr < w.index.tr) {
      egy1p.tr[j] <- egy1p.tr[j] + log(t[v.index.tr]) * 
        (s.sm.tr[j, v.index.tr + 1] - s.sm.tr[j, v.index.tr])
      v.index.tr <- v.index.tr + 1
    }
    egy1.tr[j] <- egy1p.tr[j] / denom.tr[j]
  }
  
  # Compute expected log survival times for test set
  for (j in seq_len(0.2 * nn)) {
    denom.te[j] <- s.sm.te[j, r.index.te[j]] - s.sm.te[j, l.index.te[j]]
    v.index.te <- max(l.index.te[j], 2)
    w.index.te <- min(r.index.te[j], length(t) - 1)
    
    while (v.index.te < w.index.te) {
      egy1p.te[j] <- egy1p.te[j] + log(t[v.index.te]) * 
        (s.sm.te[j, v.index.te + 1] - s.sm.te[j, v.index.te])
      v.index.te <- v.index.te + 1
    }
    egy1.te[j] <- egy1p.te[j] / denom.te[j]
  }
  
  # Compute initial function estimates using smooth splines
  h.ss <- hss(egy1.tr, rep(0, 0.8 * nn), x_tr)
  f_tr <- 0.01 * predict(h.ss, x_tr)$y
  f_te <- 0.01 * predict(h.ss, x_te)$y
  
  # Initialize loss tracking
  loss_tr <- numeric()
  loss_te <- numeric()
  loss_tr <- append(loss_tr, l2_loss(egy1.tr, f_tr))
  loss_te <- append(loss_te, l2_loss(egy1.te, f_te))
  
  # Iteratively update function estimates using boosting
  for (j in seq_len(mmax)) {
    h.ss <- hss(egy1.tr, f_tr, x_tr)
    f1_tr <- f_tr + 0.01 * predict(h.ss, x_tr)$y
    f1_te <- f_te + 0.01 * predict(h.ss, x_te)$y
    
    loss_tr <- append(loss_tr, l2_loss(egy1.tr, f1_tr))
    loss_te <- append(loss_te, l2_loss(egy1.te, f1_te))
    
    # Check for convergence
    if (abs(loss_tr[j + 1] - loss_tr[j]) < tol) {
      return(list(loss_tr=loss_tr, loss_te=loss_te, f_tr=f_tr, f_te=f_te, 
                  ftrue_tr=ftrue_tr, ftrue_te=ftrue_te))
    }
    f_tr <- f1_tr
    f_te <- f1_te
  }
  
  message('The algorithm does not converge!')
}