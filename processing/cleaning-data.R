#!/usr/bin/env Rscript

suppressPackageStartupMessages({
    library(readxl)
    library(dplyr)
})

### Read Data ###
NA_STRINGS = c("n/a", "?")

results = read_xlsx('data/kinship_interview_data.xlsx', sheet = "Results",  range = "A1:AE66",
                    na = NA_STRINGS)

# remove tallies from the bottom of the sheet
tail(results$`Child ID`, 1) == 65

# get children data
children = read_xlsx('data/kinship_interview_data.xlsx', sheet = "Metadata", range = "A1:O66",
                     na = NA_STRINGS)

cat("Is the last row what I expect? ", tail(children, 1)$Name == "Hirjeaw", "\n")

# childId needs to be a factor
results$`Child ID` = factor(results$`Child ID`)
    children$`Child ID` = factor(children$`Child ID`)

# merge children and results
data = left_join(x = results, y = children, by = "Child ID")

# add genealogical data
genealogical = read_xlsx('data/kinship_interview_data.xlsx', sheet = "Genealogical data", skip = 7,
                         range = "A8:F73", na = NA_STRINGS)

cat("Is there the expected number of data points? ", tail(genealogical,1)$"Child ID" == 65, "\n")

genealogical$`Child ID` = factor(genealogical$`Child ID`)

data = left_join(data, genealogical, by = "Child ID")
data$keepQ1 = ifelse(data$`Q1: Kinship category relative to child` == "F", 1, 0)

# 51 individuals answer F for Q1 and we will use these for analysis in Q1,2 & 3
cat("Expected number answer F to Q1? ", sum(data$keepQ1, na.rm = TRUE) == 51, "\n")

# save data
write.csv(data, 'data/merged_data.csv')
