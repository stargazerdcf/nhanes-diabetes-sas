# Data Dictionary
## NHANES Diabetes Prevalence Analysis
### CDC NHANES 2017-2020 Pre-Pandemic Cycle

---

## Source Datasets

| File | Description | Observations |
|---|---|---|
| P_DEMO.xpt | Demographics | 15,560 |
| P_DIQ.xpt | Diabetes Questionnaire | 14,986 |
| P_BMX.xpt | Body Measures | 14,300 |
| analysis_raw | Merged dataset (adults only) | 15,560 |
| analysis_clean | Final analytic dataset | 9,421 |

---

## Variable Dictionary

### Identifier Variable

| Variable | Source File | Type | Description |
|---|---|---|---|
| SEQN | All files | Numeric | Unique respondent sequence number. Primary key used to merge all three datasets. |

---

### Demographic Variables (from P_DEMO)

| Variable | Type | Values | Description |
|---|---|---|---|
| RIDAGEYR | Numeric | 0–85 | Age in years at time of survey. Capped at 85 by CDC. Analysis restricted to adults 18+. |
| RIAGENDR | Numeric | 1=Male, 2=Female | Biological sex of participant. |
| RIDRETH3 | Numeric | 1=Mexican American, 2=Other Hispanic, 3=Non-Hispanic White, 4=Non-Hispanic Black, 6=Non-Hispanic Asian, 7=Other/Multiracial | Race and ethnicity classification. Note: code 5 not used in this cycle. |
| INDFMPIR | Numeric | 0.00–5.00 | Poverty-Income Ratio. Ratio of family income to federal poverty threshold. Values above 5.00 are capped at 5.00. Higher values indicate higher income. |

---

### Survey Design Variables (from P_DEMO)

| Variable | Type | Description |
|---|---|---|
| WTMECPRP | Numeric | Full sample MEC exam weight. Used in all SURVEY procedures to produce nationally representative estimates. **Note:** This variable is named `WTMEC2YR` in earlier NHANES cycles — the name changed in the 2017-2020 pre-pandemic cycle. Always verify the weight variable name for your specific cycle. |
| SDMVPSU | Numeric | Masked variance pseudo-PSU (Primary Sampling Unit). Required for variance estimation in all SURVEY procedures. |
| SDMVSTRA | Numeric | Masked variance pseudo-stratum. Required for variance estimation in all SURVEY procedures. |

---

### Diabetes Variable (from P_DIQ)

| Variable | Type | Raw Values | Description |
|---|---|---|---|
| DIQ010 | Numeric | 1=Yes, 2=No, 3=Borderline, 7=Refused, 9=Don't know | Doctor told you have diabetes. This is the raw CDC variable. |

---

### Body Measures Variable (from P_BMX)

| Variable | Type | Values | Description |
|---|---|---|---|
| BMXBMI | Numeric | Continuous | Body Mass Index (kg/m²). Calculated from measured height and weight during physical examination. |

---

### Derived Variables (created in 02_clean.sas)

| Variable | Type | Values | Description | Source Variable |
|---|---|---|---|---|
| diabetes | Numeric | 0=Non-Diabetic, 1=Diabetic, .=Missing | Binary diabetes outcome variable recoded from DIQ010. Borderline (3), Refused (7), and Don't Know (9) assigned missing and excluded from analysis. | DIQ010 |
| bmi_cat | Numeric | 1=Underweight (<18.5), 2=Normal (18.5-24.9), 3=Overweight (25-29.9), 4=Obese (>=30) | BMI category based on standard WHO classification. | BMXBMI |
| age_group | Numeric | 1=18-39, 2=40-59, 3=60+ | Age group category created for descriptive purposes. | RIDAGEYR |

---

## Analytic Sample Construction

| Step | N | Notes |
|---|---|---|
| P_DEMO (starting sample) | 15,560 | All survey participants |
| After merge (IF inDemo) | 15,560 | Retained all DEMO participants |
| After restricting to adults 18+ | ~13,000 | Approximate |
| After excluding missing/borderline diabetes | 9,421 | Final analytic sample |
| After excluding zero survey weights | 8,709 | Used in weighted analyses |

---

## Notes on Survey Weighting
NHANES uses a complex multistage probability sampling design. Certain 
subgroups (older adults, racial/ethnic minorities) are intentionally 
oversampled to improve precision of estimates for those groups. Survey 
weights (`WTMECPRP`) correct for unequal selection probabilities so that 
results represent the civilian non-institutionalized U.S. adult population.

Unweighted counts (N=9,421) reflect the actual sample. Weighted estimates 
reflect the U.S. population (approximately 241 million adults).

---

*Data dictionary prepared by Donna Chandler-Ferguson, 2026*
*CDC NHANES documentation available at: https://wwwn.cdc.gov/nchs/nhanes*
