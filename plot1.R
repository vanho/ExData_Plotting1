###################################################
## Exploratory Data Analysis Project 1 - plot1.R ##
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

# Plot Global Active Power on screen device
with(hpcPlottingData, 
     hist(Global_active_power, 
          col = "red", 
          main = "Global Active Power", 
          xlab = "Global Active Power (kilowatts)"))

# Copy plot to a PNG file
dev.copy(png, file = "plot1.png") 
# Close png device
dev.off() 

