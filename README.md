# Children's acquisition of Kin terms (or other title)

Code for the study of kinship knowledge acquisition in Datooga children across three villages. Children (n = 65) were asked a series of questions testing genealogical knowledge, kin-term recognition, allocentric kinship reasoning, and perspective reversal.

## Data Availability

The data used for this project is currently held privately. Please contact Alice Mitchell for access to the data. 

---

## Reproducing the analysis

```
make all
```

Or step by step:

```
make clean_data   # 1. process raw data
make models       # 2. fit all Bayesian models
make plots        # 3. generate all figures
make tables       # 4. generate all tables
```

Individual steps can be re-run in isolation. brms models are cached as `.rds` files in `results/models/` so re-running a script that finds an existing cache will not refit the model.

---

## Directory structure

```
processing/
  cleaning-data.R      reads the Excel sheets, merges them, writes data/merged_data.csv

analysis/
  descriptive_table.R        Table 1 — participant demographics by village (prints to console)
  s3.R                       Section 3 — full models for genealogical questions Q2, Q3, Q4
  s3a.R                      Section 3 — age-only baseline models for Q2-Q4 and Q5a-d
  s5.R                       Section 5 — kin-term recognition models for Q5a-d and aggregate
  s6+7.R                     Sections 6-7 — allocentric (Q6, Q8) and reversal (Q9, Q10) models
  q1+4-educationeffect.R     Education/schooling effect analysis for Q1 and Q4

figures/
  ms_figures.R        generates all manuscript figures
  ms_tables.R         generates coefficient tables (Tables 2-3) as CSV files

results/
  models/             cached brms model fits (*.rds)
  s3_table.csv        Table 2 — Q2/Q3/Q4 coefficient estimates
  s5_table.csv        Q5a-d and aggregate coefficient estimates
  s67_table.csv       Table 3 — Q6/Q8 allocentric models with/without reversal predictor
  q1-schooling.pdf    age-at-75%-correct ridgeline for Q1 by schooling group
  q4-education.pdf    age-at-75%-correct ridgeline for Q4 by education group

figures/ (saved outputs)
  descriptive_statistics.pdf   beeswarm plot of participants by village, age, gender
  correct75_allq.png           ridgeline: posterior age at 75% correct across all questions
  s3_plot.pdf                  cumulative probability curves for Q2/Q3/Q4 by village
  s4_plot.pdf                  kin salience rank barplot (Father/Mother, boys vs girls)
  s5_plot.pdf                  cumulative probability curves for Q5a-d
  q1_4_barplot.png             count and proportion correct for Q1-Q4 by village
```

---

## Questions

| Question | Content | Script |
|---|---|---|
| Q1 | Is [person] Mother or Father relative to child? | s3.R (keepQ1 filter) |
| Q2 | Who is the Father of Father (FF)? | s3.R, s3a.R |
| Q3 | Who is the Father of Father's Father (FFF)? | s3.R, s3a.R |
| Q4 | Which clan does [person] belong to? | s3.R, s3a.R |
| Q5a-d | Who is Mother / Father / Brother / Sister to you? | s5.R, s3a.R |
| Q6 | Who is Mother to Father? (allocentric) | s6+7.R |
| Q8 | Who is Father to Brother/Sister? (allocentric) | s6+7.R |
| Q9 | Who are you to Mother? (reversal) | s6+7.R |
| Q10 | Who is the Father of your Father? | s6+7.R |
| Q14 | Can child reverse kinship terms? (covariate) | s6+7.R |

Q2-Q4 models are restricted to children who answered Q1 correctly (`keepQ1 == 1`, n = 51) due to inconsistencies in question administration.

---

## Dependencies

R packages required:

- **brms** — Bayesian regression models (all sections)
- **rethinking** — quap models (q1+4-educationeffect.R)
- **dplyr**, **tidyr** — data manipulation
- **ggplot2**, **ggridges**, **patchwork** — figures
- **ggbeeswarm** — descriptive statistics plot
- **lemon**, **cowplot** — figure layout utilities
- **readxl** — reading Excel data
- **bayesplot** — MCMC diagnostics
- **reshape2** — data reshaping

Install with:

```r
install.packages(c("brms", "dplyr", "tidyr", "ggplot2", "ggridges",
                   "patchwork", "ggbeeswarm", "lemon", "cowplot",
                   "readxl", "bayesplot", "reshape2"))
# rethinking requires separate installation:
# https://github.com/rmcelreath/rethinking
```
