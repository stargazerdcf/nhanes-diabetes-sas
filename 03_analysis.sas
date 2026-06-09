/* ============================================================
   Project:  NHANES Diabetes Prevalence Analysis
   Author:   Donna Chandler-Ferguson
   Date:     2026
   Purpose:  Survey-weighted descriptive analysis of diabetes
             prevalence across demographic and clinical subgroups.
   Input:    nhanes.analysis_clean (~9,421 adult participants)
   Output:   Weighted prevalence tables (Tables 1-5)
   Note:     AI-assisted development workflow used throughout
             this project. See README.md for methodology details.
   ============================================================ */


/* --- Section 1: Library and Format Setup --- */

/* Formats must be redefined each session */
LIBNAME nhanes '/home/u664441/sasuser.v94/NHANESDiabetes';

PROC FORMAT;
  VALUE diabfmt  1 = 'Diabetic'
                 0 = 'Non-Diabetic';

  VALUE sexfmt   1 = 'Male'
                 2 = 'Female';

  VALUE racefmt  1 = 'Mexican American'
                 2 = 'Other Hispanic'
                 3 = 'Non-Hispanic White'
                 4 = 'Non-Hispanic Black'
                 6 = 'Non-Hispanic Asian'
                 7 = 'Other/Multiracial';

  VALUE bmifmt   1 = 'Underweight (<18.5)'
                 2 = 'Normal (18.5-24.9)'
                 3 = 'Overweight (25-29.9)'
                 4 = 'Obese (>=30)';
RUN;


/* --- Section 2: Survey Design Note --- */

/* NHANES uses a complex multistage probability sampling design.
   Some groups (older adults, minorities) were intentionally
   oversampled. Survey weights correct for this so results
   represent the entire U.S. adult population.

   Three components required for all SURVEY procedures:
     WEIGHT  WTMECPRP  -- sampling weight (renamed from WTMEC2YR
                          in the 2017-2020 pre-pandemic cycle)
     CLUSTER SDMVPSU   -- primary sampling unit
     STRATA  SDMVSTRA  -- sampling stratum

   Note: 712 participants have zero weights and are automatically
   excluded by SAS. This is expected and correct behavior. */


/* --- Section 3: Weighted Prevalence Tables --- */

/* Table 1: Overall weighted prevalence of diabetes */
/* Headline finding: true nationally representative estimate */
PROC SURVEYFREQ DATA=nhanes.analysis_clean;
  WEIGHT  WTMECPRP;
  CLUSTER SDMVPSU;
  STRATA  SDMVSTRA;
  TABLES diabetes / CL;
  TITLE 'Table 1: Weighted Prevalence of Diabetes Among U.S. Adults';
RUN;

/* Table 2: Diabetes prevalence by sex */
PROC SURVEYFREQ DATA=nhanes.analysis_clean;
  WEIGHT  WTMECPRP;
  CLUSTER SDMVPSU;
  STRATA  SDMVSTRA;
  TABLES RIAGENDR * diabetes / ROW CL;
  TITLE 'Table 2: Diabetes Prevalence by Sex';
RUN;

/* Table 3: Diabetes prevalence by race/ethnicity */
PROC SURVEYFREQ DATA=nhanes.analysis_clean;
  WEIGHT  WTMECPRP;
  CLUSTER SDMVPSU;
  STRATA  SDMVSTRA;
  TABLES RIDRETH3 * diabetes / ROW CL;
  TITLE 'Table 3: Diabetes Prevalence by Race/Ethnicity';
RUN;

/* Table 4: Diabetes prevalence by BMI category */
PROC SURVEYFREQ DATA=nhanes.analysis_clean;
  WEIGHT  WTMECPRP;
  CLUSTER SDMVPSU;
  STRATA  SDMVSTRA;
  TABLES bmi_cat * diabetes / ROW CL;
  TITLE 'Table 4: Diabetes Prevalence by BMI Category';
RUN;

/* Table 5: Mean BMI and age by diabetes status */
/* Added in Week 3, Step 8 */
PROC SURVEYMEANS DATA=nhanes.analysis_clean MEAN STDERR CLM;
  WEIGHT  WTMECPRP;
  CLUSTER SDMVPSU;
  STRATA  SDMVSTRA;
  DOMAIN  diabetes;
  VAR     BMXBMI RIDAGEYR;
  TITLE 'Table 5: Mean BMI and Age by Diabetes Status';
RUN;
/* ============================================================
   Week 4: Logistic Regression
   Model 1: Unadjusted (crude) odds ratios for each predictor
   Model 2: Multivariable model -- all predictors simultaneously
   Note: REF= and EVENT= values must match formatted labels,
   not raw numeric codes. ODDSRATIO statement not supported
   in PROC SURVEYLOGISTIC -- odds ratios are produced automatically.
   ============================================================ */

/* Model 1: Unadjusted odds ratios */
PROC SURVEYLOGISTIC DATA=nhanes.analysis_clean;
  WEIGHT  WTMECPRP;
  CLUSTER SDMVPSU;
  STRATA  SDMVSTRA;
  CLASS RIAGENDR (REF='Female')
        RIDRETH3 (REF='Non-Hispanic White')
        bmi_cat  (REF='Normal (18.5-24.9)');
  MODEL diabetes(EVENT='Diabetic') = RIAGENDR RIDRETH3 bmi_cat RIDAGEYR;
  TITLE 'Model 1: Unadjusted Odds Ratios for Diabetes';
RUN;

/* Model 2: Multivariable -- all predictors simultaneously */
/* This is the model to report in your portfolio write-up */
PROC SURVEYLOGISTIC DATA=nhanes.analysis_clean;
  WEIGHT  WTMECPRP;
  CLUSTER SDMVPSU;
  STRATA  SDMVSTRA;
  CLASS RIAGENDR (REF='Female')
        RIDRETH3 (REF='Non-Hispanic White')
        bmi_cat  (REF='Normal (18.5-24.9)');
  MODEL diabetes(EVENT='Diabetic') = RIAGENDR RIDRETH3 bmi_cat RIDAGEYR INDFMPIR;
  TITLE 'Model 2: Adjusted Odds Ratios for Diabetes (Multivariable)';
RUN;
