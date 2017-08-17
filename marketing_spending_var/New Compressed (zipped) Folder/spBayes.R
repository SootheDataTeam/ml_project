library(spBayes)

## Not run:
rmvn <- function(n, mu=0, V = matrix(1)){
  p <- length(mu)
  if(any(is.na(match(dim(V),p))))
    stop("Dimension problem!")
  D <- chol(V)
  t(matrix(rnorm(n*p), ncol=p)%*%D + rep(mu,rep(n,p)))
}
set.seed(1)
n <- 600
coords <- cbind(runif(n,0,1), runif(n,0,1))
X <- as.matrix(c(rnorm(n)))*1
B <- as.matrix(c(1))
p <- length(B)
#sigma.sq <- 5
#tau.sq <- 1
#phi <- 3/0.5
#D <- as.matrix(dist(coords))
#R <- exp(-phi*D)
#w <- rmvn(1, rep(0,n), sigma.sq*R)
#y <- rnorm(n, X%*%B + w, sqrt(tau.sq))

# 
N <- 20000
x1=runif(N)
x2=runif(N)
coords <- cbind(x1,x2)
true.func=function(x1,x2)
{
  ans=4*sin((x1+x2)*10)+
    3*cos((x1-x2)*10)+
    #4*cos((x1-x2)*10)+
    .1*x1+
    .2*x2

  return(ans-mean(ans))
}

w=true.func(x1,x2)
summary(w)
y=w+rnorm(N)
X <- as.matrix(c(rnorm(N)))/100


n.samples <- 1200
starting <- list("phi"=1000, "sigma.sq"=10, "tau.sq"=1)


tuning <- list("phi"=1, "sigma.sq"=.5, "tau.sq"=.1)
priors.1 <- list("beta.Norm"=list(rep(0,p), diag(1/10000,p)),
                 "phi.Unif"=c(1, 10000), 
                 "sigma.sq.IG"=c(2, 4),
                 "tau.sq.IG"=c(2, 2))

cov.model <- "exponential"
#cov.model="gaussian"
n.report <- 10
verbose <- TRUE
start.time=Sys.time()
m.1 <- spLM(y~X-1, coords=coords, starting=starting,
            knots = c(9,9,.01),
            tuning=tuning, priors=priors.1, cov.model=cov.model,
            n.samples=n.samples, verbose=verbose, n.report=n.report)


names(m.1)

names(m.1)
(m.1$p.beta.samples)
plot(m.1$p.beta.samples[,2],type="l")
(m.1$p.theta.samples)
plot(m.1$p.theta.samples[,3],type="l")
#m.1 <- spLM(y~X-1, coords=coords, knots=c(9,9,0.1), starting=starting,
#            tuning=tuning, priors=priors.1, cov.model=cov.model,
#            n.samples=n.samples, verbose=verbose, n.report=n.report)


burn.in <- 0.25*n.samples
##recover beta and spatial random effects
m.1 <- spRecover(m.1, start=burn.in, verbose=FALSE)
# m.2 <- spRecover(m.2, start=burn.in, verbose=FALSE)
# round(summary(m.1$p.theta.recover.samples)$quantiles[,c(3,1,5)],2)
# round(summary(m.2$p.theta.recover.samples)$quantiles[,c(3,1,5)],2)
# round(summary(m.1$p.beta.recover.samples)$quantiles[,c(3,1,5)],2)
# round(summary(m.2$p.beta.recover.samples)$quantiles[,c(3,1,5)],2)
m.1.w.summary <- summary(mcmc(t(m.1$p.w.recover.samples)))$quantiles[,c(3,1,5)]
# m.2.w.summary <- summary(mcmc(t(m.2$p.w.recover.samples)))$quantiles[,c(3,1,5)]
plot(w, m.1.w.summary[,1], xlab="Observed w", ylab="Fitted w",
     xlim=range(w), ylim=range(m.1.w.summary), main="Spatial random effects")
names(m.1.w.summary)

test.x1=rep(seq(0.01,0.99,length=10),each=10)
test.x2=rep(seq(0.01,0.99,length=10),10)
test.coords=cbind(test.x1,test.x2)

w.test=true.func(test.x1,test.x2)
test.pred=spPredict(sp.obj =m.1,thin = 4,
                    pred.coords =test.coords,
                    pred.covars = cbind(rep(0,nrow(test.coords))))

test.pred=rowMeans(test.pred$p.y.predictive.samples)
plot(test.pred,w.test)
sqrt(sum(test.pred-w.test)^2)
end.time=Sys.time()
print(end.time-start.time)

summary(1/rgamma(1000,1.5,rate=1.5))

