###################################################
## Exploratory Data Analysis Project 1 - plot3.R ##
## author: Van Hai Ho                            ##
###################################################

# Clean environment
rm(list=ls())

# Set working directory
setwd("./")

# Check if data directory exists, if not, create it.
if (!file.exists("../data")) {
    dir.create("../data")
}

# Download dataset if not already downloaded
downloadedDataFile <- "../data/household_power_consumption.zip"
if (!file.exists(downloadedDataFile)) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile=downloadedDataFile)
}

# Extract data file from downloaded zip file
hpcDataFile <- "../data/household_power_consumption.txt"
if (!file.exists(hpcDataFile)) {
    # Unzip downloaded file
    unzip(downloadedDataFile, exdir="../data")
}

# Load dataset
hpcData <- read.csv(hpcDataFile, header = TRUE, sep = ";", na.strings = "?")

# Data used for plotting
startDate <- as.Date("01/02/2007", "%d/%m/%Y")
endDate <- as.Date("02/02/2007", "%d/%m/%Y")

# Plotting data for 2 days in Feb 2007
hpcPlottingData <- subset(hpcData, as.Date(Date, "%d/%m/%Y") >= startDate & as.Date(Date, "%d/%m/%Y") <= endDate)

# Read in date/time info in format 'dd/mm/YYYY H:M:S'
hpcDateTime <- paste(hpcPlottingData$Date, hpcPlottingData$Time)
hpcPlottingDateTime <- strptime(hpcDateTime, "%d/%m/%Y %H:%M:%S")
hpcPlottingData <- cbind(hpcPlottingData, hpcPlottingDateTime)

# melt data in order to plot all three sub metering in the same plot
library(reshape2)
hpcSubMeterMelt <- melt(hpcPlottingData, 
                        id.vars = c("hpcPlottingDateTime"),
                        measure.vars = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                        value.name = "Sub_metering",
                        na.rm = TRUE)

# Plot Energy sub metering 1, 2, 3
par(mar = c(2, 4, 2, 2))
with(hpcSubMeterMelt, 
     plot(hpcPlottingDateTime, 
          Sub_metering, 
          type = "n",
          xlab = "",
          ylab = "Energy sub metering"))
with(subset(hpcSubMeterMelt, variable == "Sub_metering_1"), 
     lines(hpcPlottingDateTime, 
           Sub_metering, 
           type = "l",
           col = "black"))
with(subset(hpcSubMeterMelt, variable == "Sub_metering_2"), 
     lines(hpcPlottingDateTime, 
           Sub_metering, 
           type = "l",
           col = "red"))
with(subset(hpcSubMeterMelt, variable == "Sub_metering_3"), 
     lines(hpcPlottingDateTime, 
           Sub_metering, 
           type = "l",
           col = "blue"))

legend("topright", 
       col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lwd = 1, lty = c(1, 1, 1), 
       pch = c(NA, NA, NA), 
       xjust = 1, yjust = 0.5)

# Copy plot to a PNG file
dev.copy(png, file = "plot3.png") 
# Close png device
dev.off() 
