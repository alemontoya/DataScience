setwd("D://Personal//RProjects//Exploring Data//Projects//Week2")
#Load the data from work directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get a data frame with the summary of Total Emissions by Year
emmByYear <- summarise(group_by(NEI, year), Total.Emissions = sum(Emissions), Total.Observations = n())
#Create the plot
png("plot1.png")
#First add lines
with (emmByYear, plot(year, Total.Emissions, main = "Total PM2.5 Emissions by Year", xlab = "Year", ylab = "Total PM2.5 Emissions (tons)", col = "blue", type = "l"))
#Add each point to the plot
with (emmByYear, points(year, Total.Emissions, pch = 19, col = "blue"))
with (emmByYear, text(year, Total.Emissions, labels = paste(formatC(Total.Observations, format = "d", big.mark = ","), " obs"), cex = 0.8, col = "black", pos = c(4,1,3,2) ))
dev.off()
#

#Baltimore Total Emissions by year
BaltemmByYear <- summarise(group_by(subset(NEI, fips == "24510"), year), Total.Emissions = sum(Emissions), Total.Observations = n())
png("plot2.png")
with (BaltemmByYear, plot(year, Total.Emissions, main = "Total PM2.5 Emissions by Year in Baltimore City", xlab = "Year", ylab = "Total PM2.5 Emissions (tons)", col = "blue", type = "l"))
with (BaltemmByYear, points(year, Total.Emissions, pch = 19, col = "blue"))
with (BaltemmByYear, text(year, Total.Emissions, labels = paste(formatC(Total.Observations, format = "d", big.mark = ","), " obs"), cex = 0.8, col = "black", pos = c(4,1,3,2) ))
dev.off()

#Total Emissions by emission type by year
library(dplyr)
library(ggplot2)
baltEmmByTypeByYear <- summarise(group_by(subset(NEI, fips == "24510"), year, type), Total.Emissions = sum(Emissions), Total.Observations = n())
png("plot3.png")
plot3 <- qplot(year, Total.Emissions, data = baltEmmByTypeByYear, facets = .~type, main = "Total PM2.5 Emissions by Year by Source Type - Baltimore City", xlab = "Year", ylab = "Total Pm2.5 Emissions (tons)")
plot3 + geom_point() + geom_smooth(method = "lm") + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + theme(panel.background = element_rect(fill = "khaki"))
dev.off()


#Total PM2.5 emissions from Coal combustion related sources in all USA by year
coalSCC <- filter(SCC, grepl("[C]oal",Short.Name))
coalEmmByYear <- summarise(group_by(subset(NEI, SCC %in% coalSCC$SCC), year), Total.Emissions = sum(Emissions), Total.Observations = n())
png("plot4.png")
with (coalEmmByYear, plot(year, Total.Emissions, main = "Total PM2.5 Emissions by Year - Coal Combustion Related Sources", xlab = "Year", ylab = "Total PM2.5 Emissions (tons)", col = "blue", type = "l"))
with (coalEmmByYear, points(year, Total.Emissions, pch = 19, col = "blue"))
with (coalEmmByYear, text(year, Total.Emissions, labels = paste(formatC(Total.Observations, format = "d", big.mark = ","), " obs"), cex = 0.8, col = "black", pos = c(4,1,3,2) ))
dev.off()

#Total PM2.5 emissions from motor vehicle sources in Baltimore City by year
motorVehicleSCC <- filter(SCC, grepl("[Mm]otor",Short.Name) & grepl("[Mm]obile",EI.Sector))
baltMotorEmmByYear <- summarise(group_by(subset(NEI, SCC %in% motorVehicleSCC$SCC & fips == "24510"), year), Total.Emissions = sum(Emissions), Total.Observations = n())
png("plot5.png")
with (baltMotorEmmByYear, plot(year, Total.Emissions, main = "Total PM2.5 Emissions by Year - Motor Vehicules Sources\n Baltimore City", xlab = "Year", ylab = "Total PM2.5 Emissions (tons)", col = "blue", type = "l"))
with (baltMotorEmmByYear, points(year, Total.Emissions, pch = 19, col = "blue"))
with (baltMotorEmmByYear, text(year, Total.Emissions, labels = paste(formatC(Total.Observations, format = "d", big.mark = ","), " obs"), cex = 0.8, col = "black", pos = c(4,1,3,2) ))
dev.off()

#
baltLAMotorEmmByYear <- summarise(group_by(subset(NEI, SCC %in% motorVehicleSCC$SCC & (fips == "06037" | fips == "24510")), year, fips), Total.Emissions = sum(Emissions), Total.Observations = n())
png("plot6.png")
plot6 <- qplot(year, Total.Emissions, data = baltLAMotorEmmByYear, facets = .~fips, main = "Total PM2.5 Emissions by Year by County (LA vs. Baltimore)", xlab = "Year", ylab = "Total Pm2.5 Emissions (tons)")
plot6 + geom_point() + geom_smooth(method = "lm") + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + theme(panel.background = element_rect(fill = "khaki"))
dev.off()
