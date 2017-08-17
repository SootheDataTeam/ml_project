library(MTS)
VARXpred=function (m1, newxt = NULL, hstep = 1, orig = 0) 
{
  zt = as.matrix(m1$data)
  xt = as.matrix(m1$xt)
  p = m1$aror
  m = m1$m
  Ph0 = as.matrix(m1$Ph0)
  Phi = as.matrix(m1$Phi)
  Sig = as.matrix(m1$Sigma)
  beta = as.matrix(m1$beta)
  include.m = m1$include.mean
  nT = dim(zt)[1]
  k = dim(zt)[2]
  dx = dim(xt)[2]
  se = NULL
  if (length(Ph0) < 1) 
    Ph0 = matrix(rep(0, k), k, 1)
  if (hstep < 1) 
    hstep = 1
  if (orig < 1) 
    orig = nT
  if (length(newxt) > 0) {
    if (!is.matrix(newxt)) 
      newxt = as.matrix(newxt)
    h1 = dim(newxt)[1]
    hstep = min(h1, hstep)
    nzt = as.matrix(zt[1:orig, ])
    xt = rbind(xt[1:orig, , drop = FALSE], newxt)
    for (i in 1:hstep) {
      tmp = Ph0
      ti = orig + i
      for (i in 1:p) {
        idx = (i - 1) * k
        tmp = tmp + Phi[, (idx + 1):(idx + k)] %*% matrix(nzt[ti - 
                                                                i, ], k, 1)
      }
      if (m > -1) {
        for (j in 0:m) {
          jdx = j * dx
          tmp = tmp + beta[, (jdx + 1):(jdx + dx)] %*% 
            matrix(xt[ti - j, ], dx, 1)
        }
      }
      nzt = rbind(nzt, c(tmp))
    }
    mm = VARpsi(Phi, lag = hstep)
    Si = Sig
    se = matrix(sqrt(diag(Si)), 1, k)
    if (hstep > 1) {
      for (i in 2:hstep) {
        idx = (i - 1) * k
        wk = as.matrix(mm$psi[, (idx + 1):(idx + k)])
        Si = Si + wk %*% Sig %*% t(wk)
        se1 = sqrt(diag(Si))
        se = rbind(se, se1)
      }
    }
    cat("Prediction at origin: ", orig, "\n")
    cat("Point forecasts (starting with step 1): ", "\n")
    pred.mean=(round(nzt[(orig + 1):(orig + hstep), ], 5))
    cat("Corresponding standard errors: ", "\n")
    pred.sd=(round(se[1:hstep, ], 5))
  }
  else {
    cat("Need new data for input variables!", "\n")
  }
  return(list(pred.mean=pred.mean,pred.sd=pred.sd))
}

library(quadprog)

lm.constrained <- function(y, x, Amat, b0){
  # x <- cbind(1, x) ## Add coefficient
  D <- t(x) %*% x
  dlittle <- t(x) %*% y
  return(solve.QP(D, dlittle, Amat, b0, 0))
}


#lm.constrained(yt,xmtx,diag(ncol(xmtx)),rep(0,ncol(xmtx)))


