library(dplyr)
library(rethinking)
library(ggridges)
library(purrr)
library(reshape2)
library(ggplot2)
library(patchwork)

# constants
right = 0.75

## first get the data
data = read.csv('data/merged_data.csv', na.strings = c("?", "NA"))

# Barchart of Questions 1 - 4
q_data = data %>% 
  filter(Village != "Magugu") %>% 
  select(Village, Q1, Q2, Q3, Q4) %>% 
  melt() %>% 
  group_by(variable, Village) %>% 
  summarise(correct = sum(value, na.rm = TRUE),
            prop_correct = correct / n())

p1 = ggplot(data=q_data, aes(x=variable, y=correct, fill = Village)) +
  geom_bar(stat="identity", position=position_dodge()) + 
  xlab("") + ylab("Count") + 
  ggtitle("Count and Proportion of correct answers", "By Village") + 
  theme_minimal(base_size = 18)

p2 = ggplot(data=q_data, aes(x=variable, y=prop_correct, fill = Village)) +
  geom_bar(stat="identity", position=position_dodge()) + 
  xlab("") + ylab("Proportion") + 
  theme_minimal(base_size = 18)

p = p1 / p2 + plot_layout(guides = "collect")

ggsave(plot = p, filename = "figures/q1_4_barplot.png")

# Question 1
d1 = data[!is.na(data[,"Q1"]),]
d1$Age3 = scale(d1$Age2)
d1$Education_bin = ifelse(d1$Education == "none", 1, 2)
d1$Village_idx = ifelse(d1$Village_recoded == "Eshkesh", 1,
                        ifelse(d1$Village_recoded == "Garawja", 2, 3))

fit.1 = quap(
  alist(
    Q1 ~ dbinom(1, p),
    logit(p) <- a[Village_idx] + ba*Age3 + be[Education_bin],
    a[Village_idx] ~ dnorm(0, 0.5),
    ba ~ dnorm(0.2, 1.5),
    be[Education_bin] ~ dnorm(0, 0.5)
  ),
  data = d1
)

prior <- extract.prior(fit.1, n=1e4 )
p <- sapply( 1:2 , function(k) inv_logit( prior$a[,1] + prior$ba + prior$be[,k] ) )
dens( abs( p[,1] - p[,2] ) , adj=0.1 )
mean( abs( p[,1] - p[,2] ) ) # average prior difference between allocentric can and can'ts

precis(fit.1, depth = 2)

d1$evid = paste0(d1$Education, d1$Village_recoded) %>% 
  as.factor() %>% as.numeric()

fit.1.3 = quap(
  alist(
    Q1 ~ dbinom(1, p),
    logit(p) <- a[evid] + ba*Age3,
    a[evid] ~ dnorm(0, 0.5),
    ba ~ dnorm(0.2, 1.5)
  ),
  data = d1
)

precis(fit.1.3, depth = 2)

compare(fit.1, fit.1.3)

post = extract.samples(fit.1)
mu = attr(d1$Age3, "scaled:center")
sigma = attr(d1$Age3, "scaled:scale")
correct75.1 = ((log(right/(1-right)) - (post$a[,3] + post$be[,1]))/post$ba) * sigma + mu # 3 is Getanyamba
correct75.2 = ((log(right/(1-right)) - (post$a[,3] + post$be[,2]))/post$ba) * sigma + mu 
#correct75.3 = ((log(right/(1-right)) - post$a[,3] + post$be[,1])/post$ba) * sigma + mu 

summary(correct75.1)
summary(correct75.2)

qs = c("No Schooling", "Some Schooling")
correct_75 = list(correct75.1, correct75.2)

c75 = data.frame(age = do.call(c, correct_75), question = rep(qs, each = 10000))
c75$question = factor(c75$question, levels = rev(qs))
c75_means = c75 %>% group_by(question) %>% 
  summarise(mean_age = round(median(age), 2))

pdf('results/q1-schooling.pdf' , width = 4, height = 3)
ggplot(c75, aes(x = age, y = question, fill = ..x..)) +
  geom_density_ridges_gradient(scale = 0.9) + 
  geom_text(data = c75_means, aes(label = c75_means$mean_age, y = question, x = 3), cex = 6) + 
  xlim(0, 20) + 
  ylab("Q1: F (Getanyamba)") +
  theme_ridges(font_size = 13, grid = TRUE) +
  theme(legend.position = 'none') 
dev.off()


## Q4 & schooling
d4 = data[!is.na(data[,"Q4"]),]
d4$Age3 = scale(d4$Age2)
d4$Education_bin = ifelse(d4$Education == "none", 1, 2)
d4$Village_idx = ifelse(d4$Village_recoded == "Eshkesh", 1,
                        ifelse(d4$Village_recoded == "Garawja", 2, 3))


fit.4.1 = quap(
  alist(
    Q4 ~ dbinom(1, p),
    logit(p) <- a[Village_idx] + ba*Age3 + be[Education_bin],
    a[Village_idx] ~ dnorm(0, 0.5),
    ba ~ dnorm(0.2, 1.5),
    be[Education_bin] ~ dnorm(0, 0.5)
  ),
  data = d4
)

precis(fit.4.1, depth = 2)

post = extract.samples(fit.4.1)
mu = attr(d4$Age3, "scaled:center")
sigma = attr(d4$Age3, "scaled:scale")
correct75.1 = ((log(right/(1-right)) - (post$a[,3] + post$be[,1]))/post$ba) * sigma + mu # 3 is Getanyamba
correct75.2 = ((log(right/(1-right)) - (post$a[,3] + post$be[,2]))/post$ba) * sigma + mu 
#correct75.3 = ((log(right/(1-right)) - post$a[,3] + post$be[,1])/post$ba) * sigma + mu 

summary(correct75.1)
summary(correct75.2)

qs = c("No Schooling", "Some Schooling")
correct_75 = list(correct75.1, correct75.2)

c75 = data.frame(age = do.call(c, correct_75), question = rep(qs, each = 10000))
c75$question = factor(c75$question, levels = rev(qs))
c75_means = c75 %>% group_by(question) %>% 
  summarise(mean_age = round(median(age), 2))

pdf('results/q4-education.pdf', width = 4, height = 3)
ggplot(c75, aes(x = age, y = question, fill = ..x..)) +
  geom_density_ridges_gradient(scale = 0.9) + 
  geom_text(data = c75_means, aes(label = c75_means$mean_age, y = question, x = 3), cex = 6) + 
  xlim(0, 20) + 
  ylab("Q4: Clan (Getanyamba)") +
  theme_ridges(font_size = 13, grid = TRUE) +
  theme(legend.position = 'none') 
dev.off()