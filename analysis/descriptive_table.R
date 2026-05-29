## descriptive table

library(dplyr)

d = read.csv("data/merged_data_wIndex.csv")

d %>% 
  group_by(Village, Gender) %>% 
  summarise(n = n())

d %>% 
  mutate(Age3 = cut(Age2, breaks = c(0, 4.9166667, 7.5, 9.9166667, Inf))) %>% 
  group_by(Village, Age3) %>% 
  summarise(n = n())

d %>% 
  group_by(Village, education_index) %>% 
  summarise(n = n())