VARX=function (zt, p, xt = NULL, m = 0, include.mean = T, fixed = NULL, 
          output = T) 
{
  zt = as.matrix(zt)
  if (length(xt) < 1) {
    m = -1
    kx = 0
  }
  else {
    xt = as.matrix(xt)
    kx = dim(xt)[2]
  }
  if (p < 0) 
    p = 0
  ist = max(p, m) + 1
  nT = dim(zt)[1]
  k = dim(zt)[2]
  yt = zt[ist:nT, ]
  xmtx = NULL
  if (include.mean) 
    xmtx = rep(1, (nT - ist + 1))
  if (p > 0) {
    for (i in 1:p) {
      xmtx = cbind(xmtx, zt[(ist - i):(nT - i), ])
    }
  }
  if (m > -1) {
    for (j in 0:m) {
      xmtx = cbind(xmtx, xt[(ist - j):(nT - j), ])
    }
  }
  p1 = dim(xmtx)[2]
  nobe = dim(xmtx)[1]
  if (length(fixed) < 1) {
    xpx = t(xmtx) %*% xmtx
    xpy = t(xmtx) %*% yt
    xpxi = solve(xpx)
    beta = matrix(0,ncol(xmtx),ncol(yt))
    #print(dim(beta))
    #print(dim(yt))
    #print(dim(xmtx))
    
    for(hh in 1:(dim(yt)[2]))
    {
    lm.constrained1=lm.constrained(y =(yt[,hh]),x = xmtx, Amat = diag(ncol(xmtx)),b0 = rep(0,ncol(xmtx)))
    beta[,hh] =(lm.constrained1$solution>0)*lm.constrained1$solution
    
    }
    
    print("beta=")
    print(as.vector(beta))
    
    resi = as.matrix(yt - xmtx %*% beta)
    sig = crossprod(resi, resi)/nobe
    co = kronecker(sig, xpxi)
    se = sqrt(diag(co))
    se.beta = matrix(se, nrow(beta), k)
    npar = nrow(beta) * k
    d1 = log(det(sig))
    aic = d1 + 2 * npar/nobe
    bic = d1 + (npar * log(nobe))/nobe
  }
  else {
    beta = matrix(0, p1, k)
    se.beta = matrix(1, p1, k)
    resi = yt
    npar = 0
    for (i in 1:k) {
      idx = c(1:p1)[fixed[, i] > 0]
      npar = npar + length(idx)
      if (length(idx) > 0) {
        xm = as.matrix(xmtx[, idx])
        y1 = matrix(yt[, i], nobe, 1)
        xpx = t(xm) %*% xm
        xpy = t(xm) %*% y1
        xpxi = solve(xpx)
        beta1 = xpxi %*% xpy
        res = y1 - xm %*% beta1
        sig1 = sum(res^2)/nobe
        se = sqrt(diag(xpxi) * sig1)
        beta[idx, i] = beta1
        se.beta[idx, i] = se
        resi[, i] = res
      }
    }
    sig = crossprod(resi, resi)/nobe
    d1 = log(det(sig))
    aic = d1 + 2 * npar/nobe
    bic = d1 + log(nobe) * npar/nobe
  }
  Ph0 = NULL
  icnt = 0
  if (include.mean) {
    Ph0 = beta[1, ]
    icnt = icnt + 1
    cat("constant term: ", "\n")
    cat("est: ", round(Ph0, 4), "\n")
    cat(" se: ", round(se.beta[1, ], 4), "\n")
  }
  Phi = NULL
  if (p > 0) {
    Phi = t(beta[(icnt + 1):(icnt + k * p), ])
    sePhi = t(se.beta[(icnt + 1):(icnt + k * p), ])
    for (j in 1:p) {
      cat("AR(", j, ") matrix", "\n")
      jcnt = (j - 1) * k
      print(round(Phi[, (jcnt + 1):(jcnt + k)], 3))
      cat("standard errors", "\n")
      print(round(sePhi[, (jcnt + 1):(jcnt + k)], 3))
    }
    icnt = icnt + k * p
  }
  if (m > -1) {
    cat("Coefficients of exogenous", "\n")
    Beta = t(beta[(icnt + 1):(icnt + (m + 1) * kx), ])
    seBeta = t(se.beta[(icnt + 1):(icnt + (m + 1) * kx), 
                       ])
    for (i in 0:m) {
      jdx = i * kx
      cat("lag-", i, " coefficient matrix", "\n")
      print(round(Beta[, (jdx + 1):(jdx + kx)], 3))
      cat("standard errors", "\n")
      print(round(seBeta[, (jdx + 1):(jdx + kx)], 3))
    }
  }
  cat("Residual Covariance Matrix", "\n")
  print(round(sig, 5))
  cat("===========", "\n")
  cat("Information criteria: ", "\n")
  cat("AIC: ", aic, "\n")
  cat("BIC: ", bic, "\n")
  VARX <- list(data = zt, xt = xt, aror = p, m = m, Ph0 = Ph0, 
               Phi = Phi, beta = Beta, residuals = resi, Sigma = sig, 
               coef = beta, se.coef = se.beta, include.mean = include.mean)
}
