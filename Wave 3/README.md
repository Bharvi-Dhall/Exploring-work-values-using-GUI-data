## Introduction
In this analysis we are investigating the factors which drive work values of 17-18-olds in the GUI study. Logistic regression has been used to find the variables that are associatxed with the work values and from previous main effect models gender has been found to be an important predictor which has strong association with the workvalues. <br>

<p> We are trying to access if interactions of the predictors with gender are significant and if they affect the work values. </p>



## List of scripts:

1. 00a_TD_datasetup.Rmd 
Reading in the data files in form of R objects from wave 1 and wave 2

2. 00b_TD_datasetup.Rmd 
Imputation of school type from wave 2 in wave 3. Also looking at the principal questionnaire to get the school ID.

3. 01_TD_DataWrangling.Rmd
Cleaning and organizing selected variables in the GUI dataset.

4. 02_TD_Modelling.Rmd
This file contains the code for modelling datasets. It also contains plots for visuzalizing the results of fitted models.

5. Shiny.R
Contains Shiny app for models implemented in 02_TD_Modelling.Rmd.

6. Varnames.R 
Contains a named vector for naming variables.


Some Notes:

Variable Region: Urban or Rural refers to the location of the household and has been derived from the Primary Caregivers Questionnaire (Wave 1)- This variable is only available in Wave 1

Run scripts in order 00a_TD, 00b_TD, 01_TD
