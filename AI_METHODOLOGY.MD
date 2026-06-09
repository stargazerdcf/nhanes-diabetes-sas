# AI-Assisted Development Methodology

## Overview
This project was completed using a collaborative AI-assisted workflow. 
SAS code was developed with Claude (Anthropic) as an AI coding assistant 
throughout the six-week project timeline.

---

## How AI Was Used

### Code Development
- SAS syntax generation for PROC SURVEYFREQ, PROC SURVEYMEANS, 
  and PROC SURVEYLOGISTIC
- Debugging assistance when errors occurred in SAS Studio
- Code organization and professional commenting standards

### Conceptual Guidance
- Explanation of survey weighting concepts and why they matter for NHANES
- Interpretation of odds ratios and confidence intervals
- Guidance on epidemiological best practices (unadjusted vs adjusted models)
- Discussion of data dictionary standards and documentation practices

### Problem Solving
- Identifying that WTMEC2YR was renamed to WTMECPRP in the 2017-2020 
  pre-pandemic cycle
- Resolving SAS-specific issues such as format-dependent REF= and EVENT= 
  values in PROC SURVEYLOGISTIC
- Troubleshooting ODS output options specific to PROC SURVEYFREQ

---

## What AI Did NOT Do

- **All analytical decisions** were made by the analyst, including variable 
  selection, model specification, and interpretation of findings
- **All quality control** was performed by the analyst, including verification 
  of variable names, observation counts, and output review
- **All real-world problem solving** — identifying the correct file paths, 
  recognizing renamed variables, and catching unexpected output — was 
  performed by the analyst
- **Domain knowledge** about clinical research, data governance, and 
  healthcare analytics was provided by the analyst

---

## Why Document This?

Transparent documentation of AI tool usage reflects:

1. **Professional integrity** — honest representation of the development process
2. **Modern practice** — AI-assisted development is an emerging and valued 
   skill in data analytics roles
3. **Reproducibility** — future users of this code understand how it was 
   developed and validated

The analyst directed, questioned, and validated all AI outputs throughout 
this project. The ability to effectively leverage AI tools while maintaining 
analytical oversight and judgment is itself a professional competency.

---

## Tools Used
- **SAS OnDemand for Academics** — analysis environment
- **SAS Studio** — browser-based IDE
- **Claude (Anthropic)** — AI coding assistant
- **CDC NHANES** — public data source
- **GitHub** — version control and portfolio publishing

---

*Donna Chandler-Ferguson, 2026*
