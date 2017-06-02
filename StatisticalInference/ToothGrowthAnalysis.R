#Load libraries that will be used
library(datasets)
library(ggplot2)
library(knitr)
library(dplyr)


######## Data Loading #############

#Loads the data into a data frame
data(ToothGrowth)

#Gives a first glance at the data
str(ToothGrowth)

######## Visual Exploration and Analysis #############

#Creates a histogram with a density plot and a line with the mean for every
#group
g <- ggplot(ToothGrowth, aes(x = len))
g <- g + geom_histogram(aes(y=..density..), 
                        fill = "sienna2", 
                        color = "black", 
                        bins = 5)
g <- g + geom_density(alpha = 0.5, fill = "skyblue3")
g <- g + geom_vline(data=aggregate(ToothGrowth[1], ToothGrowth[c(2,3)], mean), 
                    mapping=aes(xintercept=len), 
                    color="red", 
                    linetype = "dashed") 
g <- g + facet_grid(supp~dose)
g <- g + xlab("Length") + ylab("Density") 
g <- g + ggtitle("Histogram, Densitiy and Mean by Supplement and Dose")
g

######## Numeric Exploration and Analysis #############

#Creates a data frame with the summary of the statistics by Supplement and Dose
df_StatsSumm <- data.frame(summarise(group_by(ToothGrowth, supp, dose), 
                                     Length.Mean = mean(len), 
                                     Length.Max = max(len), 
                                     Length.Min = min(len), 
                                     Length.Variance = var(len), 
                                     Length.StdDev = sd(len), 
                                     Length.Observations = n()))

#Creates a knitr table to show the results
kable(df_StatsSumm, 
      caption = "Summary by Supplement and Dose", 
      col.names = c("Supplement", "Dose", "Mean Length", "Max Length", 
                    "Min Length", "Variance", "Std Dev", "Observations"),
      digits = 3
)


#Creates a data frame with the supp and len values when the dose is 0.5, 1 and 2 
#respectively
df_Dose_0.5 <- subset(ToothGrowth, dose == 0.5)
df_Dose_1 <- subset(ToothGrowth, dose == 1)
df_Dose_2 <- subset(ToothGrowth, dose == 2)

#Run the t.test on the data frames
t.test.results_0.5 <- t.test(len ~ supp, data=df_Dose_0.5)
t.test.results_1 <- t.test(len ~ supp, data=df_Dose_1)
t.test.results_2 <- t.test(len ~ supp, data=df_Dose_2)

#Creates a data frame to store the results
#Adds the results of the test with dose = 0.5
df_testResults <- data.frame(c("0.5 mg/day"), 
                             c(round(t.test.results_0.5$p.value,4)), 
                             c(paste(round(t.test.results_0.5$conf.int[1],2), 
                                     round(t.test.results_0.5$conf.int[2],2), 
                                     sep = ", ")),
                             c(ifelse(between(0, 
                                              t.test.results_0.5$conf.int[1], 
                                              t.test.results_0.5$conf.int[2]), 
                                      "Failed to reject null hypothesis", 
                                      "Reject null hypothesis" )),
                             stringsAsFactors = FALSE)

#Adds the results of the test with dose = 1
df_testResults <- rbind(df_testResults, c("1 mg/day", 
                                          round(t.test.results_1$p.value,4), 
                                          paste(round(t.test.results_1$conf.int[1],2), 
                                                round(t.test.results_1$conf.int[2],2), 
                                                sep = ", "),
                                          ifelse(between(0, 
                                                         t.test.results_1$conf.int[1], 
                                                         t.test.results_1$conf.int[2]), 
                                                 "Failed to reject null hypothesis", 
                                                 "Reject null hypothesis" )
)
)

#Adds the results of the test with dose = 2
df_testResults <- rbind(df_testResults, c("2 mg/day", 
                                          round(t.test.results_2$p.value,4), 
                                          paste(round(t.test.results_2$conf.int[1],2), 
                                                round(t.test.results_2$conf.int[2],2), 
                                                sep = ", "),
                                          ifelse(between(0, 
                                                         t.test.results_2$conf.int[1], 
                                                         t.test.results_2$conf.int[2]), 
                                                 "Failed to reject null hypothesis", 
                                                 "Reject null hypothesis" )
)
)

#Creates a knitr table with the results
kable(df_testResults, 
      col.names = c("Dose", "P Value", "Conf. Interval", "Decision"),
      caption = "Hypothesis Testing: Confidence Intervals by Dose",
      digits = 4)