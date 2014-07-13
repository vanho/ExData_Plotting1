###################################################
## Exploratory Data Analysis Project 1 - plot2.R ##
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

# Plot Energy sub metering 2 selected days
library(reshape2)
library(ggplot2)
library(scales)
library(grid)

# melt data in order to plot all three sub metering in the same plot
hpcSubMeterMelt <- melt(hpcPlottingData, 
                        id.vars = c("Date", "Time"),
                        measure.vars = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Read in date/time info in format 'dd/mm/YYYY H:M:S'
hpcDateTime <- paste(hpcSubMeterMelt$Date, hpcSubMeterMelt$Time)
hpcPlottingDateTime <- strptime(hpcDateTime, "%d/%m/%Y %H:%M:%S")

hpcSubMeteringPlot <- ggplot(hpcSubMeterMelt)
hpcSubMeteringPlot + 
    geom_line(aes(x = hpcPlottingDateTime, y = value, colour = variable)) +
    theme_bw() + 
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          axis.line = element_line(colour = "black"),
          legend.background = element_rect(colour = "black"),
          legend.margin = unit(0, "lines"),
          legend.key = element_blank(),
          legend.justification = c(1, 1),
          legend.position = c(1, 1),
          legend.box.just = c(1, 1),
          legend.title = element_blank()) +
    scale_colour_manual(values = c("black", "red", "blue")) +
    scale_x_datetime(breaks = date_breaks("1 days"),
                     labels = date_format("%a")) + 
    xlab("") + ylab("Energy sub metering")

# Copy plot to a PNG file
dev.copy(png, file = "plot3.png") 
# Close png device
dev.off() 
