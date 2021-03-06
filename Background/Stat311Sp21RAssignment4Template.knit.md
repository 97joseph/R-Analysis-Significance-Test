---
output:
  pdf_document: default
  html_document: default
---

ASSSIGNMENT

EXPLORATORY DATA ANALYISIS
1.Read the ice cream, birthweight, and cholesterol data sets.

The following fucntions reads the three datasets and displays their structures through the View() function


```r
IC.df <- read.csv("E:/DATA SCIENCE JOBS/R-Analysis Significance Test/Background/IceCream.csv", header=TRUE, as.is=TRUE)
IC.df$Sex <- as.factor(IC.df$Sex)
IC.df$Flavor <- as.factor(IC.df$Flavor)
View(IC.df)
#
BW.df <- read.csv("E:/DATA SCIENCE JOBS/R-Analysis Significance Test/Background/BirthWeight.csv", header=TRUE, as.is=TRUE)
BW.df$Smoker <- as.factor(BW.df$Smoker)
BW.df$BirthWt <- as.factor(BW.df$BirthWt)
BW.df$MAgeGT35 <- as.factor(BW.df$MAgeGT35)
View(BW.df)
#
C.df <- read.csv("E:/DATA SCIENCE JOBS/R-Analysis Significance Test/Background/Cholesterol.csv", header=TRUE, as.is=TRUE)
View(C.df)
C.df$Cereal <- as.factor(C.df$Cereal)
```
1. Find and interpret the 92% confidence interval for the population mean puzzle score.



```r
# Look at the t.test help file
?t.test
```

```
## starting httpd help server ... done
```

```r
# First interval is 95%, which is the default if you do
# not specify conf.level
t.test(IC.df$Puzzle)$conf.int
```

```
## [1] 50.90802 53.90198
## attr(,"conf.level")
## [1] 0.95
```



2. Hypothesis test for the difference between mean puzzle scores by ice cream type. a. Create two subsets of puzzle scores, one for students that favor strawberry ice cream and one for students that favor chocolate ice cream. b. Test the claim that students with a preference for strawberry ice cream have higher puzzle scores than students that prefer chocolate ice cream. Use strawberry minus chocolate and a 1% significance level. Assume the population variances are not equal. c. Do you think the statistical test results from part (b) have practical significance? 

```r
# First get the right subset of data
D.CD <- filter(IC.df, Flavor == "1")
D.CI <- filter(IC.df, Flavor == "2")

# Look at the samples sizes and samples SDs for each group 
# to inform the decision for un-pooled or pooled variance.
n.CD <- nrow(D.CD)
sd.CD <- sd(D.CD$Puzzle)
n.CI <- nrow(D.CI)
sd.CI <- sd(D.CI$Puzzle)
cbind(nCD = n.CD, SD.CD = sd.CD, nCI = n.CI, SD.CI = sd.CI)
```

```
##      nCD    SD.CD nCI    SD.CI
## [1,]  95 9.972785  47 10.83695
```

```r
# The sample size for color D is smallish; the two sample
# SDs are similar. This could go either way. If we pool, 
# we will be giving a higher weight to the lower variance.
# Checking our ROT gives us a ratio < 3 (code shown below), 
# so pooling is probably okay.

sd.CD^2/sd.CI^2
```

```
## [1] 0.8468745
```

```r
# Using un-pooled would be most conservative. At the same time
# pooling may be reasonable because we might expect the
# population variances to be similar for Weight (would we expect
# the variation in Weight to be different for different colors?).

# We will run it both ways here so you can see the difference--in
# practice, you would make a choice based on your understanding
# of diamond weights and go from there.

# First interval is 1% using an un-pooled variance, both are
# defaults 
t.test(D.CD$Puzzle, D.CI$Puzzle,conf.level=0.01)$conf.int
```

```
## [1] 4.68876 4.73610
## attr(,"conf.level")
## [1] 0.01
```

```r
# Same interval as above but with pooled variance
t.test(D.CD$Puzzle, D.CI$Puzzle, var.equal=TRUE)$conf.int
```

```
## [1] 1.093332 8.331528
## attr(,"conf.level")
## [1] 0.95
```




```r
# Same two calls from above after removing the $conf.int at 
# the end to see all the t.test output
t.test(D.CD$Puzzle, D.CI$Puzzle,conf.level=0.01)$conf.int
```

```
## [1] 4.68876 4.73610
## attr(,"conf.level")
## [1] 0.01
```

