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

## recode eduction
data$education_index = ifelse(data$Education == "none", 1, 
                              ifelse(data$Education == "nursery", 2, 3)) %>% 
  as.factor(.)

#### Parameters #### 
chains = 2
iter = 3000
max_iter = 100

# Q2: Who is the father of [person named in Q1] ----
## get complete data set
cat("Running model for Q2.... \n\n")

dq2 = data[,c("Q2", "Age2", "Gender", "Village_recoded", "education_index")]
dq2 = dq2[complete.cases(dq2),]

fit.q2 = brm(Q2 ~ Age2 + Gender + Village_recoded + education_index,
             family = bernoulli(link = "logit"),
             prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                       set_prior(prior = "normal(0,5)", class = "b")),
             data = dq2, chains = chains, iter = iter, file = "./results/models/q2",
             seed = seed)

# summary(fit.q2)


# Q3: Who is the father of [person named in Q2] ----
cat("Running model for Q3.... \n\n")

dq3 = data[,c("Q3", "Age2", "Gender", "Village_recoded", "education_index")]
dq3 = dq3[complete.cases(dq3),]

fit.q3 = brm(Q3 ~ Age2 + Gender + Village_recoded + education_index,
             family = bernoulli(link = "logit"),
             prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                       set_prior(prior = "normal(0,5)", class = "b")),
             data = dq3, chains = chains, iter = iter, file = "./results/models/q3",
             seed = seed)

# summary(fit.q3)

# Q4: Which clan does [person named in Q3] belong to ----
cat("Running model for Q4.... \n\n")


dq4 = data[,c("Q4", "Age2", "Gender", "Village_recoded", "education_index")]
dq4 = dq4[complete.cases(dq4),]

fit.q4 = brm(Q4 ~ Age2 + Gender + Village_recoded + education_index,
             family = bernoulli(link = "logit"),
             prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                       set_prior(prior = "normal(0,5)", class = "b")),
             data = dq4, chains = chains, iter = iter, file = "./results/models/q4",
             seed = seed)

# summary(fit.q4)
