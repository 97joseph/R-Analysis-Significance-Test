#Functions.R

oneprop.CI <- function(x, n, conf.level=0.95) {
  phat <- x/n
  qhat <- 1 - phat
  se.phat <- sqrt(phat*qhat/n) 
  alphaO2 <- (1 - conf.level)/2
  zcrit <- abs(qnorm(alphaO2))
  LB <- phat - (zcrit*(se.phat))
  UB <- phat + (zcrit*(se.phat))
  result <- cbind(phat = phat, Lower = LB, Upper = UB)
  return(result)
}

oneprop.HT <- function(x, n, pmu=0, alternative="two.sided") {
  phat <- x/n
  se.phat <- sqrt(pmu*(1-pmu)/n) 
  z.score <- (phat - pmu)/se.phat
  p.value <- 1 - pnorm(abs(z.score)) #upper tail
  if (alternative == "two.sided") p.value = 2*p.value
  result <- cbind(phat = phat, zStat = z.score, pValue = p.value)
  return(result)
}

twoprop.CI <- function(x1, n1, x2, n2, conf.level=0.95) {
  phat1 <- x1/n1
  qhat1 <- 1 - phat1
  phat2<- x2/n2
  qhat2 <- 1 - phat2 
  diff.phat <- phat1 - phat2
  se.phat <- sqrt((phat1*qhat1/n1) + (phat2*qhat2/n2))
  alphaO2 <- (1 - conf.level)/2
  zcrit <- abs(qnorm(alphaO2))
  LB <- diff.phat - (zcrit*(se.phat))
  UB <- diff.phat + (zcrit*(se.phat))
  result <- cbind(diff = diff.phat, Lower = LB, Upper = UB)
  return(result)
}

### Add code below for a function call twoprop.HT
### Also include your code in a chunk in the .Rmd file
### under section 5a, so we can see your function
### We included code to get you started--just add
### what you need between the { }.

twoprop.HT <- function(x1, n1, x2, n2, alternative="two.sided") {

}  