
#Loads the sqldf library as we are going to use it to filter the data while uploading
library(sqldf)
#Reads the data from the file
#Note: It uses the sqldf library to filter the file on loading so we don't upload huge amounts of data that 
#      we won't be using
data <- read.csv.sql(file = file.path(getwd(), "household_power_consumption.txt"), 
                     sql = "select * from file where Date = '1/2/2007' or Date = '2/2/2007'", #This statement filters the data to upload only the 1st and the 2nd of Feb 2007
                     header = TRUE, #This parameter tells the function that there's a header in the first line of the file
                     sep = ";" #This parameter tells the function that the fields in the file are separated by ";" instead of ","
                     )
#We create a new column to the data frame to add the date and time as a POSIXlt column so we can plot it easier as a time series
data[["DateTime"]] <- strptime(paste(data$Date, data$Time, sep = ""), "%d/%m/%Y %H:%M:%S")
#We open the PNG Graphics Device and give it the name we want to use
png(filename = "plot1.png")
#We create and plot the histogram of the Global_active_power variable
hist(data$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
#We close the PNG Graphics Device
dev.off()