library(dplyr)
library(ggplot2)

if( !(file.exists("Source_Classification_Code.rds") & file.exists("summarySCC_PM25.rds")) ){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip")
  unzip("FNEI_data.zip")
}

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimoreData <- NEI[NEI$fips == "24510", ]
plotData <- data.frame(year = integer(0), Total.Emissions = numeric(0), type=character(0))
for (t in unique(NEI$type)){
  rows <- filter(NEI, type==t)
  byYear <- group_by(rows, year)
  typeSummary <- summarise(byYear, Total.Emissions = sum(Emissions, na.rm=TRUE), type=t)
  plotData <- rbind(plotData, typeSummary)
}

png(filename="plot3.png", width=480, height=480)
qplot(year, Total.Emissions,  data = plotData, facets =  type ~ ., xlab="Year", ylab="Total Emissions")
dev.off()