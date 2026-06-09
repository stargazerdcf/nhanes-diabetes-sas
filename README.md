# NHANES Diabetes Prevalence Analysis
### Survey-Weighted Analysis Using SAS | CDC NHANES 2017-2020

## Project Overview
This project analyzes the prevalence of diagnosed diabetes among U.S. adults 
using data from the CDC National Health and Nutrition Examination Survey (NHANES) 
2017-2020 pre-pandemic cycle. The analysis applies complex survey weighting methods 
to produce nationally representative estimates, and uses logistic regression to 
identify independent risk factors for diabetes.

This project was completed as part of a healthcare analytics portfolio to 
demonstrate proficiency in SAS, survey-weighted statistical methods, and 
epidemiological data analysis.

## Data Source
- **Survey:** CDC NHANES 2017-2020 Pre-Pandemic Cycle
- **Files Used:**
  - `P_DEMO.xpt` — Demographics (age, sex, race/ethnicity, income, survey weights)
  - `P_DIQ.xpt` — Diabetes questionnaire (diagnosis status)
  - `P_BMX.xpt` — Body measures (BMI)
- **Final analytic sample:** 9,421 adults aged 18 and older

## Methods
- Complex survey design accounted for using `PROC SURVEYFREQ`, 
  `PROC SURVEYMEANS`, and `PROC SURVEYLOGISTIC`
- Survey weight variable: `WTMECPRP` (specific to the 2017-2020 pre-pandemic cycle)
- Diabetes defined as self-reported physician diagnosis (DIQ010=1)
- Borderline cases and refusals excluded from analysis
- Logistic regression models include unadjusted and multivariable-adjusted 
  odds ratios controlling for sex, race/ethnicity, BMI category, age, 
  and poverty-income ratio

## Key Findings
- **11.6%** of U.S. adults had diagnosed diabetes (95% CI: 10.8%–12.3%)
- Males had higher odds of diabetes than females (OR=1.64, 95% CI: 1.25–2.15)
- Non-Hispanic Asian adults had the highest adjusted odds of diabetes compared 
  to Non-Hispanic White adults (OR=2.38, 95% CI: 1.63–3.48)
- Obese adults had nearly **5 times the odds** of diabetes compared to 
  normal-weight adults (OR=4.98, 95% CI: 3.72–6.66)
- Each additional year of age was associated with a 6.4% increase in 
  the odds of diabetes (OR=1.064 per year)
- Higher income was protective against diabetes (OR=0.896 per unit increase 
  in poverty-income ratio)

## Repository Structure
nhanes-diabetes-sas/
01_import.sas        # Library setup and XPT file import
02_clean.sas         # Data merging, recoding, and cleaning
03_analysis.sas      # Survey-weighted descriptive and regression analysis
04_output.sas        # ODS export of formatted results tables
results/
Results_Tables.rtf   # Formatted output tables (Word-compatible)
README.md

## Tools & Environment
- **SAS OnDemand for Academics** (cloud-based, free)
- **SAS Studio** (browser-based IDE)
- **CDC NHANES 2017-2020 data** (publicly available, XPT format)

## Methodology Note
This project was completed using an **AI-assisted development workflow**. 
SAS code was developed collaboratively with Claude (Anthropic) as an AI 
coding assistant. All analytical decisions, interpretation of results, 
and quality control were performed by the analyst. This workflow reflects 
modern data science practice where AI tools accelerate code development 
while human expertise drives analytical judgment.

## Author
**Donna Chandler-Ferguson**
Healthcare Data Analyst | SAS | MySQL | Power BI | GitHub
Transitioning from 20+ years in FDA-regulated preclinical research into 
healthcare analytics and data governance roles.
