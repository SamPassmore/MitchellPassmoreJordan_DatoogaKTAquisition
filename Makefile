
.PHONY: help all clean_data models plots tables

help:
	@echo "1. make clean_data  – create merged data files"
	@echo "2. make models      – run all Bayesian models (saves .rds to results/models/)"
	@echo "3. make plots       – generate all figures"
	@echo "4. make tables      – generate coefficient tables"
	@echo "5. make all         – run full pipeline in order"
	@echo "X. make clean       – remove all generated files"

all: clean_data models plots tables

clean: 
	rm -f data/merged_data.csv
	rm -f results/models/*.rds
	rm -f Rplots.pdf

## ── Data ──────────────────────────────────────────────────────────────────────

data/merged_data.csv: processing/cleaning-data.R
	@echo Creating merged data files
	Rscript processing/cleaning-data.R

clean_data: data/merged_data.csv

## ── Models ────────────────────────────────────────────────────────────────────
# brms saves fitted models to results/models/*.rds.
# If the .rds file already exists, subsequent runs load the cache instead of re-fitting.

# Section 3: genealogical knowledge (Q2/Q3/Q4) — full predictor models
# Outputs: results/models/q2.rds, results/models/q3.rds, results/models/q4.rds
results/models/q2.rds results/models/q3.rds results/models/q4.rds: \
    analysis/s3.R data/merged_data.csv
	@echo Running section 3 full models
	@mkdir -p results/models
	Rscript analysis/s3.R

# Section 3: age-only baseline models for Q2/Q3/Q4 and Q5a-d
# Outputs: results/models/q2a.rds, results/models/q3a.rds, results/models/q4a.rds,
#          results/models/q5aa.rds, results/models/q5ba.rds, results/models/q5ca.rds,
#          results/models/q5da.rds
results/models/q2a.rds results/models/q3a.rds results/models/q4a.rds \
results/models/q5aa.rds results/models/q5ba.rds results/models/q5ca.rds \
results/models/q5da.rds: analysis/s3a.R data/merged_data.csv
	@echo Running section 3 age-only models
	@mkdir -p results/models
	Rscript analysis/s3a.R

# Section 5: kin term recognition (Q5a-d) — full predictor models and aggregate
# Outputs: results/models/q5a.rds, results/models/q5b.rds, results/models/q5c.rds,
#          results/models/q5d.rds, results/models/q5dAgg.rds
results/models/q5a.rds results/models/q5b.rds results/models/q5c.rds \
results/models/q5d.rds results/models/q5dAgg.rds: analysis/s5.R data/merged_data.csv
	@echo Running section 5 models
	@mkdir -p results/models
	Rscript analysis/s5.R

# Sections 6+7: allocentric questions (Q6/Q8) and reversal section (Q9/Q10)
# Outputs: results/models/q6.rds, results/models/q6a.rds,
#          results/models/q8.rds, results/models/q8a.rds, results/models/q8b.rds,
#          results/models/q9.rds, results/models/q9a.rds,
#          results/models/q10.rds, results/models/q10a.rds
results/models/q6.rds results/models/q6a.rds \
results/models/q8.rds results/models/q8a.rds results/models/q8b.rds \
results/models/q9.rds results/models/q9a.rds \
results/models/q10.rds results/models/q10a.rds: analysis/s6+7.R data/merged_data.csv
	@echo Running section 6 and 7 models
	@mkdir -p results/models
	Rscript 'analysis/s6+7.R'

models: \
    results/models/q2.rds results/models/q3.rds results/models/q4.rds \
    results/models/q2a.rds results/models/q3a.rds results/models/q4a.rds \
    results/models/q5aa.rds results/models/q5ba.rds results/models/q5ca.rds results/models/q5da.rds \
    results/models/q5a.rds results/models/q5b.rds results/models/q5c.rds \
    results/models/q5d.rds results/models/q5dAgg.rds \
    results/models/q6.rds results/models/q6a.rds \
    results/models/q8.rds results/models/q8a.rds results/models/q8b.rds \
    results/models/q9.rds results/models/q9a.rds \
    results/models/q10.rds results/models/q10a.rds


## ── Plots ─────────────────────────────────────────────────────────────────────

# Education and schooling effects on Q1 and Q4
# Outputs: figures/q1_4_barplot.png  – count & proportion barplot (Q1-Q4 by village)
#          results/q1-schooling.pdf   – age at 75% correct for Q1 by schooling group
#          results/q4-education.pdf   – age at 75% correct for Q4 by education group
figures/q1_4_barplot.png results/q1-schooling.pdf results/q4-education.pdf: \
    analysis/q1+4-educationeffect.R data/merged_data.csv
	@echo Running education effect analysis
	Rscript 'analysis/q1+4-educationeffect.R'

# Main manuscript figures
# Outputs: figures/descriptive_statistics.pdf  – beeswarm participant plot
#          figures/correct75_allq.png          – ridgeline: age at 75% correct (all Qs, Figure 4)
#          figures/s3_plot.pdf                 – Q2/Q3/Q4 cumulative probability by village
#          figures/s4_plot.pdf                 – kin salience rank barplot (Father/Mother)
#          figures/s5_plot.pdf                 – Q5a-d cumulative probability curves
figures/descriptive_statistics.pdf figures/correct75_allq.png \
figures/s3_plot.pdf figures/s4_plot.pdf figures/s5_plot.pdf: \
    figures/ms_figures.R data/merged_data.csv data/Q5_kin_category_list_order_recodedSP.xlsx \
    results/models/q2a.rds results/models/q3a.rds results/models/q4a.rds \
    results/models/q5aa.rds results/models/q5ba.rds results/models/q5ca.rds results/models/q5da.rds \
    results/models/q5a.rds results/models/q5b.rds results/models/q5c.rds \
    results/models/q5d.rds results/models/q5dAgg.rds \
    results/models/q6.rds results/models/q6a.rds \
    results/models/q8.rds results/models/q8a.rds results/models/q9.rds
	@echo Making figures
	Rscript figures/ms_figures.R

plots: \
    figures/q1_4_barplot.png results/q1-schooling.pdf results/q4-education.pdf \
    figures/descriptive_statistics.pdf figures/correct75_allq.png \
    figures/s3_plot.pdf figures/s4_plot.pdf figures/s5_plot.pdf


## ── Tables ────────────────────────────────────────────────────────────────────

# Table 1: participant demographics (gender, age, schooling counts by village)
# Source: analysis/descriptive_table.R (prints to console)
.PHONY: table1
table1: analysis/descriptive_table.R data/merged_data_wIndex.csv
	@echo Generating Table 1 descriptive statistics
	Rscript analysis/descriptive_table.R

# Outputs: results/s3_table.csv   – Q2/Q3/Q4 coefficients (Table 2 in paper)
#          results/s5_table.csv   – Q5a-d + aggregate coefficients
#          results/s67_table.csv  – Q6/Q8 allocentric models with/without reversal (Table 3)
results/s3_table.csv results/s5_table.csv results/s67_table.csv: \
    figures/ms_tables.R \
    results/models/q2.rds results/models/q3.rds results/models/q4.rds \
    results/models/q5a.rds results/models/q5b.rds results/models/q5c.rds \
    results/models/q5d.rds results/models/q5dAgg.rds \
    results/models/q6a.rds results/models/q8a.rds results/models/q8b.rds
	@echo Making tables
	Rscript figures/ms_tables.R

tables: table1 results/s3_table.csv results/s5_table.csv results/s67_table.csv
