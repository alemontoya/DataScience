
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
png(filename = "plot3.png")
#We set a new blank plot (i.e. we don't put any data just yet)
plot(data$DateTime, data$Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
#We plot the lines that represent the Sub Metering 1 values as black lines
with(data, lines(DateTime, Sub_metering_1, col = "black"))
#We plot the lines that represent the Sub Metering 2 values as red lines
with(data, lines(DateTime, Sub_metering_2, col = "red"))
#We plot the lines that represent the Sub Metering 3 values as blue lines
with(data, lines(DateTime, Sub_metering_3, col = "blue"))
#We add the legends to the top right corner of the plot area, using the colors and names of the variables previosuly plotted, and using full lines as plotting characters
legend("topright",col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = 1, lty = 1)
#We close the PNG Graphics Device
dev.off()