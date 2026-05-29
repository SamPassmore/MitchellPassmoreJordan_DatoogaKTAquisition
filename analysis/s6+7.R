library(dplyr)
library(brms)

seed = 34245

## first get the data
data = read.csv('data/merged_data.csv', na.strings = c("?", "NA"))

## Table of the data to model
table(data$Q6)
table(data$Q8, data$Q14)

## recode eduction
data$education_index = ifelse(data$Education == "none",
                              1,
                              ifelse(data$Education == "nursery", 2, 3)) %>%
  as.factor(.)

#### Parameters #### 
chains = 2
iter = 5000
max_iter = 100

#### Q6: Who is M to F? ####
## get complete data set
cat("Running model for Q6.... \n\n")

dq6 = data[,c("Q6", "Age2", "Gender", "Village_recoded", "education_index", "Q14")]
dq6 = dq6[complete.cases(dq6),]
dim(dq6)

fit.q6 = brm(Q6 ~ Age2,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq6, chains = chains, iter = iter, file = "./results/models/q6",
              seed = seed, save_all_pars = TRUE)


fit.q6a = brm(Q6 ~ Age2 + Gender + Village_recoded + education_index,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq6, chains = chains, iter = iter, file = "./results/models/q6a",
              seed = seed, save_all_pars = TRUE)
summary(fit.q6a)

#### Q8: Who is F to B/Z? ####
cat("Running model for Q8.... \n\n")

table(data$Q8, useNA = "always")

dq8 = data[,c("Q8", "Age2", "Gender", "Village_recoded", "education_index", "Q14")]
dq8 = dq8[complete.cases(dq8),]
dim(dq8)

fit.q8 = brm(Q8 ~ Age2,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq8, chains = chains, iter = iter, file = "./results/models/q8",
              seed = seed, save_all_pars = TRUE)

fit.q8a = brm(Q8 ~ Age2 + Gender + Village_recoded + education_index,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq8, chains = chains, iter = iter, file = "./results/models/q8a",
              seed = seed, save_all_pars = TRUE)

summary(fit.q8a)

fit.q8b = brm(Q8 ~ Age2 + Gender + Village_recoded + education_index + Q14,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq8, chains = chains, iter = iter, file = "./results/models/q8b",
              seed = seed, save_all_pars = TRUE)
summary(fit.q8b)

#### Q9: Who are you to Mother ####
## This question for the Reversal Section (section 7)

table(data$Q9, useNA = "always")

dq9 = data[,c("Q9", "Age2", "Gender", "Village_recoded", "education_index")]
dq9 = dq9[complete.cases(dq9),]
dim(dq9)

fit.q9 = brm(Q9 ~ Age2,
             family = bernoulli(link = "logit"),
             prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                       set_prior(prior = "normal(0,5)", class = "b")),
             data = dq9, chains = chains, iter = iter, file = "./results/models/q9",
             seed = seed, save_all_pars = TRUE)
summary(fit.q9)

fit.q9a = brm(Q9 ~ Age2 + Gender + Village_recoded + education_index,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq9, chains = chains, iter = iter, file = "./results/models/q9a",
              seed = seed, save_all_pars = TRUE)
summary(fit.q9a)


#### Q10: Who is the father of your father? ####

table(data$Q10, useNA = "always")

dq10 = data[,c("Q10", "Age2", "Gender", "Village_recoded", "education_index", "Q14")]
dq10 = dq10[complete.cases(dq10),]
dim(dq10)

fit.q10 = brm(Q10 ~ Age2 + Gender + Village_recoded + education_index + Q14,
             family = bernoulli(link = "logit"),
             prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                       set_prior(prior = "normal(0,5)", class = "b")),
             data = dq10, chains = chains, iter = iter, file = "./results/models/q10",
             seed = seed, save_all_pars = TRUE)
summary(fit.q10)

fit.q10a = brm(Q10 ~ Age2,
              family = bernoulli(link = "logit"),
              prior = c(set_prior(prior = "normal(0,5)", class = "Intercept"),
                        set_prior(prior = "normal(0,5)", class = "b")),
              data = dq10, chains = chains, iter = iter, file = "./results/models/q10a",
              seed = seed, save_all_pars = TRUE)
summary(fit.q10a)

#### Q12: Are you an aunt/uncle ####

# Not enough answers 
table(data$Q12, useNA = "always")
