library(dplyr)

if( !(file.exists("Source_Classification_Code.rds") & file.exists("summarySCC_PM25.rds")) ){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip")
  unzip("FNEI_data.zip")
}

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimoreData <- NEI[NEI$fips == "24510", ]
byYear <- group_by(baltimoreData, year)
plotData<-summarise(byYear, Total.Emissions = sum(Emissions, na.rm=TRUE))

png(filename="plot2.png", width=480, height=480)
plot(plotData, type="b", xlab="Year", ylab="Total Emissions in Baltimore", col="red", lwd=3)
dev.off()