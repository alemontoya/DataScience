
### Peer-graded Assignment: Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set.  

The goal is to prepare tidy data that can be used for later analysis. 

The assigment will be graded by my peers on a series of yes/no questions related to the project.  

I will be required to submit:  

* **A tidy data set** with the mean of every variable extracted (these variables are the mean and standard deviation of each one of the variables in the experiment) by subject and activity
* **A link to a Github repository** with my script for performing the analysis
* **A code book** that describes the variables, the data, and any transformations or work that I performed to clean up the data called CodeBook.md
* **A readMe.md file** in the Github repository where I explain the how to use the scripts (if you're reading this file, then it means that this requirement is met :) )

In the repository, you, the marker, will find the following 3 files:

* **run_analysis.R:** This file has all the steps that I performed to get to the tidy data set asked for
* **summ_features_by_activity_subject.txt:** This file contains the tidy data set asked for
* **CodeBook.pdf:** This file has 2 main sections:  
  **"Strategy and Code description"** that explains all the transformations that I did in order to fulfill the objectives of the assignment;  
  **"Variable Description"** that adds a description to each one of the variables available in the output file
  
Please review both, the run_analysis.R and the CodeBook.pdf files side by side, as they will give you all the information needed for understanding each step.

At the end, you can load the **summ_features_by_activity_subject.txt** file into an R data frame by running the read.table() command.

***Please note that the file contains the column headers***
