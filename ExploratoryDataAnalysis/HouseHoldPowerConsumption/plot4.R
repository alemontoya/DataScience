
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
png(filename = "plot4.png")
#We set up our canvas to receive 4 charts in a 2 x 2 matrix
par(mfrow = c(2,2))
#Our first chart plots the time series of Global Active Power consumption
plot(data$DateTime, data$Global_active_power, type = "l", xlab = "Date Time", ylab = "Global Active Power")
#Our second chart plots the time series of Voltage consumption
plot(data$DateTime, data$Voltage, type = "l", xlab = "Date Time", ylab = "Voltage")
#Our third chart plots the time series of the 3 Sub metering values as in the plot3.png chart
plot(data$DateTime, data$Sub_metering_1, type = "n", xlab = "Date Time", ylab = "Energy sub metering", col = "black")
with(data, lines(DateTime, Sub_metering_1, col = "black"))
with(data, lines(DateTime, Sub_metering_2, col = "red"))
with(data, lines(DateTime, Sub_metering_3, col = "blue"))
legend("topright",col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = 1, lty = 1)
#Our fourth and final chart, plots the time series of Global ReActive Power consumption
plot(data$DateTime, data$Global_reactive_power, type = "l", xlab = "Date Time", ylab = "Global ReActive Power")
#We close our PNG Graphics Device
dev.off()