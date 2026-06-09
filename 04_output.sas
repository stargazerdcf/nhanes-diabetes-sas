/* ============================================================
   Project:  NHANES Diabetes Prevalence Analysis
   Author:   Donna Chandler-Ferguson
   Date:     2026
   Purpose:  Exports key results tables to a formatted RTF
             document suitable for portfolio presentation.
   Input:    nhanes.analysis_clean
   Output:   Results_Tables.rtf
   Note:     AI-assisted development workflow used throughout
             this project. See README.md for methodology details.
   ============================================================ */


/* --- Section 1: Library and Format Setup --- */

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


/* --- Section 2: Export Results to RTF --- */

/* ODS RTF sends all output between ODS RTF and ODS RTF CLOSE
   to a formatted Word-compatible document.
   Note: NOCOL is not supported in PROC SURVEYFREQ --
   use NOPERCENT only to suppress column percentages. */

ODS RTF FILE='/home/u664441/sasuser.v94/NHANESDiabetes/Results_Tables.rtf'
    STYLE=Journal;

  /* Table 1: Overall weighted prevalence */
  PROC SURVEYFREQ DATA=nhanes.analysis_clean;
    WEIGHT  WTMECPRP;
    CLUSTER SDMVPSU;
    STRATA  SDMVSTRA;
    TABLES diabetes / CL;
    TITLE 'Table 1: Weighted Prevalence of Diagnosed Diabetes, U.S. Adults 2017-2020';
  RUN;

  /* Table 2: Prevalence by sex */
  PROC SURVEYFREQ DATA=nhanes.analysis_clean;
    WEIGHT  WTMECPRP;
    CLUSTER SDMVPSU;
    STRATA  SDMVSTRA;
    TABLES RIAGENDR * diabetes / ROW CL NOPERCENT;
    TITLE 'Table 2: Diabetes Prevalence by Sex';
  RUN;

  /* Table 3: Prevalence by race/ethnicity */
  PROC SURVEYFREQ DATA=nhanes.analysis_clean;
    WEIGHT  WTMECPRP;
    CLUSTER SDMVPSU;
    STRATA  SDMVSTRA;
    TABLES RIDRETH3 * diabetes / ROW CL NOPERCENT;
    TITLE 'Table 3: Diabetes Prevalence by Race/Ethnicity';
  RUN;

  /* Table 4: Prevalence by BMI category */
  PROC SURVEYFREQ DATA=nhanes.analysis_clean;
    WEIGHT  WTMECPRP;
    CLUSTER SDMVPSU;
    STRATA  SDMVSTRA;
    TABLES bmi_cat * diabetes / ROW CL NOPERCENT;
    TITLE 'Table 4: Diabetes Prevalence by BMI Category';
  RUN;

  /* Table 5: Mean BMI and age by diabetes status */
  PROC SURVEYMEANS DATA=nhanes.analysis_clean MEAN STDERR CLM;
    WEIGHT  WTMECPRP;
    CLUSTER SDMVPSU;
    STRATA  SDMVSTRA;
    DOMAIN  diabetes;
    VAR     BMXBMI RIDAGEYR;
    TITLE 'Table 5: Mean BMI and Age by Diabetes Status';
  RUN;

  /* Table 6: Adjusted odds ratios -- multivariable model */
  PROC SURVEYLOGISTIC DATA=nhanes.analysis_clean;
    WEIGHT  WTMECPRP;
    CLUSTER SDMVPSU;
    STRATA  SDMVSTRA;
    CLASS RIAGENDR (REF='Female')
          RIDRETH3 (REF='Non-Hispanic White')
          bmi_cat  (REF='Normal (18.5-24.9)');
    MODEL diabetes(EVENT='Diabetic') = RIAGENDR RIDRETH3 bmi_cat RIDAGEYR INDFMPIR;
    TITLE 'Table 6: Adjusted Odds Ratios for Diabetes (Multivariable Model)';
  RUN;

ODS RTF CLOSE;