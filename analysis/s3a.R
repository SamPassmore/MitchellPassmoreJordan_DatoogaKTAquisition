## s3a This document contains Age only models of genealogical knowledge
#!/usr/bin/env Rscript

library(brms)
library(dplyr)
library(bayesplot)
library(tidyr)

seed = 93645

## first get the data
data = read.csv('data/merged_data.csv', na.strings = c("?", "NA"))

# data must be subset to those who answered as F to Q1
# because of inconsistencies in question asking
data = data[data$keepQ1 == 1,]

#### Parameters #### 
chains = 2
iter = 3000
max_iter = 100

#### Models #### 

cat("Running model for Q2.... \n\n")

dq2 = data[,c("Q2", "Age2")]
dq2 = dq2[complete.cases(dq2),]

fit.q2 = brm(Q2 ~ Age2,
             family = bernoulli(link = "logit"),
             prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                       set_prior(prior = "normal(0,5)", class = "b")),
             data = dq2, chains = chains, iter = iter, file = "./results/models/q2a",
             seed = seed)

cat("Running model for Q3.... \n\n")

dq3 = data[,c("Q3", "Age2")]
dq3 = dq3[complete.cases(dq3),]

fit.q3 = brm(Q3 ~ Age2,
             family = bernoulli(link = "logit"),
             prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                       set_prior(prior = "normal(0,5)", class = "b")),
             data = dq3, chains = chains, iter = iter, file = "./results/models/q3a",
             seed = seed)

cat("Running model for Q4.... \n\n")

dq4 = data[,c("Q4", "Age2")]
dq4 = dq4[complete.cases(dq4),]

fit.q4 = brm(Q4 ~ Age2,
             family = bernoulli(link = "logit"),
             prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                       set_prior(prior = "normal(0,5)", class = "b")),
             data = dq4, chains = chains, iter = iter, file = "./results/models/q4a",
             seed = seed)

cat("Running model for Q5a.... \n\n")

dq5a = data[,c("Q5a", "Age2")]
dq5a = dq5a[complete.cases(dq5a),]

fit.q5a = brm(Q5a ~ Age2,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq5a, chains = chains, iter = iter, file = "./results/models/q5aa",
              seed = seed)

cat("Running model for Q5b.... \n\n")

dq5b = data[,c("Q5b", "Age2")]
dq5b = dq5b[complete.cases(dq5b),]

fit.q5b = brm(Q5b ~ Age2,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq5b, chains = chains, iter = iter, file = "./results/models/q5ba",
              seed = seed)

cat("Running model for Q5c.... \n\n")

dq5c = data[,c("Q5c", "Age2")]
dq5c = dq5c[complete.cases(dq5c),]

fit.q5c = brm(Q5c ~ Age2,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq5c, chains = chains, iter = iter, file = "./results/models/q5ca",
              seed = seed)

cat("Running model for Q5d.... \n\n")

dq5d = data[,c("Q5d", "Age2")]
dq5d = dq5d[complete.cases(dq5d),]

fit.q5d = brm(Q5d ~ Age2,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq5d, chains = chains, iter = iter, file = "./results/models/q5da",
              seed = seed)
