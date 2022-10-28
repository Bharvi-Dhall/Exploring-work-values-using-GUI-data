# Exploring-work-values-using-GUI-data
This repository contains scripts for analysing and visualizing the career choices of Irish Adolescents. 


This repository contains:
- A script to read in raw data sets.


# Data
The data used for this analysis is Growing up In Ireland Cohort ’98 (Child Cohort).

- Wave 3 - 17/18 years, 2016 data set can be accessed through the Irish Social Science Data Archive(ISSDA) https://www.ucd.ie/issda/
data/guichild/guichildwave3/

- Wave 4 - 20 years, 2019 data set can be requested through the Irish Social Science Data Archive(ISSDA) https://www.ucd.ie/issda/
data/guichild/guichildwave4/
51



### Data Files
Each wave has two spss files (GUI and time use data sets).
Naming of the files:
* GUI_ has time use data
* XGUI_ has GUI survey data

Example:
GUI_Data_9YearCohort_Wave1_TimeUse.sav -- contains the time use data for 9 year olds from Wave 1 
XGUI_Data_9YearCohort_Wave1.sav --  contains GUI survey data for 9 year olds from Wave 1

## Scripts

File : Read_Rawdata_script.Rmd
This file contains a script to read in data from different waves and create R objects.

