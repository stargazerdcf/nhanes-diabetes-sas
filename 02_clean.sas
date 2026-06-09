/* ============================================================
   Project:  NHANES Diabetes Prevalence Analysis
   Author:   Donna Chandler-Ferguson
   Date:     2026
   Purpose:  Merges three NHANES datasets, recodes variables,
             and produces a clean analysis-ready dataset.
   Input:    nhanes.P_DEMO, nhanes.P_DIQ, nhanes.P_BMX
   Output:   nhanes.analysis_clean (~9,400 adult participants)
   Note:     AI-assisted development workflow used throughout
             this project. See README.md for methodology details.
   ============================================================ */


/* --- Section 1: Library Setup --- */

LIBNAME nhanes '/home/u664441/sasuser.v94/NHANESDiabetes';


/* --- Section 2: Define Formats --- */

/* Formats must be defined each session to display readable labels.
   These convert numeric codes to meaningful text in output tables. */

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


/* --- Section 3: Sort Datasets Before Merging --- */

/* SAS requires datasets to be sorted by the merge key (SEQN)
   before a BY-variable merge. Skipping this causes errors. */

PROC SORT DATA=nhanes.P_DEMO;
  BY SEQN;
RUN;

PROC SORT DATA=nhanes.P_DIQ;
  BY SEQN;
RUN;

PROC SORT DATA=nhanes.P_BMX;
  BY SEQN;
RUN;


/* --- Section 4: Merge Datasets --- */

/* Merge all three files on SEQN (unique participant ID).
   IN= flags track which datasets each participant appears in.
   IF inDemo keeps only participants in the demographics file
   (the master sample list). Participants in DIQ or BMX but
   not DEMO are excluded. Only needed variables are retained. */

/* Note: WTMECPRP is the correct survey weight variable name
   for the 2017-2020 pre-pandemic cycle. Earlier cycles used
   WTMEC2YR. Always check the codebook for your cycle. */

DATA nhanes.analysis_raw;
  MERGE nhanes.P_DEMO (IN=inDemo KEEP=SEQN RIDAGEYR RIAGENDR RIDRETH3
                                      WTMECPRP SDMVPSU SDMVSTRA INDFMPIR)
        nhanes.P_DIQ  (IN=inDiq  KEEP=SEQN DIQ010)
        nhanes.P_BMX  (IN=inBmx  KEEP=SEQN BMXBMI);
  BY SEQN;
  /* P_DEMO is the master participant list */
  IF inDemo;
RUN;

/* Expected output: 15560 observations, 10 variables */
PROC CONTENTS DATA=nhanes.analysis_raw;
RUN;


/* --- Section 5: Clean and Recode Variables --- */

DATA nhanes.analysis_clean;
  SET nhanes.analysis_raw;

  /* Restrict to adults 18 and older */
  IF RIDAGEYR < 18 THEN DELETE;

  /* --- Diabetes outcome variable ---
     DIQ010 raw codes: 1=Yes, 2=No, 3=Borderline, 7=Refused, 9=Don't know
     Recode to binary: 1=Diabetic, 0=Non-Diabetic, .=All others */
  IF      DIQ010 = 1 THEN diabetes = 1;
  ELSE IF DIQ010 = 2 THEN diabetes = 0;
  ELSE                    diabetes = .;

  /* --- BMI category ---
     Standard WHO classification */
  IF      BMXBMI <  18.5 THEN bmi_cat = 1;  /* Underweight */
  ELSE IF BMXBMI <  25   THEN bmi_cat = 2;  /* Normal      */
  ELSE IF BMXBMI <  30   THEN bmi_cat = 3;  /* Overweight  */
  ELSE IF BMXBMI >= 30   THEN bmi_cat = 4;  /* Obese       */
  /* Missing BMI stays missing (.) automatically */

  /* --- Age group --- */
  IF      RIDAGEYR < 40 THEN age_group = 1;  /* 18-39 */
  ELSE IF RIDAGEYR < 60 THEN age_group = 2;  /* 40-59 */
  ELSE                       age_group = 3;  /* 60+   */

  /* Attach formats for readable output */
  FORMAT diabetes  diabfmt.
         RIAGENDR  sexfmt.
         RIDRETH3  racefmt.
         bmi_cat   bmifmt.;

  /* Drop participants with missing diabetes status
     (includes borderline, refused, don't know, and
     those not present in the DIQ file) */
  IF diabetes = . THEN DELETE;

  /* Variable labels for output tables */
  LABEL
    diabetes  = 'Diagnosed Diabetes (Yes/No)'
    RIDAGEYR  = 'Age (years)'
    RIAGENDR  = 'Sex'
    RIDRETH3  = 'Race/Ethnicity'
    BMXBMI    = 'Body Mass Index'
    bmi_cat   = 'BMI Category'
    age_group = 'Age Group'
    INDFMPIR  = 'Poverty-Income Ratio';
RUN;


/* --- Section 6: Verify Clean Dataset --- */

/* Expected: ~9,421 observations, 13 variables */
PROC CONTENTS DATA=nhanes.analysis_clean;
RUN;

/* Check diabetes counts -- should show ~85% Non-Diabetic, ~15% Diabetic */
/* Note: These are unweighted counts. See 03_analysis.sas for
   nationally representative weighted estimates. */
PROC FREQ DATA=nhanes.analysis_clean;
  TABLES diabetes / MISSING;
RUN;