```r
t.test(D.CD$Puzzle, D.CI$Puzzle, var.equal=TRUE)
```

```
## 
## 	Two Sample t-test
## 
## data:  D.CD$Puzzle and D.CI$Puzzle
## t = 2.5743, df = 140, p-value = 0.01108
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  1.093332 8.331528
## sample estimates:
## mean of x mean of y 
##  52.03158  47.31915
```

(b)Test the claim that students with a preference for strawberry ice cream have higher puzzle scores than students that prefer chocolate ice cream. Use strawberry minus chocolate and a 1% significance level. Assume the population variances are not equal. 



```r
# Test the claim that students with a preference for strawberry ice cream have higher puzzle scores than students that prefer chocolate ice cream. Use strawberry minus chocolate and a 1% significance level. Assume the population variances are not equal. 


# Enter measured, then reported as stated in the problem statement
# Add the paired=TRUE argument to let R know that the data are
# matched pairs. Set the conf.level to 0.01
t.test(IC.df$Flavor=="1",IC.df$Flavor=="3", paired=TRUE, 
       conf.level = 0.01)$conf.int
```

```
## [1] 0.1842395 0.1857605
## attr(,"conf.level")
## [1] 0.01
```

3. Using the oneprop.CI function in the R4 Tutorial, find the 98% confidence interval for the proportion of smokers in the birthweight data set. Assume large sample conditions are met.


```r
# The three arguments passed to the function are
# x = number of successes, n = total number of observations
# and conf.level. We will default conf.level to 0.95.
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
```
Find a 98% confidence interval for the proportion of  smokers in the BirthWeight. Before we proceed, we should check the large sample conditions: n x phat > 10 and n x qhat > 10. We use phat and qhat because p unknown. First check that the large sample conditions hold.

```r
tab1 <- table(BW.df$Smoker)
sum(tab1)*(tab1[1]/sum(tab1)) #nphat
```

```
##  0 
## 20
```

```r
sum(tab1)*(1-(tab1[1]/sum(tab1))) #n(1-phat) = nqhat
```

```
##  0 
## 22
```



```r
oneprop.CI(tab1[1], sum(tab1), conf.level=0.98)
```

```
##        phat     Lower     Upper
## 0 0.4761905 0.2969125 0.6554685
```


4. Consider birthweights for mothers that are smokers and nonsmokers.   a. Create a function called twoprop.HT that uses a two-sample z test to test for the difference between two population proportions assuming independent samples.

b. Test the claim that the proportion of low birthweight babies is higher for mothers that smoked (use smoked ??? did not smoke). Use a 5% significance level. Assume large sample conditions are met.

c. Are the large sample conditions met for the test in (b)? Note, you can just look at the table values instead of doing any calculations. Do you think the hypothesis test results in(b) are valid? 


We will write the function twoprop.CI to get the confidence interval for a the difference between two population proportions. 



```r
# The five arguments passed to the function are
# x1 = number of successes in sample 1, n1 = total number of observations
# in sample 1, x2 = number of successes in sample 2,
# n2 = total number of observations in sample 2, and 
# and conf.level. We will default conf.level to 0.95.
twoprop.CI <- function(x1, n1, x2, n2, conf.level=0.05) {
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
```
Before we proceed, we should check the large sample conditions: n1 x phat1 > 10, n1 x qhat1 >10, n2 x phat2 > 10, n2 x qhat2 > 10. We will define sample 1 as VVS1 and sample 2 as VVS2. We will consider H colors successes and all other colors failures within VVS1 and VVS2.

```r
(tab2 <- table(BW.df$Smoker=="0", BW.df$Smoker=="1"))
```

```
##        
##         FALSE TRUE
##   FALSE     0   22
##   TRUE     20    0
```
The large sample condition holds so we proceed with the confidence 5% interval.




5. This problem was modified from here. A cross-over trial experiment was used to investigate whether eating oat bran lowered serum cholesterol levels. Twelve individuals were randomly assigned a diet that included either oat bran or corn flakes. After two weeks on the initial diet, serum cholesterol (mmol/L) was measured and then participants were ???crossed-over??? to the other diet. After two-weeks on the second diet, cholesterol levels were once again recorded. 

a. Using a 5% significance level, test the claim that a diet that includes oat bran decreases serum cholesterol. [Use Cornflk ??? OatBran]

We will write our own function for a HT for a single population proportion.


