#!/usr/bin/env Rscript

library(brms)
library(dplyr)
library(bayesplot)
library(tidyr)

seed = 73487

## first get the data
data = read.csv('data/merged_data.csv', na.strings = c("?", "NA"))

## recode eduction
data$education_index = ifelse(data$Education == "none", 1, 
                              ifelse(data$Education == "nursery", 2, 3)) %>% 
  as.factor(.)


#### Parameters #### 
chains = 2
iter = 5000
max_iter = 100

# Q5a: Who is M to you? ----
## get complete data set
cat("Running model for Q5a.... \n\n")

dq5a = data[,c("Q5a", "Age2", "Gender", "Village_recoded", "education_index")]
dq5a = dq5a[complete.cases(dq5a),]

fit.q5a = brm(Q5a ~ Age2 + Gender + Village_recoded + education_index,
             family = bernoulli(link = "logit"),
             prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                       set_prior(prior = "normal(0,5)", class = "b")),
             data = dq5a, chains = chains, iter = iter, file = "./results/models/q5a",
             seed = seed)

# summary(fit.q5a)

# Q5b: Who is F to you? ----
dq5b = data[,c("Q5b", "Age2", "Gender", "Village_recoded", "education_index")]
dq5b = dq5b[complete.cases(dq5b),]

fit.q5b = brm(Q5b ~ Age2 + Gender + Village_recoded + education_index,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq5b, chains = chains, iter = iter, file = "./results/models/q5b",
              seed = seed)

# summary(fit.q5b)

# Q5c: Who is F to you? ----
dq5c = data[,c("Q5c", "Age2", "Gender", "Village_recoded", "education_index")]
dq5c = dq5c[complete.cases(dq5c),]

fit.q5c = brm(Q5c ~ Age2 + Gender + Village_recoded + education_index,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq5c, chains = chains, iter = iter, file = "./results/models/q5c",
              seed = seed)

# summary(fit.q5c)

# Q5d: Who is B to you? ----
dq5d = data[,c("Q5d", "Age2", "Gender", "Village_recoded", "education_index")]
dq5d = dq5d[complete.cases(dq5d),]

fit.q5d = brm(Q5d ~ Age2  + Gender + Village_recoded + education_index,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq5d, chains = chains, iter = iter, file = "./results/models/q5d",
              seed = seed)

### Aggregate Binomial model

data$Q5_right     =  rowSums(data[,paste0("Q5", letters[1:15])], na.rm = TRUE)
data$Q5_answered  = rowSums(!is.na(data[,paste0("Q5", letters[1:15])]))
data$Q5_aggregate = data$Q5_right / data$Q5_answered

dq5Agg = data[,c("Q5_right", "Q5_answered", "Age2", "Gender", "Village_recoded", "education_index")]
dq5Agg = dq5Agg[complete.cases(dq5Agg),]
dq5Agg = dq5Agg[dq5Agg$Q5_answered > 0,] # must have answer min 1 questions

fit.q5Agg = brm(data = dq5Agg, family = binomial,
    Q5_right | trials(Q5_answered) ~ Age2 + Gender + Village_recoded + education_index,
    prior = c(prior(normal(0, 10), class = Intercept),
              prior(normal(0, 10), class = b)),
    iter = 2500, warmup = 500, cores = 2, chains = 2, file = "./results/models/q5dAgg",
    seed = seed)

#summary(fit.q5Agg)
