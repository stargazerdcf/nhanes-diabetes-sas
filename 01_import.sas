/* ============================================================
   Project:  NHANES Diabetes Prevalence Analysis
   Author:   Donna Chandler-Ferguson
   Date:     2026
   Purpose:  Imports CDC NHANES 2017-2020 pre-pandemic XPT files
             into permanent SAS datasets for analysis.
   Data:     CDC NHANES 2017-2020 Pre-pandemic cycle
             P_DEMO.xpt, P_DIQ.xpt, P_BMX.xpt
   Note:     AI-assisted development workflow used throughout
             this project. See README.md for methodology details.
   ============================================================ */


/* --- Section 1: Library Setup --- */

/* Point SAS to the project folder */
/* Note: sasuser.v94 is required in the path for SAS OnDemand */
LIBNAME nhanes '/home/u664441/sasuser.v94/NHANESDiabetes';


/* --- Section 2: Import XPT Files --- */

/* XPT is SAS transport format used by CDC for data distribution.
   PROC COPY reads each XPT file and saves a permanent SAS dataset
   (.sas7bdat) in the nhanes library. This only needs to be run once. */

/* Import Demographics file (P_DEMO) */
/* Contains: age, sex, race/ethnicity, income, survey weights */
LIBNAME xptdemo XPORT '/home/u664441/sasuser.v94/NHANESDiabetes/P_DEMO.xpt'
        ACCESS=READONLY;
PROC COPY IN=xptdemo OUT=nhanes;
RUN;

/* Import Diabetes Questionnaire (P_DIQ) */
/* Contains: diabetes diagnosis status (outcome variable) */
LIBNAME xptdiq XPORT '/home/u664441/sasuser.v94/NHANESDiabetes/P_DIQ.xpt'
        ACCESS=READONLY;
PROC COPY IN=xptdiq OUT=nhanes;
RUN;

/* Import Body Measures (P_BMX) */
/* Contains: BMI -- a key risk factor for diabetes */
LIBNAME xptbmx XPORT '/home/u664441/sasuser.v94/NHANESDiabetes/P_BMX.xpt'
        ACCESS=READONLY;
PROC COPY IN=xptbmx OUT=nhanes;
RUN;


/* --- Section 3: Verify Import --- */

/* Confirm all three datasets loaded correctly */
/* Expected: P_DEMO (15560 obs, 29 vars)
             P_DIQ  (14986 obs, 28 vars)
             P_BMX  (14300 obs, 22 vars) */
PROC CONTENTS DATA=nhanes._ALL_ NODS;
RUN;