```r
# The three arguments passed to the function are
# x = number of successes, n = total number of observations
# and conf.level. We will default conf.level to 0.95.
oneprop.HT <- function(x, n, pmu=0, alternative="two.sided") {
  phat <- x/n
  se.phat <- sqrt(pmu*(1-pmu)/n) 
  z.score <- (phat - pmu)/se.phat
  p.value <- 1 - pnorm(abs(z.score)) #upper tail
  if (alternative == "two.sided") p.value = 2*p.value
  result <- cbind(phat = phat, zStat = z.score, pValue = p.value)
  return(result)
}
```
Let's conduct a hypothesis test to determine if the population proportion of D colored diamonds is different than 10%, using a 1% significance level. Since this is a hypothesis test, the large enough conditions that must hold are n x p0 > 10 and n x q0 > 10. Here n = 308 and p0 = 0.10. Clearly n x p0 > 10, which means n x q0 > 10. We can continue since the large sample conditions are met. 

H0: p = 0.1 versus p != 0.1




```r
(tab1 <- table(C.df$Cereal=="OatBran", C.df$Cereal=="Cornflk"))
```

```
##        
##         FALSE TRUE
##   FALSE     0   12
##   TRUE     12    0
```

```r
oneprop.HT(tab1[1], sum(tab1), pmu = 0.10)
```

```
##      phat     zStat    pValue
## [1,]    0 -1.632993 0.1024704
```
b. Construct an appropriate confidence interval that could be used as an equivalent to the test in part (a). [Use Cornflake ??? OatBran]. Explain your choice and interpret the interval. 

```
As background???this is not the main analysis???it helps to calculate summary statistics for each sample separately.  Let sample 1 represent CORNFLK values and let sample 2 represent OATBRAN values. Using a calculator or computer, we determine: 
 
  	??????????1= 4.444   	s1 = 0.9688  	n1 = 14 
   	??????????2= 4.081  	s2 = 1.0570  	n2 = 14 
Interval estimation  The standard point ???estimate ?? margin of error??? approach is used to calculate the confidence interval. The (1 ??? ??)100% CI for ??d =   ????????????????????????????1??????????? 2,???????????1???????????????????????????????????  where t1-??/2, n-1 is the t percentile with n ??? 1 df for (1 ??? ??)100% confidence [from the t table] and the standard error of the mean difference ????????????????????????????????=???????????????? ??????????? .  Illustration. To determine and interpret the 95% CI for ??d , df = n ??? 1 = 14 ??? 1 = 13. For 95% confidence, use t .975,13= 2.16 [from the t table]. Use the nd and sd determined earlier in this chapter to calculate ????????????????????????????????=0.4060 ???14  = 0.1085.  The 95% CI for ???????????????? = ????????????????????????????1??????????? 2,???????????1??????????????????????????????????? = 0.3 629 ?? 2.16 ??? 0.1085 = 0.3629 ?? 0.2344 = (0.129, 0.597) mmol/l.
Interpretation:  This CI is trying to capture ????????????????, not  ??????????????????.  The margin of error is ??0.23. We consider the full extent of the interval from its lower limit (0.129) to its upper limit (0.597).  
```


 6. In clinical experiments involving different groups of independent samples, it is important that the groups be similar in the important ways that affect the experiment. In an experiment designed to test the effectiveness of paroxetine for treating bipolar depression, subjects were measured using the Hamilton depression scale with the results given below (based on data from a ???Double-Blind, Placebo-Controlled Comparison of Imipramine and Paroxetine in the Treatment of Bipolar Depression,??? by Nemeroff et al., American Journal of Psychiatry, Vol. 158, No. 6). 
 Use a 0.05 significance level to test the claim that the treatment and placebo groups come from populations with the same mean. Assume equal population variances. [Use Treatment ??? Placebo]  

```
Paroxetine patients reported greater personality change than did placebo patients, even after controlling for depression improvement (p???.002). The advantage of paroxetine over placebo in antidepressant efficacy was no longer significant after controlling for change in personality (p???.14).
Paroxetine patients reported 6.8 times as much change on neuroticism and 3.5 times as much change on extraversion as placebo patients matched for depression improvement. Although placebo patients exhibited substantial depression improvement (???1.2 SD, p<.001), they reported little change on neuroticism (???0.18 SD, p=.08) or extraversion (0.08 SD, p=.50).
CT produced greater personality change than placebo (p???.01); but its advantage on neuroticism was no longer significant after controlling for depression (p=.14). Neuroticism reduction during treatment predicted lower relapse rates among paroxetine responders (p=.003), but not among CT responders (p=.86).

```
