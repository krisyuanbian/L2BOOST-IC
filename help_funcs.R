search2 <- function(s, xvec, include = T) {
  # Finding the index of "the largest x smaller or equal to s"
  index <- if (include) {
    which(s >= c(-Inf, xvec)) - 1
  } else {
    which(s > c(-Inf, xvec)) - 1
  }
  max(index)
}

# Data generation function
datGen <- function(n, n.monitor, tau, b0, b1, b2, sigma, setting) {
  x <- runif(n)
  mu <- b0 * abs(x - 0.5) + b1 * x^3 + b2 * sin(pi * x)
  
  # Generate noise based on setting
  z <- switch(setting,
              'lognormal' = rnorm(n, sd = sigma),
              'loglogistic' = rlogis(n, location = 0, scale = sigma),
              stop("Invalid setting: choose 'lognormal' or 'loglogistic'"))
  
  y <- exp(mu + z)
  
  # Generate monitoring times matrix
  C <- t(sapply(1:n, function(x) sort(runif(n.monitor, 0, tau))))
  if (n.monitor == 1) C <- t(C)
  C[C > tau] <- Inf  # Adjust for censoring
  
  # Determine interval indices
  interval.index <- sapply(1:n, function(s) search2(y[s], c(0, C[s, ], Inf), include = F))
  L <- cbind(0, C, Inf)[cbind(1:n, interval.index)]
  R <- cbind(0, C, Inf)[cbind(1:n, interval.index + 1)]
  
  colnames(C) <- paste0('u', 1:n.monitor)
  j <- sample(n, size = n * 0.2)
  
  # Return training and testing datasets
  list(
    data.frame(x = x[-j], y = y[-j], l = L[-j], r = R[-j], mu = mu[-j], u = C[-j,]),
    data.frame(x = x[j], y = y[j], l = L[j], r = R[j], mu = mu[j], u = C[j,])
  )
}

# Loss functions
l2_loss <- function(u, v) mean(0.5 * (u - v)^2)
l2_lossG <- function(u, v) -(u - v)

# Smoothing function
hss <- function(y, f, x, degreef = 20) {
  u <- l2_lossG(y, f)
  smooth.spline(x, -u, df = degreef, all.knots = T)
}

# Cut loss function
cut_loss <- function(y2, y1, f) {
  mean(y2 / 2 - y1 * f + f^2 / 2)
}
